
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.4"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.7.0"
    }
  }
  backend "s3" {
    bucket          = "cc-aline-eks-bucket"
    # dynamodb_table  = "" # SET UP DYNAM TABLE
    key             = "terraform_state_blue.tfstate" # CHANGE THIS FOR NEW VERSIONS
    region          = "us-east-2"
    encrypt         = true
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "nginx-ingress-controller" {
  source                    = "../modules/nginx-ingress-controller"
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_ver.secret_string)
}

module "networking" {
  source                    = "../modules/networking"
  availability_zones_count  = var.availability_zones_count
  availability_zones        = data.aws_availability_zones.available.names
  project                   = var.project
  vpc_cidr                  = var.vpc_cidr
  subnet_cidr_bits          = var.subnet_cidr_bits
  tags                      = var.tags
  version_name              = var.version_name
}

module "eks" {
  source              = "../modules/eks"
  project             = var.project
  private_subnets     = module.networking.private_subnets
  public_subnets      = module.networking.public_subnets
  tags                = var.tags
  vpc_id              = module.networking.vpc_id
  nodes_sg            = module.workernodes.nodes_sg
  version_name        = var.version_name
}

module "k8-resources" {
    source              = "../modules/k8-resources"
    db_endpoint         = local.db_creds.host
    db_password         = local.db_creds.password
    db_user_name        = local.db_creds.username
    encrypt_secret_key  = var.encrypt_secret_key
    jwt_secret_key      = var.jwt_secret_key
}

module "workernodes" {
    source              = "../modules/workernodes"
    private_subnets     = module.networking.private_subnets
    vpc_id              = module.networking.vpc_id 
    cluster_sg          = module.eks.cluster_sg
    cluster_name        = module.eks.cluster_name
    project             = var.project
    tags                = var.tags
    version_name        = var.version_name
}