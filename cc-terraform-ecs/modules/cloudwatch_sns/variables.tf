variable "app_services" {
  type = list(string)
  description = "service name list"
}

variable "ecs_cluster_name" {
  type = string
  description = "ECS name"
}

variable "account_id" {
  type = number
  description = "AWS account number"
}

variable "aws_region" {
  type = string
  description = "aws region"
}