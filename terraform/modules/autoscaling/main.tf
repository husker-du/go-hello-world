# Autoscaling up configuration policy based on CPU utilization
resource "aws_autoscaling_policy" "custom_cpu_scale_up" {
  name                   = "custom-cpu-metrics-scale-up-policy-${var.config.environment}"
  autoscaling_group_name = var.autoscaling_group_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
  policy_type            = "SimpleScaling"
}

# Cloudwatch monitoring for maximum CPU utilization
resource "aws_cloudwatch_metric_alarm" "custom_cpu_scale_up" {
  alarm_name          = "custom-cpu-metrics-scale-up-alarm-${var.config.environment}"
  alarm_description   = "Alarm once CPU usage increases"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    "AutoScalingGroupName" : var.autoscaling_group_name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.custom_cpu_scale_up.arn]
}

# Autoscaling down configuration policy based on CPU utilization
resource "aws_autoscaling_policy" "custom_cpu_scale_down" {
  name                   = "custom-cpu-metrics-scale-down-policy-${var.config.environment}"
  autoscaling_group_name = var.autoscaling_group_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
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
