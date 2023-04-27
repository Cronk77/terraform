variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  type = string
}

variable "version_name" {
  type = string
  description = "the version of the cluster (i.e. blue or green)"
}

variable "eks_version" {
  type        = string
  description = "The version of the eks cluster to create"
  default     = "1.24"
}

variable "vpc_id"{
  description = "vpc id of cluster"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "nodes_sg" {
  description = "Security groups for nodes"
  type        = string
}