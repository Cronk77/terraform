# ECS variables

variable "app_name" {
  type = string
  description = "Application name"
}

variable "version_name" {
  type        = string
  description = "version name (i.e. blue or green)"
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_id"{
  type = string
}