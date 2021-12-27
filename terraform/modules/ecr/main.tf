terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.1.0"
}

# Docker images registry
resource "aws_ecr_repository" "image_repo" {
  name                 = var.config.app_name
  image_tag_mutability = "MUTABLE"
  tags                 = var.config.tags
}

# Allowed actions on the ECR repository
resource "aws_ecr_repository_policy" "image_repo" {
  repository = aws_ecr_repository.image_repo.name
  policy     = templatefile("${path.module}/policies/ecr-repository-policy.json.tpl", { repository_name = "${aws_ecr_repository.image_repo.name}" })
}
