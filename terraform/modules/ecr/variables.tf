variable "config" {
  description = "Global configuration."
  type        = any
}

variable "version_tag" {
  description = "Docker image version"
  type        = string
}

variable "context_path" {
  description = "Path of the build context"
  type        = string
}
