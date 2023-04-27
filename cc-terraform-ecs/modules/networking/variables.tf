variable "env" {
  type = string
  description = "Environment"
}

variable "app_name" {
  type = string
  description = "Application name"
}

variable "cidr" {
  type = string
  description = "VPC CIDR"
}

variable "availability_zones" {
  type = list(string)
  description = "Availability zones that the services are running"
}

variable "private_subnets" {
  type = list(string)
  description = "Private subnets"
}

variable "public_subnets" {
  type = list(string)
  description = "Public subnets"
}