# Get the available AMI of the Amazon Linux 2023
data "aws_ami" "base_ami" {
  most_recent      = true
  owners           = ["amazon"]
 
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
 
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 7.4.0"

  # Autoscaling group configuration
  name = var.name

  min_size                  = var.ag_min_size
  max_size                  = var.ag_max_size
  desired_capacity          = var.ag_desired_size
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.subnets

  # Traffic source attachment configuration
  create_traffic_source_attachment = true
  traffic_source_identifier        = var.alb_target_group
  traffic_source_type              = "elbv2"

  # Launch template configuration
  launch_template_name        = "${var.name}-lt"
  launch_template_description = "React template"
  update_default_version      = true

  image_id          = data.aws_ami.base_ami.id
  instance_type     = var.worker_node_instance_type
  security_groups   = [aws_security_group.instance_sg.id]
  user_data         = base64encode(templatefile("${path.module}/userdata.tfpl",{ image = "${var.image}" }))
  ebs_optimized     = false
  enable_monitoring = false

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = false
        volume_size           = 20
        volume_type           = "gp3"
      }
    }
  ]

  tags = var.tags

}
