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

output "public_subnets" {
  value = values(aws_subnet.public).*.id
}

output "alb_hostname" {
  value = aws_lb.alb.dns_name
}
