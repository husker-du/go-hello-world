output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.lb_acm.alb_dns_name
}

output "vpc_id" {
  description = "VPC identifier."
  value       = module.network.vpc_id
}

output "ecr_repository_url" {
  description = "URL of the image repository"
  value       = module.ecr.repository_url
}
