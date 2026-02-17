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

variable "node_instance_type" {
  description = "Node Instance Type"
  type        = string
  default     = "t3.medium"
}
