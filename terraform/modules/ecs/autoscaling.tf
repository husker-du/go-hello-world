resource "aws_autoscaling_group" "ecs_cluster" {
  name_prefix               = "${var.config.app_name}-asg-${var.config.environment}-"
  vpc_zone_identifier       = var.public_subnet_ids
  launch_configuration      = aws_launch_configuration.ecs.name

  min_size                  = var.min_capacity
  max_size                  = var.max_capacity
  desired_capacity          = var.desired_capacity

  health_check_type         = "EC2"
  health_check_grace_period = 60 # Time (in seconds) after instance comes into service before checking health.
  default_cooldown          = 60  # The amount of time, in seconds, after a scaling activity completes before another scaling activity can start.
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "${var.config.app_name}-${var.config.environment}"
    propagate_at_launch = true
  }

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
}
