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

variable "weighted_green" {
  description = "The weighted percent for traffic to green record in hosted zone"
  type        = number
}

variable "green_s3_bucket_name" {
  description = "S3 bucket where green's remote state file is located"
}

variable "green_remote_state" {
  description = "The name of the remote state in AWS that has the green's cluster"
  type        = string
}
