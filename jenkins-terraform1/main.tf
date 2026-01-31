provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source      = "./modules/ec2"
  subnet_id   = module.vpc.subnet_id
  sg_id       = module.sg.sg_id
  key_name    = var.key_name
  github_repo = var.github_repo
}

module "snapshots" {
  source      = "./modules/snapshots"
  instance_id = module.ec2.instance_id
}
