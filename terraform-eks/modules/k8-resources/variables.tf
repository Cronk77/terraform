variable "db_endpoint" {
    type = string
    description = "RDS host endpoint"
}

variable "db_password" {
    type = string
    description = "bd password"
}

variable "encrypt_secret_key" {
    type = string
}

variable "jwt_secret_key" {
    type = string
}

variable "db_user_name" {
    type = string
}

