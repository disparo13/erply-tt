variable "vpc_name" {
  description = "Value of the Name for the VPC network"
  default     = "node-app-vpc"
  type        = string
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.2.0.0/16"
  description = "CIDR block range for vpc"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.2.0.0/19", "10.2.32.0/19", "10.2.64.0/19"]
  description = "CIDR block range for the private subnet"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.2.128.0/20", "10.2.144.0/20", "10.2.160.0/20"]
  description = "CIDR block range for the public subnet"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
