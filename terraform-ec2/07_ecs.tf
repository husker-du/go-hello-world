# ECS cluster of EC2 instances
resource "aws_ecs_cluster" "ecs" {
  name = "${var.ecs_cluster_name}-cluster"
  tags = var.tags
}

# Get the most recent AMI of the specified AMI type
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

# EC2 instance template launched by the autoscaling
resource "aws_launch_configuration" "ecs" {
  name                        = "${var.ecs_cluster_name}-cluster"
  image_id                    = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.ecs.id]
  iam_instance_profile        = aws_iam_instance_profile.ecs_instance.id
  key_name                    = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true
  # This user data will be executed the first time the machine starts.
  # This code snippet makes sure the EC2 instance is automatically attached to the ECS cluster that we create earlier
  user_data = "#!/bin/bash\necho ECS_CLUSTER='${var.ecs_cluster_name}-cluster' > /etc/ecs/ecs.config"
}

# ECS task definition of the service
data "template_file" "app" {
  template = file("templates/app-container-definitions.json.tpl")
  vars = {
    docker_image   = "tutum/hello-world"
    container_name = "go-hello-world"
    port_num       = 80
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = var.app_name
  container_definitions = data.template_file.app.rendered
  tags                  = var.tags
}

# ECS application service
resource "aws_ecs_service" "app" {
  name            = "${var.ecs_cluster_name}-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.app.arn
  iam_role        = aws_iam_role.ecs_service.arn
  launch_type     = "EC2"
  desired_count   = var.app_count
  tags            = var.tags
  depends_on      = [aws_alb_listener.ecs_http, aws_iam_role_policy.ecs_instance]

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs_http.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.app.family
    container_port   = 80 # Specifying the container port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}
