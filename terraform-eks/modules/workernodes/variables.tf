variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  type = string
}

variable "version_name" {
  type = string
  description = "the version of the cluster (i.e. blue or green)"
}

variable "cluster_name" {
    description = "eks cluster name"
    type        = string
}

variable "vpc_id"{
  description = "vpc id of cluster"
  type        = string
}

variable "private_subnets" {
    description = "subnets for worker nodes"
    type        = list(string)
}

variable "cluster_sg" {
    description = "security group for cluster"
    type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}