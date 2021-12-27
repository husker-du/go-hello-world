output "autoscaling_group_name" {
  description = "Name of the auto scaling group."
  value       = aws_autoscaling_group.ecs_cluster.name
}
