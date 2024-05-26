locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  backend  = local.env_vars.locals.backend
  region   = local.env_vars.locals.region
}

generate "providers-common" {
  path      = "providers-common.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.backend
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "${local.backend}-lock"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
