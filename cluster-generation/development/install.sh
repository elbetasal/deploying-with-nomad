#!/usr/bin/env bash
set -eox

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function get_instance_ip_address {
  lookup_path_in_instance_metadata "local-ipv4"
}

function get_instance_id {
  lookup_path_in_instance_metadata "instance-id"
}

function get_instance_availability_zone {
  lookup_path_in_instance_metadata "placement/availability-zone"
}

function get_instance_region {
  lookup_path_in_instance_dynamic_data "instance-identity/document" | jq -r ".region"
}

function lookup_path_in_instance_metadata {
  local readonly path="$1"
  curl --silent --location "$EC2_INSTANCE_METADATA_URL/$path/"
}

function lookup_path_in_instance_dynamic_data {
  local readonly path="$1"
  curl --silent --location "$EC2_INSTANCE_DYNAMIC_DATA_URL/$path/"
}

readonly EC2_INSTANCE_METADATA_URL="http://169.254.169.254/latest/meta-data"
readonly EC2_INSTANCE_DYNAMIC_DATA_URL="http://169.254.169.254/latest/dynamic"
readonly NOMAD_VERSION="0.12.0"
readonly CONSUL_VERSION="1.8.0"

sudo yum update -y
sudo amazon-linux-extras install docker
sudo usermod -aG docker ec2-user

sudo yum -y install jq docker

echo "Downloading consul ${CONSUL_VERSION}"
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
echo "Unzipping NOMAD"
sudo unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /usr/local/bin/
consul --version

###Creating the consul user
#sudo useradd --system --home /etc/consul.d --shell /bin/false consul
#sudo mkdir -p /opt/consul
#sudo chown -r consul:consul /opt/consul


echo "Downloading nomad ${NOMAD_VERSION}"
curl --silent --fail --remote-name https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
echo "Unzipping NOMAD"
sudo unzip nomad_${NOMAD_VERSION}_linux_amd64.zip -d /usr/local/bin/
nomad version

##Generating nomad config

sudo mkdir -p /opt/nomad
sudo cat > /etc/systemd/system/nomad.service << EOF
[Unit]
Description=Nomad
Documentation=https://nomadproject.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/nomad agent -config /etc/nomad.d --data-dir $SCRIPT_DIR/../nomad_data
KillMode=process
KillSignal=SIGINT
LimitNOFILE=infinity
LimitNPROC=infinity
Restart=on-failure
RestartSec=2
StartLimitBurst=3
StartLimitIntervalSec=10
TasksMax=infinity

[Install]
WantedBy=multi-user.target
EOF

sudo mkdir -p /etc/nomad.d
sudo chmod 777 /etc/nomad.d

sudo mkdir -p /etc/consul.d
sudo chmod 777 /etc/consul.d/

instance_id=$(get_instance_id)
instance_ip_address=$(get_instance_ip_address)
instance_region=$(get_instance_region)
availability_zone=$(get_instance_availability_zone)

sudo cat > /etc/systemd/system/consul.service << EOF
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target

[Service]
Type=notify
#User=consul
#Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/ --data-dir $SCRIPT_DIR/../consul_data
ExecReload=/usr/local/bin/consul reload
ExecStop=/usr/local/bin/consul leave
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

sudo cat > /etc/consul.d/consul.json << EOF
{
  "advertise_addr": "$instance_ip_address",
  "bind_addr": "$instance_ip_address",
  "bootstrap_expect" : 3,
  "client_addr": "0.0.0.0",
  "datacenter": "$instance_region",
  "node_name": "$instance_id",
  "retry_join": ["provider=aws region=$instance_region tag_key=Purpose tag_value=nomad-cluster"],
  "server": true,
  "ui": true
}
EOF

sudo cat > /etc/nomad.d/nomad.hcl << EOF
datacenter = "$availability_zone"
name       = "$instance_id"
region     = "$instance_region"
bind_addr  = "0.0.0.0"
advertise {
  http = "$instance_ip_address"
  rpc  = "$instance_ip_address"
  serf = "$instance_ip_address"
}
EOF

sudo cat > /etc/nomad.d/server.hcl << EOF
server {
  enabled = true
  bootstrap_expect = 3
#  server_join {
#    retry_join = ["provider=aws region=$instance_region tag_key=Purpose tag_value=nomad-cluster"]
#    retry_max = 1
#    retry_interval = "15s"
#  }

}
EOF

sudo cat > /etc/nomad.d/client.hcl << EOF
client {
  enabled = true
}
EOF

sudo systemctl enable nomad
sudo systemctl start nomad
sudo systemctl status nomad

sudo systemctl enable consul
sudo systemctl start consul
sudo systemctl status consul

sudo systemctl start docker

