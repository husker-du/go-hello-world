variable "profile" {
  description = "The AWS user profile for creating prerequisites."
  type        = string
  default     = ""
}

variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment (dev, staging, prod)."
  type        = string
  default     = ""
}

variable "app_name" {
  description = "The application name."
  type        = string
  default     = ""
}

variable "port_num" {
  description = "The port number to connect to the application."
  type        = number
  default     = 80
}

variable "tags" {
  description = "Tags applied to the resources"
  type = object({
    Organization = string
    Project      = string
    Team         = string
    Owner        = string
    Name         = string
  })
  default = {
    Organization = ""
    Project      = ""
    Team         = ""
    Owner        = ""
    Name         = ""
  }
}
