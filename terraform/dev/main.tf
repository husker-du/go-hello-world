# terraform {
#   backend "s3" {
#     profile        = "s4l-terraform"
#     encrypt        = "true"
#     bucket         = "s4l-terraform-state"
#     key            = "dev/hello-world/terraform.tfstate"
#     dynamodb_table = "s4l-lock-dynamo"
#     region         = "us-east-1"
#   }
# }

terraform {
  backend "remote" {
    organization = "hevil-terraform-labs"
    workspaces {
      name = "go-hello-world"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

locals {
  # Configuration values shared by all the modules
  config = {
    region      = var.region
    profile     = var.profile
    tags        = var.tags
    environment = terraform.workspace
    app_name    = var.app_name
    port_num    = var.port_num
  }
}

module "network" {
  source = "../modules/network"
  # Module values
  config         = local.config
  vpc_cidr       = "10.0.0.0/16"
  subnet_newbits = 8
}

module "sg" {
  source = "../modules/sg"
  # Module values
  config = local.config
  vpc_id = module.network.vpc_id
}

module "lb_acm" {
  source = "../modules/lb_acm"
  # Module values
  config            = local.config
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.sg.alb_sg_id
  health_check_path = "/health"
  dns_name          = "brooh.xyz"
}

module "ecr" {
  source = "../modules/ecr"
  # Module values
  config       = local.config
  version_tag  = "v0.3"
  context_path = "${path.root}/../.."
}

module "ecs" {
  source = "../modules/ecs"
  # Module values
  config             = local.config
  instance_type      = "t2.micro"
  public_subnet_ids  = module.network.public_subnet_ids
  ecs_sg_id          = module.sg.ecs_sg_id
  alb_tg_arn         = module.lb_acm.alb_tg_arn
  ssh_key_name       = "ec2key-${var.environment}"
  ssh_key_base_path  = "./.ssh" # Caution! Include this path in the .gitignore file
  desired_tasks      = 2        # Number of replicas of the service task
  desired_capacity   = 2
  max_capacity       = 4
  min_capacity       = 1
  image_name         = module.ecr.repository_url
  image_version      = "v0.3"
}

module "autoscaling" {
  source = "../modules/autoscaling"
  # Module values
  config                 = local.config
  autoscaling_group_name = module.ecs.autoscaling_group_name
}
