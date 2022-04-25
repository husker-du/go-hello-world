terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}


data "aws_caller_identity" "current" {}

# Docker image repository
resource "aws_ecr_repository" "image_repo" {
  name                 = var.config.app_name
  image_tag_mutability = "MUTABLE"
  tags                 = var.config.tags
  
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Allowed actions on the ECR repository
resource "aws_ecr_repository_policy" "image_repo" {
  repository = aws_ecr_repository.image_repo.name
  policy     = templatefile("${path.module}/policies/ecr-repository-policy.json.tpl", 
                          { repository_name = "${aws_ecr_repository.image_repo.name}" })
}

# Build the go-hello-world image
resource "docker_image" "go_hello" {
  name = var.config.app_name
  build {
    path  = var.context_path
    tag   = [var.version_tag]
    label = {
      author : "carlos.tomas.herreros@gmail.com"
    }
  }

  # Login to the ECR registry
  provisioner "local-exec" {
    when = create
    command = <<EOT
    aws ecr get-login-password --region ${var.config.region} --profile ${var.config.profile} \
        | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.config.region}.amazonaws.com
    EOT
  }

  # Push image to the ECR registry
  provisioner "local-exec" {
    when = create
    command = <<EOT
    docker tag ${var.config.app_name}:${var.version_tag} \
        ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.config.region}.amazonaws.com/${var.config.app_name}:${var.version_tag}
    docker tag ${var.config.app_name}:${var.version_tag} \
        ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.config.region}.amazonaws.com/${var.config.app_name}:latest
    docker push \
        ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.config.region}.amazonaws.com/${var.config.app_name}:${var.version_tag}
    docker push \
        ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.config.region}.amazonaws.com/${var.config.app_name}:latest
    EOT
  }
}
