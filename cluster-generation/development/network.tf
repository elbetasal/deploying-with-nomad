module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "development-vpc"
  cidr = var.cidr_block

  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"]
  private_subnets = [
    "192.168.1.0/24",
    "192.168.2.0/24",
    "192.168.3.0/24"]
  public_subnets = [
    "192.168.101.0/24",
    "192.168.102.0/24",
    "192.168.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Environment = "development"
  }
}
