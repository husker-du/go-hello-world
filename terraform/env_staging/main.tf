terraform {
  backend "s3" {
    profile        = "s4l-terraform"
    encrypt        = "true"
    bucket         = "s4l-terraform-state"
    key            = "staging/hello-world/terraform.tfstate"
    dynamodb_table = "s4l-lock-dynamo"
    region         = "us-east-1"
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
    tags        = var.tags
    environment = var.environment
    app_name    = var.app_name
    port_num    = var.port_num
  }
}

module "network" {
  source = "../modules/network"

  config         = local.config
  vpc_cidr       = "192.168.0.0/16"
  subnet_newbits = 8
}

module "sg" {
  source = "../modules/sg"

  config = local.config
  vpc_id = module.network.vpc_id
}

module "lb" {
  source = "../modules/lb"

  config            = local.config
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.sg.alb_sg_id
  health_check_path = "/health"
}

module "ecr" {
  source = "../modules/ecr"

  config = local.config
}

module "ecs" {
  source = "../modules/ecs"

  config             = local.config
  instance_type      = "t2.micro"
  public_subnet_ids  = module.network.public_subnet_ids
  ecs_sg_id          = module.sg.ecs_sg_id
  alb_tg_arn         = module.lb.alb_tg_arn
  ssh_key_name       = "ec2key-${var.environment}"
  ssh_key_base_path  = "./.ssh" # Caution! Include this path in the .gitignore file
  desired_tasks      = 2  # Number of replicas of the service task
  desired_capacity   = 2
  max_capacity       = 4
  min_capacity       = 2 # High availability
  ecr_repository_url = module.ecr.repository_url
}

module "autoscaling" {
  source = "../modules/autoscaling"

  config                 = local.config
  autoscaling_group_name = module.ecs.autoscaling_group_name
}
