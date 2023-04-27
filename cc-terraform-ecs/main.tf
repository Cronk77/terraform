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
    key    = "terraform_state_two.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "networking" {
  source             = "./modules/networking"
  app_name           = var.app_name
  env                = var.env
  cidr               = var.cidr
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
}

module "iam" {
  source   = "./modules/iam"
  app_name = var.app_name
}

module "alb" {
  source                = "./modules/alb"
  app_name              = var.app_name
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
  source    = "./modules/ecs"
  app_name  = var.app_name
  vpc_id    = module.networking.vpc_id
  alb_sg_id = module.alb.alb_sg_id
}

module "ELK" {
  source                      = "./modules/ELK"
  vpc_id                      = module.networking.vpc_id
  cidr                        = var.cidr
  private_subnets             = module.networking.private_subnets
  aws_region                  = var.aws_region
  account_id                  = var.account_id
  availability_zones          = var.availability_zones
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_role_name               = module.iam.ecs_role_name
  app_services                = var.app_services
}

module "cloudwatch_sns" {
  source            = "./modules/cloudwatch_sns"
  app_services      = var.app_services
  ecs_cluster_name  = module.ecs.ecs_cluster_name
  aws_region        = var.aws_region
  account_id        = var.account_id
}

module "rds" {
  source             = "./modules/rds"
  db_cidr            = var.db_cidr
  app_name           = var.app_name
  db_name            = var.db_name
  db_user_name       = var.db_user_name
  db_instance_class  = var.db_instance_class
  engine_version     = var.engine_version
  allocated_storage  = var.allocated_storage
  availability_zones = var.availability_zones
}

# Stoped using for now. Will try to set up again later to add security between RDS and ecs cluster
# module "vpc_peering" {
#   source              = "./modules/vpc_peering"
#   aws_region          = var.aws_region
#   vpc_id_One          = module.networking.vpc_id
#   vpc_id_two          = module.rds.db_vpc
#   route_table_one_id  = module.networking.private_route_table_id
#   route_table_two_id  = module.rds.db_route_table_id
#   cidr_block_one      = var.cidr
#   cidr_block_two      = var.db_cidr
# }

module "service-task" {
  source                      = "./modules/service-task"
  ############ General ############
  app_name                    = var.app_name
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
  db_password                 = module.rds.db_password
  db_port                     = var.db_port
  db_host                     = module.rds.db_endpoint
  db_name                     = var.db_name
  db_user_name                = module.rds.db_username
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

