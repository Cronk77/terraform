# ALB Config
variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
  description = "Public subnet one"
}

variable "app_name" {
  type = string
  description = "Application name"
}

variable "version_name" {
  type        = string
  description = "version name (i.e. blue or green)"
}

variable "alb_listener_port" {
  type = number
  description = "listener port"
}

variable "alb_listener_protocol" {
    type = string
    description = " listener protocol"
}

variable "ingress_from_port" {
    type = number
    description = "ingress from port"
}

variable "ingress_to_port" {
    type = number
    description = "ingress to port"
}

variable "ingress_protocol" {
    type = string
    description = "ingress protocol"
}

variable "ingress_cidr_blocks" {
    type = list(string)
    description = "ingress cidr block"
}

variable "egress_from_port" {
    type = number
    description = "egress from port"
}

variable "egress_to_port" {
    type = number
    description = "egress to port"
}

variable "egress_protocol" {
    type = string
    description = "egress protocol"
}

variable "egress_cidr_blocks" {
    type = list(string)
    description = "egress cidr block"
}