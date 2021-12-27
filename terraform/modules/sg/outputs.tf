output "alb_sg_id" {
  description = "The security group identifier for the load balancer traffic"
  value       = aws_security_group.alb.id
}

output "ecs_sg_id" {
  description = "The security group identifier for the ECS cluster traffic"
  value       = aws_security_group.ecs.id
}
