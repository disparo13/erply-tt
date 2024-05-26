output "alb_target_group_arn" {
    description = "Target group associated with the LB"
    value = module.alb.target_groups["app-instance"].arn
}

output "alb_security_group_id" {
    description = "ALB security group ID"
    value = module.alb.security_group_id
}

output "alb_dns_name" {
    description = "DNS name of the ALB"
    value = module.alb.dns_name
}
