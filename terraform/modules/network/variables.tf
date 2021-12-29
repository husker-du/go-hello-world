variable "config" {
  description = "Global configuration"
  type        = any
}

variable "vpc_cidr" {
  description = "CIDR block for VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_newbits" {
  description = "The number of additional bits with which to extend the prefix to calculate the subnet address."
  type        = number
  default     = 8
}

variable "eip_private_ip" {
  description = "Primary or secondary private IP address to associate with the Elastic IP address."
  type        = string
  default     = "10.0.1.101"
}
