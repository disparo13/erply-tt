variable "name" {
    type = string
    description = "Autoscaling Group Name"
}

variable "image" {
    type = string
    description = "Docker image to deploy"
}

variable "ag_min_size" {
    type = number
    description = "Min size of the Autoscaling group"
    default = 0
}

variable "ag_max_size" {
    type = number
    description = "Max size of the Autoscaling group"
    default = 1
}

variable "ag_desired_size" {
    type = number
    description = "Min size of the Autoscaling group"
    default = 1
}

variable "vpc_id" {
    type = string
    description = "VPC ID where instances will reside"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnets to deploy the instances"
}

variable "alb_target_group" {
  type        = string
  description = "ALB Target group to attach"
}

variable "worker_node_instance_type" {
    type = string
    description = "Worker Node instance type"
}

variable "alb_security_group_id" {
    type = string
    description = "ALB security group ID to allow traffic from"
}

variable "tags" {
    type = map(string)
    description = "Tags list to apply to all items"
}
