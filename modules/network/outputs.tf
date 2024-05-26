output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_private_subnets" {
  description = "List of IDs for private subnets"
  value       = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  description = "List of IDs for public subnets"
  value       = module.vpc.public_subnets
}
