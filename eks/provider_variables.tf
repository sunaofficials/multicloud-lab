terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# -------------------------
# VARIABLES
# -------------------------

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.32"
}

# -------------------------
# PROVIDER
# -------------------------

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

