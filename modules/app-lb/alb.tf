module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "~> 9.9.0"

  name                       = var.name
  vpc_id                     = var.vpc_id
  subnets                    = var.vpc_public_subnets
  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }

  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }


  listeners = {
    http-forward = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "app-instance"
      }
    }
  }

  target_groups = {
    app-instance = {
      name              = "react-app"
      protocol          = "HTTP"
      port              = 8080
      create_attachment = false

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 2
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200"
      }
    }
  }

  tags = var.tags

}
