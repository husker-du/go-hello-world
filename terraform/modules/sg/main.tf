terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.1.0"
}

# ALB Security Group (Traffic Internet -> ALB)
resource "aws_security_group" "alb" {
  name        = "alb-sg-${terraform.workspace}"
  description = "Controls access to the ALB."
  vpc_id      = var.vpc_id
  tags        = var.config.tags

  ingress {
    description = "Allows HTTP inbound traffic from internet"
    from_port   = var.config.port_num
    to_port     = var.config.port_num
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows HTTPS inbound traffic from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}

# ECS Security group (traffic ALB -> ECS, ssh -> ECS)
resource "aws_security_group" "ecs" {
  name        = "ecs-sg-${terraform.workspace}"
  description = "Allows inbound access from the ALB only to the application instances"
  vpc_id      = var.vpc_id
  tags        = var.config.tags
  ingress {
    description     = "Allow all inbound traffic from the load balancer"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description = "Allow SSH connections from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0             # Allows any incoming port
    to_port     = 0             # Allows any outgoing port
    protocol    = "-1"          # Allows any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allows traffic out to all IP addresses
  }
}
