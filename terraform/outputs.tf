output "vpc_id" {
  description = "ID of the virtual private network"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [ for subnet in aws_subnet.public : subnet.id ]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [ for subnet in aws_subnet.private : subnet.id ]
}

# output "alb_sg_id" {
#   description = "ALB security group id"
#   value = aws_security_group.alb.id
# }

# output "ecs_sg_id" {
#   description = "ECS security group id"
#   value       = aws_security_group.ecs.id
# }
