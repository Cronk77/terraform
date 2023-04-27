# variables.tf

# Application config################################################################
variable "account_id" {
  type        = number
  description = "AWS account number"
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret Key"
}

variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "app_name" {
  type        = string
  description = "Application name"
}

variable "version_name" {
  type        = string
  description = "version name (i.e. blue or green)"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "app_services" {
  type = list(string)
  description = "service name list"
}

# variable "ecs_task_execution_role_arn" {
#     type = string
#     description = "task execution role"
# }
####################################################################################

# vpc config########################################################################
variable "cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones that the services are running"
}


variable "private_subnets" {
  type        = list(string)
  description = "Private subnets"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
}
#####################################################################################

# Container/DB config################################################################
variable "db_cidr" {
  type = string
  description = "cidr block for db vpc"
}

# variable "db_password" {
#   type = string
#   description = "RDS DB password"
# }

variable "db_port" {
  type        = string
  description = "RDS DB access Port"
}

variable "db_name" {
  type        = string
  description = "RDS DB name"
}

variable "db_user_name" {
  type        = string
  description = "RDS DB user name"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance type"
}

variable "engine_version" {
  type        = string
  description = "RDS engine version"
}

variable "allocated_storage" {
  type        = string
  description = "storage allocation for RDS DB"
}

variable "encrypt_secret_key" {
  type        = string
  description = "Microservice Application encryption key"
}

variable "jwt_secret_key" {
  type        = string
  description = "Microservice Application jwt secret key"
}

# variable "db_host" {
#     type = string
#     description = "RDS host endpoint"
# }
#####################################################################################

#####################################################################################
# ALB Config

variable "alb_listener_port" {
  type        = number
  description = "listener port"
}

variable "alb_listener_protocol" {
  type        = string
  description = " listener protocol"
}

variable "ingress_from_port" {
  type        = number
  description = "ingress from port"
}

variable "ingress_to_port" {
  type        = number
  description = "ingress to port"
}

variable "ingress_protocol" {
  type        = string
  description = "ingress protocol"
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "ingress cidr block"
}

variable "egress_from_port" {
  type        = number
  description = "egress from port"
}

variable "egress_to_port" {
  type        = number
  description = "egress to port"
}

variable "egress_protocol" {
  type        = string
  description = "egress protocol"
}

variable "egress_cidr_blocks" {
  type        = list(string)
  description = "egress cidr block"
}
#####################################################################################

# Microservice config################################################################
# Account service#############################
variable "account_service_name" {
  type        = string
  description = "account service name"
}

variable "account_aws_region" {
  type        = string
  description = "region of this microservice"
}

variable "account_port" {
  type        = number
  description = "account port"
}

variable "account_path_pattern" {
  type        = list(string)
  description = "account path patterns"
}

variable "account_desired_count" {
  type        = number
  description = "account desired count"
}

variable "account_image_tag" {
  type        = string
  description = "account tag for ECR image"
}

# Bank service################################
variable "bank_service_name" {
  type        = string
  description = "bank service name"
}

variable "bank_aws_region" {
  type        = string
  description = "region of this microservice"
}

variable "bank_port" {
  type        = number
  description = "bank port"
}

variable "bank_path_pattern" {
  type        = list(string)
  description = "bank path patterns"
}

variable "bank_desired_count" {
  type        = number
  description = "bank desired count"
}

variable "bank_image_tag" {
  type        = string
  description = "bank tag for ECR image"
}
# Card service################################
variable "card_service_name" {
  type        = string
  description = "card service name"
}

variable "card_aws_region" {
  type        = string
  description = "region of this microservice"
}

variable "card_port" {
  type        = number
  description = "card port"
}

variable "card_path_pattern" {
  type        = list(string)
  description = "card path patterns"
}

variable "card_desired_count" {
  type        = number
  description = "card desired count"
}

variable "card_image_tag" {
  type        = string
  description = "card tag for ECR image"
}

# Transaction service################################
variable "transaction_service_name" {
  type        = string
  description = "transaction service name"
}

variable "transaction_aws_region" {
  type        = string
  description = "region of this microservice"
}

variable "transaction_port" {
  type        = number
  description = "transaction port"
}

variable "transaction_path_pattern" {
  type        = list(string)
  description = "transaction path patterns"
}

variable "transaction_desired_count" {
  type        = number
  description = "transaction desired count"
}

variable "transaction_image_tag" {
  type        = string
  description = "transaction tag for ECR image"
}

# Underwriter service################################
variable "underwriter_service_name" {
  type        = string
  description = "underwriter service name"
}

variable "underwriter_aws_region" {
  type        = string
  description = "region of this microservice"
}

variable "underwriter_port" {
  type        = number
  description = "underwriter port"
}

variable "underwriter_path_pattern" {
  type        = list(string)
  description = "underwriter path patterns"
}

variable "underwriter_desired_count" {
  type        = number
  description = "underwriter desired count"
}

variable "underwriter_image_tag" {
  type        = string
  description = "underwriter tag for ECR image"
}

# User service################################
variable "user_service_name" {
  type        = string
  description = "user service name"
}

variable "user_aws_region" {
  type        = string
  description = "region of this microservice"
}

variable "user_port" {
  type        = number
  description = "user port"
}

variable "user_path_pattern" {
  type        = list(string)
  description = "card path patterns"
}

variable "user_desired_count" {
  type        = number
  description = "user desired count"
}

variable "user_image_tag" {
  type        = string
  description = "user tag for ECR image"
}

# Common Variables############################
variable "cpu" {
  type        = number
  description = "cpu config"
}

variable "memory" {
  type        = number
  description = "memory config"
}

variable "alb_protocol" {
  type        = string
  description = "alb protocol"
}

variable "health_check_path" {
  type        = string
  description = "health check path"
}

variable "max_capacity" {
  type        = number
  description = ""
}

variable "min_capacity" {
  type        = number
  description = ""
}

variable "target_cpu" {
  type        = number
  description = "threshold for cpu"
}

variable "target_memory" {
  type        = number
  description = "threshold for memory"
}
###################################################################################
# Route 53
variable "hosted_zone_name" {
  description = "The name of the predefined hosted zone in route53"
  type        = string
}

variable "weighted_percentage" {
  description = "The weighted percent for traffic to record in hosted zone"
  type        = number
}