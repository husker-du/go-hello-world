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

output "public_subnet_cidrs" {
  value = values(aws_subnet.public).*.cidr_block
}

output "private_subnet_cidrs" {
  value = values(aws_subnet.private).*.cidr_block
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
  description = "The load balancer ECS target group id"
  value       = aws_alb_target_group.ecs_http.id
}
