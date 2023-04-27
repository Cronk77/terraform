variable "project" {
  type = string
  description = "project name"
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

variable "availability_zones" {
  type = list(string)
  description = "Availability zones that the services are running"
}

variable "aws_region" {
  type = string
  description = "AWS region builing the RDS"
}

