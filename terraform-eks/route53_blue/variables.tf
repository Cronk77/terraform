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
}

variable "hosted_zone_name" {
  description = "The name of the predefined hosted zone in route53"
  type        = string
}

variable "weighted_blue" {
  description = "The weighted percent for traffic to blue record in hosted zone"
  type        = number
}

variable "blue_s3_bucket_name" {
  description = "S3 bucket where blue's remote state file is located"
}

variable "blue_remote_state" {
  description = "The name of the remote state in AWS that has the blue's cluster"
  type        = string
}
