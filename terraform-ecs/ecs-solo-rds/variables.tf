########################## DB Varibles #################################

variable "aws_region" {
  description = "The aws region."
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  type = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "db_cidr" {
  type = string
  description = "cidr block for db vpc"
}

variable "db_name" {
  type = string
  description = "RDS DB name"
}

variable "db_user_name" {
  type = string
  description = "RDS DB user name"
}

variable "db_instance_class" {
  type = string
  description = "RDS instance type"
}

variable "engine_version" {
  type = string
  description = "RDS engine version"
}

variable "allocated_storage" {
  type = string
  description = "storage allocation for RDS DB"
}

variable "db_port" {
  type        = string
  description = "RDS DB access Port"
}
