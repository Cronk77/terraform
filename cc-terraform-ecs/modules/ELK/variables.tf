variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
  description = "Private subnet one"
}

variable "cidr" {
  type = string
  description = "VPC CIDR"
}

variable "aws_region" {
  type = string
  description = "aws region"
}

variable "account_id" {
  type = number
  description = "AWS account number"
}

variable "availability_zones" {
  type = list(string)
  description = "Availability zones that the services are running"
}

variable "ecs_role_name" {
  type = string
  description = "ecs iam role execution name"
}

variable "ecs_task_execution_role_arn" {
  type = string
  description = "ecs iam role execution arn"
}

variable "app_services" {
  type = list(string)
  description = "service name list"
}

variable "es_endpoint" {
  type = string
  default = "https://search-cc-es-domain-dg65mxaq4w7frjbzkd7g4hups4.us-east-2.es.amazonaws.com/"
}

variable "cwl_endpoint" {
  type = string
  default = "logs.us-east-2.amazonaws.com"
}

variable "log_name" {
  type = list(string)
  description = "names of the log groups that will be added to ELK"
}