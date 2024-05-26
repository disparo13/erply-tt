terraform {
  source = "../../modules/autoscaling-group"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  env_vars                  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env                       = local.env_vars.locals.tier
  ag_min_size               = local.env_vars.locals.ag_min_size
  ag_max_size               = local.env_vars.locals.ag_max_size
  ag_desired_size           = local.env_vars.locals.ag_desired_size
  image                     = local.env_vars.locals.image
  worker_node_instance_type = local.env_vars.locals.worker_node_instance_type
  region                    = local.env_vars.locals.region
  tags                      = local.env_vars.locals.tags
}

dependencies {
  paths = ["../vpc", "../alb"]
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id              = "vpc"
    vpc_private_subnets = ["10.1.0.0/16", "10.1.1.0/16", "10.1.2.0/16"]
  }
}

dependency "alb" {
  config_path = "../alb"
  mock_outputs = {
    alb_target_group_arn  = "arn"
    alb_security_group_id = "sg-23456748"
  }
}

inputs = {

  name    = "${local.env}-react-app"
  vpc_id  = dependency.vpc.outputs.vpc_id
  subnets = dependency.vpc.outputs.vpc_private_subnets

  ag_min_size     = local.ag_min_size
  ag_max_size     = local.ag_max_size
  ag_desired_size = local.ag_desired_size

  image = local.image

  alb_target_group      = dependency.alb.outputs.alb_target_group_arn
  alb_security_group_id = dependency.alb.outputs.alb_security_group_id

  worker_node_instance_type = local.worker_node_instance_type

  tags = local.tags

}
