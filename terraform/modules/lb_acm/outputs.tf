output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  value       = aws_lb.alb.zone_id
}

output "alb_tg_arn" {
  description = "ARN of the load balancer target group."
  value       = aws_alb_target_group.ecs_http.arn
}

output "alb_name" {
  description = "The load balancer name."
  value       = aws_lb.alb.name
}
