# iam/variables.tf

variable "app_name" {
  type = string
}

variable "version_name" {
  type        = string
  description = "version name (i.e. blue or green)"
}