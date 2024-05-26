variable "name" {
    type = string
    description = "The Name for the ALB"
}

variable "vpc_id" {
    type = string
    description = "The id of the VPC to deploy the ALB"
}

variable "vpc_public_subnets" {
    type = list(string)
    description = "List of subnets to deploy the ALB"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
