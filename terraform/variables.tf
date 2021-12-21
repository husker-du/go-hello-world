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

variable "bucket_tfstate" {
  description = "The name of the S3 bucket for the terraform remote state."
  type        = string
  default     = "s4l-terraform-state"
}

variable "lock_dynamo_table" {
  description = "Name of the DynamoDB table ."
  type        = string
  default     = "s4l-lock-dynamo"
}

variable "environment" {
  description = "The environment (dev, staging, prod)."
  type        = string
  default     = "dev"
}

# Network
variable "vpc_cidr" {
  description = "CIDR block for VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "eip_private_ip" {
  description = "Primary or secondary private IP address to associate with the Elastic IP address."
  type        = string
  default     = "10.0.0.5"
}