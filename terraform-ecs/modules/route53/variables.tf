variable "hosted_zone_name" {
  description = "The name of the predefined hosted zone in route53"
  type        = string
}

variable "weighted_percentage" {
  description = "The weighted percent for traffic to record in hosted zone"
  type        = number
}

variable "version_name" {
  type        = string
  description = "version name (i.e. blue or green)"
}

variable "r53_host_zone_id" {
  type = string
  description = "hosted zone id of route53 resource"
}

variable "r53_host_zone_name" {
  type = string
  description = "hosted zone name of route53 resource"
}

variable "alb_dns_name" {
  type = string
  description = "alb's dns name"
}

variable "alb_zone_id" {
  type = string
  description = "alb's zone id"
}