terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

# -------------------------
# VARIABLES
# -------------------------

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes Version"
  type        = string
  default     = "1.32"
}

# -------------------------
# PROVIDER
# -------------------------

provider "aws" {
  region = var.region
}

# Needed for subnet creation
data "aws_availability_zones" "available" {
  state = "available"
}


variable "node_instance_type" {
  description = "Instance type for Karpenter nodes"
  type        = string
  default     = "t3.medium"
}
