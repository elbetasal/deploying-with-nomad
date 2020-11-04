resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_tls"
  }

}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow SSL access"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "nomad_rules" {
  name = "nomad_rules"
  description = "Allow Entry for all nomad ports"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "nomad_rules"
  }
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type        = "ingress"
  from_port   = var.http_port
  to_port     = var.http_port
  protocol    = "tcp"
  cidr_blocks = [var.cidr_block]

  security_group_id = aws_security_group.nomad_rules.id
}

resource "aws_security_group_rule" "allow_rpc_inbound" {
  type        = "ingress"
  from_port   = var.rpc_port
  to_port     = var.rpc_port
  protocol    = "tcp"
  cidr_blocks = [var.cidr_block]

  security_group_id = aws_security_group.nomad_rules.id
}

resource "aws_security_group_rule" "allow_serf_tcp_inbound" {
  type        = "ingress"
  from_port   = var.serf_port
  to_port     = var.serf_port
  protocol    = "tcp"
  cidr_blocks = [var.cidr_block]

  security_group_id = aws_security_group.nomad_rules.id
}

resource "aws_security_group_rule" "allow_serf_udp_inbound" {
  type        = "ingress"
  from_port   = var.serf_port
  to_port     = var.serf_port
  protocol    = "udp"
  cidr_blocks = [var.cidr_block]

  security_group_id = aws_security_group.nomad_rules.id
}

module "security_group_rules" {
  source = "git::git@github.com:hashicorp/terraform-aws-consul.git//modules/consul-security-group-rules"

  security_group_id = aws_security_group.nomad_rules.id
  allowed_inbound_cidr_blocks = [var.cidr_block]

}
