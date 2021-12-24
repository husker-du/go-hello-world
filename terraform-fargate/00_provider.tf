terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.1.0"

  backend "s3" {
    profile        = "s4l-terraform"
    encrypt        = "true"
    bucket         = "s4l-terraform-state"
    key            = "dev/hello-world/terraform.tfstate"
    dynamodb_table = "s4l-lock-dynamo"
    region         = "eu-west-1"
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}
