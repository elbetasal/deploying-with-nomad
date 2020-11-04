resource "aws_instance" "cluster-node" {
  ami = "ami-0947d2ba12ee1ff75"
  count = length(module.vpc.public_subnets)
  instance_type = "t3.micro"
  subnet_id = module.vpc.public_subnets[count.index]
  key_name = "encode-key"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_tls.id, aws_security_group.nomad_rules.id]
  tags = {
    Name = "cluster-development-${count.index}"
    Purpose = "nomad-cluster"
  }
  user_data = file("install.sh")
  iam_instance_profile = aws_iam_instance_profile.ec2-instance-profile.name
}

resource "aws_iam_role" "ec2-role" {
  name = "ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2-instance-profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2-role.name
}


resource "aws_iam_role_policy" "describe-instances-policy" {
  name = "ec2-instance-policies"
  role = aws_iam_role.ec2-role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
