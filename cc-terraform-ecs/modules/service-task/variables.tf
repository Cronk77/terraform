variable "aws_region" {
  type = string
  description = "aws region"
}

variable "app_name" {
  type = string
  description = "Application name"
}

variable "account_id" {
  type = number
  description = "AWS account number"
}

# Networking ########################################################################
variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
  description = "Private subnet one"
}

# ECS ###############################################################################
variable "ecs_service_sg_id" {
    type = string
    description = "ecs security group id"
}

variable "ecs_cluster_name" {
    type = string
    description = "ecs cluster name"
}

variable "ecs_cluster_id" {
    type = string
    description = " ecs cluster name"
}

variable "ecs_task_execution_role_arn" {
    type = string
    description = "roles for task execution"
}
####################################################################################


# Container/DB config################################################################
variable "db_password" {
  type = string
  description = "RDS DB password"
}

variable "db_port" {
  type = string
  description = "RDS DB access Port"
}

variable "db_name" {
  type = string
  description = "RDS DB name"
}

variable "db_user_name" {
  type = string
  description = "RDS DB user name"
}

variable "encrypt_secret_key"{
  type = string
  description = "Microservice Application encryption key"
}

variable "jwt_secret_key" {
  type = string
  description = "Microservice Application jwt secret key"
}

variable "db_host" {
    type = string
    description = "RDS host endpoint"
}
#####################################################################################

# ALB Config
variable "alb_name" {
  type = string
  description = "ALB name"
}

variable "alb_listener_port" {
  type = number
  description = "listener port"
}

variable "alb_listener_protocol" {
    type = string
    description = " listener protocol"
}

variable "alb_sg_id" {
    type = string
    description = "alb security group id"
}
########################################################################################

# Microservice config################################################################
# Account service#############################
variable "account_service_name" {
    type = string
    description = "account service name"
}

variable "account_aws_region" {
    type = string
    description = "region of this microservice"
}

variable "account_port" {
    type = number
    description = "account port"
}

variable "account_path_pattern" {
    type = list(string)
    description = "account path patterns"
}

variable "account_desired_count" {
    type = number
    description = "account desired count"
}

variable "account_image_tag" {
  type        = string
  description = "account tag for ECR image"
}

# Bank service################################
variable "bank_service_name" {
    type = string
    description = "bank service name"
}

variable "bank_aws_region" {
    type = string
    description = "region of this microservice"
}

variable "bank_port" {
    type = number
    description = "bank port"
}

variable "bank_path_pattern" {
    type = list(string)
    description = "bank path patterns"
}

variable "bank_desired_count" {
    type = number
    description = "bank desired count"
}

variable "bank_image_tag" {
  type        = string
  description = "bank tag for ECR image"
}

# Card service################################
variable "card_service_name" {
    type = string
    description = "card service name"
}

variable "card_aws_region" {
    type = string
    description = "region of this microservice"
}

variable "card_port" {
    type = number
    description = "card port"
}

variable "card_path_pattern" {
    type = list(string)
    description = "card path patterns"
}

variable "card_desired_count" {
    type = number
    description = "card desired count"
}

variable "card_image_tag" {
  type        = string
  description = "card tag for ECR image"
}

# Transaction service################################
variable "transaction_service_name" {
    type = string
    description = "transaction service name"
}

variable "transaction_aws_region" {
    type = string
    description = "region of this microservice"
}

variable "transaction_port" {
    type = number
    description = "transaction port"
}

variable "transaction_path_pattern" {
    type = list(string)
    description = "transaction path patterns"
}

variable "transaction_desired_count" {
    type = number
    description = "transaction desired count"
}

variable "transaction_image_tag" {
  type        = string
  description = "transaction tag for ECR image"
}

# Underwriter service################################
variable "underwriter_service_name" {
    type = string
    description = "underwriter service name"
}

variable "underwriter_aws_region" {
    type = string
    description = "region of this microservice"
}

variable "underwriter_port" {
    type = number
    description = "underwriter port"
}

variable "underwriter_path_pattern" {
    type = list(string)
    description = "underwriter path patterns"
}

variable "underwriter_desired_count" {
    type = number
    description = "underwriter desired count"
}

variable "underwriter_image_tag" {
  type        = string
  description = "underwriter tag for ECR image"
}

# User service################################
variable "user_service_name" {
    type = string
    description = "user service name"
}

variable "user_aws_region" {
    type = string
    description = "region of this microservice"
}

variable "user_port" {
    type = number
    description = "user port"
}

variable "user_path_pattern" {
    type = list(string)
    description = "card path patterns"
}

variable "user_desired_count" {
    type = number
    description = "user desired count"
}

variable "user_image_tag" {
  type        = string
  description = "user tag for ECR image"
}

# Common Variables############################
variable "cpu" {
    type = number
    description = "cpu config"
}

variable "memory" {
    type = number
    description = "memory config"
}

variable "alb_protocol" {
    type = string
    description = "alb protocol"
}

variable "health_check_path" {
    type = string
    description = "health check path"
}

variable "max_capacity" {
    type = number
    description = ""
}

variable "min_capacity" {
    type = number
    description = ""
}

variable "target_cpu" {
    type = number
    description = "threshold for cpu"
}

variable "target_memory" {
    type = number
    description = "threshold for memory"
}
###################################################################################
