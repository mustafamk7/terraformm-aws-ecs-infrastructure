provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "./modules/vpc"
  vpc_cidr   = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
}

module "security_group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "ecr" {
  source = "./modules/ecr"
  app_name = var.app_name
}


module "ecs" {
  source           = "./modules/ecs"
  app_name         = var.app_name
  image_url        = module.ecr.ecr_repository_url
  subnets          = module.vpc.subnet_ids
  security_group_id = module.security_group.security_group_id
}
