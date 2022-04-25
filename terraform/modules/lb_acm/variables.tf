variable "config" {
  description = "Global configuration"
  type        = any
}

variable "alb_sg_id" {
  description = "Security group identifier of the load balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC identifier."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet identifiers"
  type        = list(string)
}

variable "health_check_path" {
  description = "Health check path for the default target group"
  type        = string
  default     = "/health"
}

variable "dns_name" {
  description = "Name of the DNS hosted zone. A domain name for which the certificate should be issued."
  type        = string
  default     = "example.com."
}