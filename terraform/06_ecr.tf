# Docker images registry
resource "aws_ecr_repository" "image_repo" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"
}

# Allowed actions on the ECR repository
resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.image_repo.name
  policy     = templatefile("policies/ecr-repository-policy.json.tpl", { repository_name = var.repository_name })
}
