resource "aws_autoscaling_group" "ecs_cluster" {
  name                      = "${var.ecs_cluster_name}_auto_scaling_group"
  min_size                  = var.min_replicas
  max_size                  = var.max_replicas
  desired_capacity          = var.autoscale_desired
  health_check_type         = "EC2"
  health_check_grace_period = 100
  launch_configuration      = aws_launch_configuration.ecs.name
  vpc_zone_identifier       = values(aws_subnet.public).*.id
  force_delete              = true
}

# Autoscaling targets the desired_count parameter of the ECS service
resource "aws_appautoscaling_target" "desired_count" {
  min_capacity       = var.min_replicas
  max_capacity       = var.max_replicas
  resource_id        = "service/${aws_ecs_cluster.ecs.name}/${aws_ecs_service.app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs_autoscaling.arn
}

# Autoscaling policy based on CPU utilization
resource "aws_appautoscaling_policy" "cpu_metrics" {
  name               = "cpu_metrics_scaling_policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.desired_count.resource_id
  scalable_dimension = aws_appautoscaling_target.desired_count.scalable_dimension
  service_namespace  = aws_appautoscaling_target.desired_count.service_namespace
  depends_on         = [aws_appautoscaling_target.desired_count]

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60 # Scale up/down when CPU utilization exceeds/falls behind 60%
  }
}
