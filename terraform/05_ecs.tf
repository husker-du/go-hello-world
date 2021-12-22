# SSH public key
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.ecs_cluster_name}_key_pair"
  public_key = file(var.ssh_pubkey_file)
}

# ECS cluster
resource "aws_ecs_cluster" "fargate" {
  name = "${var.ecs_cluster_name}-cluster"

  capacity_providers = ["FARGATE"] # Capacity providers are used to manage the infrastructure the tasks run on.

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = "100"
  }
}

# Task definition
resource "aws_ecs_task_definition" "app_task" {
  family                   = var.ecs_task_name              # Naming the task
  requires_compatibilities = ["FARGATE"]                    # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"                       # Using awsvpc as our network mode as this is required for Fargate
  cpu                      = 256                            # Specifying the CPU our container requires
  memory                   = 512                            # Specifying the memory our container requires
  execution_role_arn       = aws_iam_role.ecs_task_exec.arn # The role the ECS task assumes when running the task
  container_definitions = jsonencode([
    {
      name      = var.ecs_task_name
      image     = var.ecs_container.image
      essential = true
      portMappings = [
        for port in var.ecs_container.ports : {
          containerPort = port
          hostPort      = port
        }
      ]
      memory = 512
      cpu    = 256
    }
  ])
}

# An ECS service allows you to run and maintain a specified number of instances of a task definition simultaneously in an Amazon ECS cluster.
# Don't assign a service IAM role. The 'awsvpc' network mode use service-linked role, which is created for you automatically. 
resource "aws_ecs_service" "app_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.fargate.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.replicas  # The number of containers we want to deploy
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [ for subnet in values(aws_subnet.public) : subnet.id ]
    assign_public_ip = true                           # Providing our containers with public IPs
    security_groups  = [ aws_security_group.ecs.id ]  # Allow inbound HTTP traffic in port 80 from the ALB security groupt 
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_ecs_http.arn    # Referencing our target group
    container_name   = aws_ecs_task_definition.app_task.family
    container_port   = 80                                       # Specifying the container port
  }

  deployment_controller {
    type = "ECS"
  }
}
