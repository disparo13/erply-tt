locals {

  tier    = "stage"
  region  = "us-east-1"
  backend = "${local.tier}-${local.region}-tfstate"

  ag_min_size     = 1
  ag_max_size     = 1
  ag_desired_size = 1

  image = "disparo/app-react:latest"

  worker_node_instance_type = "t2.micro"

  vpc_cidr = "10.2.0.0/16"

  tags = {
    Tier      = local.tier
    Region    = local.region
    Terraform = true
  }

}
