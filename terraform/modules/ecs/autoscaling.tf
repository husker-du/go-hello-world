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

  tags = [
    {
      key                 = "Name"
      value               = var.config.tags["Name"]
      propagate_at_launch = true
    },
    {
      key                 = "Organization"
      value               = var.config.tags["Organization"]
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = var.config.tags["Project"]
      propagate_at_launch = true
    },
    {
      key                 = "Team"
      value               = var.config.tags["Team"]
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = var.config.tags["Owner"]
      propagate_at_launch = true
    },
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
}
