# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "cc-aline-ecs-bucket"
    key    = "terraform_state_ecs_blue.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region                = var.aws_region
  access_key            = var.aws_access_key
  secret_key            = var.aws_secret_key
}

# Grabs the hosted zone data
data "aws_route53_zone" "hosted_zone" {
  name         = var.hosted_zone_name
  private_zone = false
}

data "aws_secretsmanager_secret" "rds_secret" {
  name = "cc-db-pass"
}

data "aws_secretsmanager_secret_version" "rds_secret_ver" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_ver.secret_string)
}


module "networking" {
  source                = "../modules/networking"
  app_name              = var.app_name
  version_name          = var.version_name
  env                   = var.env
  cidr                  = var.cidr
  availability_zones    = var.availability_zones
  private_subnets       = var.private_subnets
  public_subnets        = var.public_subnets
}

module "iam" {
  source                = "../modules/iam"
  app_name              = var.app_name
  version_name          = var.version_name
}

module "route53" {
  source                = "../modules/route53"
  hosted_zone_name      = var.hosted_zone_name
  weighted_percentage   = var.weighted_percentage
  version_name          = var.version_name
  r53_host_zone_id      = data.aws_route53_zone.hosted_zone.id
  r53_host_zone_name    = data.aws_route53_zone.hosted_zone.name
  alb_dns_name          = module.alb.alb_dns_name
  alb_zone_id           = module.alb.alb_zone_id
}

module "alb" {
  source                = "../modules/alb"
  app_name              = var.app_name
  version_name          = var.version_name
  alb_listener_port     = var.alb_listener_port
  alb_listener_protocol = var.alb_listener_protocol
  vpc_id                = module.networking.vpc_id
  public_subnets        = module.networking.public_subnets
  ingress_from_port     = var.ingress_from_port
  ingress_to_port       = var.ingress_to_port
  ingress_cidr_blocks   = var.ingress_cidr_blocks
  ingress_protocol      = var.ingress_protocol
  egress_from_port      = var.egress_from_port
  egress_to_port        = var.egress_to_port
  egress_cidr_blocks    = var.egress_cidr_blocks
  egress_protocol       = var.egress_protocol
}

module "ecs" {
  source                = "../modules/ecs"
  app_name              = var.app_name
  version_name          = var.version_name
  vpc_id                = module.networking.vpc_id
  alb_sg_id             = module.alb.alb_sg_id
}

module "service-task" {
  source                      = "../modules/service-task"
  ############ General ############
  app_name                    = var.app_name
  version_name                = var.version_name
  account_id                  = var.account_id
  vpc_id                      = module.networking.vpc_id
  aws_region                  = var.aws_region
  private_subnets             = module.networking.private_subnets
  ############ Microservice ############
  account_port                = var.account_port
  bank_port                   = var.bank_port
  card_port                   = var.card_port
  transaction_port            = var.transaction_port
  underwriter_port            = var.underwriter_port
  user_port                   = var.user_port

  account_desired_count       = var.account_desired_count
  bank_desired_count          = var.bank_desired_count
  card_desired_count          = var.card_desired_count
  transaction_desired_count   = var.transaction_desired_count
  underwriter_desired_count   = var.underwriter_desired_count
  user_desired_count          = var.user_desired_count

  account_path_pattern        = var.account_path_pattern
  bank_path_pattern           = var.bank_path_pattern
  card_path_pattern           = var.card_path_pattern
  transaction_path_pattern    = var.transaction_path_pattern
  underwriter_path_pattern    = var.underwriter_path_pattern
  user_path_pattern           = var.user_path_pattern

  account_service_name        = var.account_service_name
  bank_service_name           = var.bank_service_name
  card_service_name           = var.card_service_name
  transaction_service_name    = var.transaction_service_name
  underwriter_service_name    = var.underwriter_service_name
  user_service_name           = var.user_service_name

  account_image_tag           = var.account_image_tag
  bank_image_tag              = var.bank_image_tag
  card_image_tag              = var.card_image_tag
  transaction_image_tag       = var.transaction_image_tag
  underwriter_image_tag       = var.underwriter_image_tag
  user_image_tag              = var.user_image_tag

  ############ ECR Regions ############
  account_aws_region          = var.account_aws_region
  bank_aws_region             = var.bank_aws_region
  card_aws_region             = var.card_aws_region
  transaction_aws_region      = var.transaction_aws_region
  underwriter_aws_region      = var.underwriter_aws_region
  user_aws_region             = var.user_aws_region
  ############ Database ############
  db_password                 = local.db_creds.password
  db_port                     = var.db_port
  db_host                     = local.db_creds.host
  db_name                     = var.db_name
  db_user_name                = local.db_creds.username
  ############ Application Keys ############
  encrypt_secret_key          = var.encrypt_secret_key
  jwt_secret_key              = var.jwt_secret_key
  ############ ECS Cluster ############
  ecs_cluster_id              = module.ecs.ecs_cluster_id
  ecs_service_sg_id           = module.ecs.ecs_service_sg_id
  ecs_cluster_name            = module.ecs.ecs_cluster_name
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ############ ALB ############
  alb_sg_id                   = module.alb.alb_sg_id
  alb_name                    = module.alb.alb_name
  alb_listener_port           = var.alb_listener_port
  alb_listener_protocol       = var.alb_listener_protocol
  alb_protocol                = var.alb_protocol
  ############ Task Config ############
  memory                      = var.memory
  cpu                         = var.cpu
  max_capacity                = var.max_capacity
  min_capacity                = var.min_capacity
  health_check_path           = var.health_check_path
  target_cpu                  = var.target_cpu
  target_memory               = var.target_memory
}

