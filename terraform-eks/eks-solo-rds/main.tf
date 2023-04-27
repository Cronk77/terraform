terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "cc-aline-eks-bucket"
    key    = "terraform_state_RDS.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "rds" {
  source              = "../modules/rds"
  db_cidr             = var.db_cidr
  project             = var.project
  db_name             = var.db_name
  db_user_name        = var.db_user_name
  db_instance_class   = var.db_instance_class
  engine_version      = var.engine_version
  allocated_storage   = var.allocated_storage
  availability_zones  = data.aws_availability_zones.available.names
  aws_region          = var.aws_region
}