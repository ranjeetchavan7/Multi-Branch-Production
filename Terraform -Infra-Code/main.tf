terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "devops-project-terraform-state-v1"
    key          = "prod/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_name           = "${var.environment}-vpc"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  tags               = var.tags
}

module "security_groups" {
  source            = "./modules/security_groups"
  vpc_id            = module.vpc.vpc_id
  environment       = var.environment
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  tags              = var.tags
}

module "ec2_bastion" {
  source           = "./modules/ec2_bastion"
  environment      = var.environment
  instance_type    = "t2.large"
  key_name         = var.key_name
  public_subnet_id = module.vpc.public_subnets[0]
  bastion_sg_id    = module.security_groups.bastion_sg_id
  tags             = var.tags
}

module "eks" {
  source               = "./modules/eks"
  cluster_name         = "${var.environment}-eks-cluster"
  cluster_version      = "1.34"
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnets
  bastion_sg_id        = module.security_groups.bastion_sg_id
  bastion_iam_role_arn = module.ec2_bastion.bastion_iam_role_arn
  tags                 = var.tags
}