output "user_access_key_id" {
  description = "The AWS access key id of the programmatic user"
  value       = aws_iam_access_key.prog_user.id
}

output "user_secret_access_key" {
  description = "The AWS secret access key of the programmatic user"
  value       = nonsensitive(aws_iam_access_key.prog_user.secret)
}
