terraform {
  source = "../../modules/app-lb"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.tier
  region   = local.env_vars.locals.region
  tags     = local.env_vars.locals.tags
}

dependencies {
  paths = ["../vpc"]
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id             = "vpc"
    vpc_public_subnets = ["10.1.0.0/16", "10.1.1.0/16", "10.1.2.0/16"]
  }
}

inputs = {

  name               = "${local.env}-react-app"
  vpc_id             = dependency.vpc.outputs.vpc_id
  vpc_public_subnets = dependency.vpc.outputs.vpc_public_subnets

  tags = local.tags

}