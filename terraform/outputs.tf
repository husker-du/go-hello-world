output "vpc_id" {
  description = "ID of the virtual private network"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "public_subnets" {
  value = values(aws_subnet.public).*.id
}

output "alb_dns_name" {
  description = "The load balancer endpoint"
  value       = aws_lb.alb.dns_name
}

output "ecs_cluster" {
  description = "The ECS cluster name"
  value       = aws_ecs_cluster.fargate.name
}

output "target_group" {
  description = "The load balancer target group id"
  value       = aws_alb_target_group.alb_ecs_http.ide
}