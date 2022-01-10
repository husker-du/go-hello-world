variable "profile" {
  description = "The AWS user profile for creating prerequisites."
  type        = string
  default     = "admin"
}

variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "tfstate_bucket_name" {
  description = "The name of the S3 bucket for the terraform remote state."
  type        = string
  default     = "s4l-terraform-state"
}

variable "lock_dynamo_table" {
  description = "Name of the DynamoDB table ."
  type        = string
  default     = "s4l-lock-dynamo"
}

variable "programmatic_username" {
  description = "Programmatic user to create the terraform resources"
  type        = string
  default     = "s4l-terraform"
}
