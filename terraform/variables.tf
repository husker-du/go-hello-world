variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "eu-west-1"
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
  description = "Name of the ECS cluster"
  type        = string
  default     = "s4l-hello-world"
}

variable "ecs_container" {
  description = "Configuration of the ECS task container"
  type = object({
    name  = string
    image = string
    ports = list(number)
  })
  default = {
    name  = "hello_world"
    image = "tutum/hello-world"
    ports = [80]
  }
}

variable "ecs_service_name" {
  description = "Name of the service"
  type        = string
  default     = "hello-world"
}

variable "ecs_task_name" {
  description = "Name of the task"
  type        = string
  default     = "go-hello-world"
}

variable "replicas" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
  default     = 2
}

# ECR
variable "repository_name" {
  description = "Name of the application image repository in the ECR registry"
  type        = string
  default     = "go-hello-world"
}

# Key pair
variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  type        = string
  default     = "ssh/aws_ec2_key.pub"
}

# Autoscaling
variable "max_scale" {
  description = "The max capacity of the scalable target"
  type        = number
  default     = 4
}

variable "min_scale" {
  description = "The min capacity of the scalable target"
  type        = number
  default     = 1
}
