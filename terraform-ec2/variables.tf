variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "The AWS credentials profile."
  type        = string
  default     = "s4l-terraform"
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

variable "app_name" {
  description = "The application name."
  type        = string
  default     = "go-hello-world"
}

variable "tags" {
  description = "Tags applied to the resources"
  type = object({
    Organization = string
    Project      = string
    Team         = string
    Owner        = string
  })
  default = {
    Organization = "stayforlong"
    Project      = "go-hello-world"
    Team         = "job-appliers"
    Owner        = "ctomas"
  }
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

# Load Balancer
variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/health"
}

# ECS
variable "ecs_cluster_name" {
  description = "Name of the cluster of EC2 instances"
  type        = string
  default     = "s4l-hello-world"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "app_count" {
  description = "Number of Docker containers to run"
  type        = number
  default     = 2
}

# ECR
variable "repository_name" {
  description = "Name of the application image repository in the ECR registry"
  type        = string
  default     = "go-hello-world"
}

# SSH Key pair
variable "ssh_key_name" {
  description = "Name of the ssh key file"
  type        = string
  default     = "ec2key" # if we keep default blank it will ask for a value when we execute terraform apply
}

variable "ssh_key_base_path" {
  description = "Base path of the ssh key file"
  type        = string
  default     = "./.ssh" # Caution! Include this path in the .gitignore file
}

# Autoscaling
variable "min_replicas" {
  description = "Minimum autoscale (number of EC2)"
  type        = number
  default     = 1
}
variable "max_replicas" {
  description = "Maximum autoscale (number of EC2)"
  type        = number
  default     = 4
}
variable "autoscale_desired" {
  description = "Desired autoscale (number of EC2)"
  type        = number
  default     = 2
}
