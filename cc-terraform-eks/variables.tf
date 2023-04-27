variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The aws region."
  type        = string
  default     = "us-east-2"
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  type = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "CC-Aline-Project-EKS"
    "Environment" = "Development"
    "Owner"       = "Colton Cronquist"
  }
}

########################## DB Varibles #################################

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

#######  PODS CONFIG ##########
variable "encrypt_secret_key" {
  type        = string
  description = "Microservice Application encryption key"
}

variable "jwt_secret_key" {
  type        = string
  description = "Microservice Application jwt secret key"
}

variable "microservices" {
  type = list(string)
  description = "service name list"
}

variable "microservice_ports" {
  type = list(number)
  description = "service port list following microservice variable order"
}