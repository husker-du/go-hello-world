variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "eu-west-1"
}

variable "profile" {
  description = "The AWS credentials profile."
  type        = string
  default     = "sa-terraform"
}

variable "bucket-tfstate" {
  description = "The name of the S3 bucket for the terraform remote state."
  type        = string
  default     = "s4l-terraform-state"
}

variable "lock-dynamo-table" {
  description = "Name of the DynamoDB table ."
  type        = string
  default     = "s4l-lock-dynamo"
}
