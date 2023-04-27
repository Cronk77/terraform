terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket          = "cc-aline-eks-bucket"
    # dynamodb_table  = "" # SET UP DYNAM TABLE
    key             = "terraform_state_green_route53.tfstate" # CHANGE THIS FOR NEW VERSIONS
    region          = "us-east-2"
    encrypt         = true
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Grabs the hosted zone data
data "aws_route53_zone" "hosted_zone" {
  name         = var.hosted_zone_name
  private_zone = false
}

######################################### GREEN #################################################
# Grabs remote state for the green cluster to get elb name from output
data "terraform_remote_state" "green-cluster" {
  backend = "s3"
  config = {
    bucket = "${var.green_s3_bucket_name}"
    # key    = "terraform_state_green.tfstate"
    key    = "${var.green_remote_state}"
    region = "${var.region}"
  }
}

# Grabs the green cluster ELB data using the remote state for the "green-cluster" data resource
data "aws_elb" "green_aws_elb" {
  name = data.terraform_remote_state.green-cluster.outputs.elb_name
}

# Creates a blue record for the hosted zone given
resource "aws_route53_record" "green_cluster_record" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = data.aws_route53_zone.hosted_zone.name
  type    = "A"

  alias {
    name                   = data.aws_elb.green_aws_elb.dns_name
    zone_id                = data.aws_elb.green_aws_elb.zone_id
    evaluate_target_health = true
  }

  set_identifier = "green"
  weighted_routing_policy {
    weight = var.weighted_green
  }
}