terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.1.0"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

data "terraform_remote_state" "s4l" {
  backend = "s3"

  config = {
    profile        = var.profile
    encrypt        = "true"
    bucket         = var.bucket_tfstate
    key            = "${var.environment}/helloworld/terraform.tfstate"
    dynamodb_table = var.lock_dynamo_table
    region         = var.region
  }
}
