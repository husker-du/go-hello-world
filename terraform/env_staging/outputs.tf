output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.lb.alb_dns_name
}

output "vpc_id" {
  description = "VPC identifier."
  value       = module.network.vpc_id
}
