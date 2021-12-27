variable "config" {
  description = "Global configuration."
  type        = any
}

# EC2 instance
variable "instance_type" {
  description = "Instance type."
  type        = string
  default     = "t2.micro"
}

# Network
variable "ecs_sg_id" {
  description = "The ECS security group identifier."
  type        = string
}

variable "alb_tg_arn" {
  description = "ARN of the load balancer target group."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet identifiers"
  type        = list(string)
}

# ECR
variable "ecr_repository_url" {
  description = "The URL of the image repository (in the form <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repository_name>)"
  type        = string
  default     = "tutum/hello-world"
}

# SSH key pair
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
variable "desired_replicas" {
  description = "Desired number of task replicas to run."
  type        = number
  default     = 2
}

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
