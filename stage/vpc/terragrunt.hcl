terraform {
  source = "../../modules/network"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  env_vars   = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env        = local.env_vars.locals.tier
  region     = local.env_vars.locals.region
  vpc_cidr   = local.env_vars.locals.vpc_cidr
  vpc_number = split(".", local.vpc_cidr)[1]
  tags       = local.env_vars.locals.tags
}

inputs = {
  vpc_name       = "${local.env}-react"
  vpc_cidr_block = local.vpc_cidr

  private_subnet_cidr_blocks = [
    "10.${local.vpc_number}.0.0/19",
    "10.${local.vpc_number}.32.0/19",
    "10.${local.vpc_number}.64.0/19"
  ]

  public_subnet_cidr_blocks = [
    "10.${local.vpc_number}.128.0/20",
    "10.${local.vpc_number}.144.0/20",
    "10.${local.vpc_number}.160.0/20"
  ]

  tags = local.tags
}
