# This security group will allow traffic from the ALB to 
# backend instances
resource "aws_security_group" "instance_sg" {
  vpc_id      = var.vpc_id
  name = "${var.name}-instance"
  tags = var.tags

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    description = "Allow traffic to backend"
    security_groups = [ var.alb_security_group_id ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

}
