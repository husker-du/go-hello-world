# Autoscaling targets the desired_count parameter of the ECS service
resource "aws_appautoscaling_target" "desired_count" {
  max_capacity       = var.max_scale
  min_capacity       = var.min_scale
  resource_id        = "service/${var.ecs_cluster_name}-cluster/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Autoscaling policy based on CPU utilization
resource "aws_appautoscaling_policy" "cpu_metrics" {
  name               = "cpu_metrics_scaling_policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.desired_count.resource_id
  scalable_dimension = aws_appautoscaling_target.desired_count.scalable_dimension
  service_namespace  = aws_appautoscaling_target.desired_count.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60 # Scale up/down when CPU utilization exceeds/falls behind 60%
  }
}
