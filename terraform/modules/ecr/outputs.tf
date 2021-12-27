output "repository_url" {
  description = "The URL of the image repository (in the form <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repository_name>)"
  value       = aws_ecr_repository.image_repo.repository_url
}
