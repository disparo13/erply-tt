data "aws_availability_zones" "available" {
  state = "available"
}


locals {
  sorted_availability_zones   = sort(data.aws_availability_zones.available.names)
  selected_availability_zones = toset(local.sorted_availability_zones)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8.0"

  name                        = var.vpc_name
  cidr                        = var.vpc_cidr_block
  azs                         = local.selected_availability_zones
  private_subnets             = var.private_subnet_cidr_blocks
  public_subnets              = var.public_subnet_cidr_blocks
  default_security_group_name = "${var.vpc_name}-default-sg"
  default_security_group_tags = { "Name" : "${var.vpc_name}-default-sg" }
  enable_nat_gateway          = true
  single_nat_gateway          = true
  one_nat_gateway_per_az      = false
  enable_dns_hostnames        = true
  enable_flow_log             = false

  tags = var.tags

  public_subnet_tags = {
    "subnet_type" = "public"
  }

  private_subnet_tags = {
    "subnet_type" = "private"
  }
}
