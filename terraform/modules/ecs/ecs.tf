terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.1.0"
}

# ECS cluster of EC2 instances
resource "aws_ecs_cluster" "ecs" {
  name = "${var.config.app_name}-cluster-${var.config.environment}"
  tags = var.config.tags
}

# Get the most recent ECS optimized AMI
data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ECS task definition of the service
data "template_file" "app" {
  template = file("${path.module}/templates/app-container-definitions.json.tpl")
  vars = {
    docker_image   = format("%s%s", var.image_name, (var.image_version != "" ? ":${var.image_version}" : ""))
    container_name = var.config.app_name
    port_num       = var.config.port_num
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = var.config.app_name
  container_definitions = data.template_file.app.rendered
  tags                  = var.config.tags
}

# ECS application service
resource "aws_ecs_service" "app" {
  name            = "${var.config.app_name}-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.app.arn
  iam_role        = aws_iam_role.ecs_service.arn
  launch_type     = "EC2"
  desired_count   = var.desired_tasks  # Number of instances of the task to place and keep running
  tags            = var.config.tags
  depends_on      = [aws_iam_role_policy_attachment.ecs_service]

  load_balancer {
    target_group_arn = var.alb_tg_arn # Referencing our target group
    container_name   = aws_ecs_task_definition.app.family
    container_port   = var.config.port_num # Specifying the container port
  }

  deployment_controller {
    type = "ECS"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

# EC2 instance template launched by the autoscaling group
resource "aws_launch_configuration" "ecs" {
  name_prefix                 = "${aws_ecs_cluster.ecs.name}-${var.config.environment}-"
  image_id                    = data.aws_ami.ecs_optimized.id
  instance_type               = var.instance_type
  security_groups             = [var.ecs_sg_id]
  iam_instance_profile        = aws_iam_instance_profile.ecs_instance.id
  key_name                    = aws_key_pair.ssh.key_name
  associate_public_ip_address = true
  # This user data will be executed the first time the machine starts.
  # This code snippet makes sure the EC2 instance is automatically attached to the ECS cluster that we create earlier
  user_data = "#!/bin/bash\necho ECS_CLUSTER='${aws_ecs_cluster.ecs.name}' > /etc/ecs/ecs.config"

  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created
  # before the old one gets destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }
}

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
