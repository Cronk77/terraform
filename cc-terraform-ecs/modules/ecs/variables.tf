# ECS variables

variable "app_name" {
  type = string
  description = "Application name"
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_id"{
  type = string
}