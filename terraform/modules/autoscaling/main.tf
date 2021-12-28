# Autoscaling up configuration policy based on CPU utilization
resource "aws_autoscaling_policy" "custom_cpu_scale_up" {
  name                   = "custom-cpu-metrics-scale-up-policy-${var.config.environment}"
  autoscaling_group_name = var.autoscaling_group_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1  # Scale up in 1 unit the capacity of the autoscaling group
  cooldown               = 90 # The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start
  policy_type            = "SimpleScaling"
}

# Cloudwatch monitoring for maximum CPU utilization
resource "aws_cloudwatch_metric_alarm" "custom_cpu_scale_up" {
  alarm_name          = "custom-cpu-metrics-scale-up-alarm-${var.config.environment}"
  alarm_description   = "Alarm once CPU usage increases"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2 # The number of periods over which data is compared to the specified threshold.
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 40

  dimensions = {
    "AutoScalingGroupName": var.autoscaling_group_name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.custom_cpu_scale_up.arn]
}

# Autoscaling down configuration policy based on CPU utilization
resource "aws_autoscaling_policy" "custom_cpu_scale_down" {
  name                   = "custom-cpu-metrics-scale-down-policy-${var.config.environment}"
  autoscaling_group_name = var.autoscaling_group_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1 # Scale down in 1 unit the capacity of the autoscaling group
  cooldown               = 90
  policy_type            = "SimpleScaling"
}

# Cloudwatch monitoring for minimum CPU utilization
resource "aws_cloudwatch_metric_alarm" "custom_cpu_scale_down" {
  alarm_name          = "custom-cpu-metrics-scale-down-alarm-${var.config.environment}"
  alarm_description   = "Alarm once CPU usage decreases"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    "AutoScalingGroupName" : var.autoscaling_group_name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.custom_cpu_scale_down.arn]
}
