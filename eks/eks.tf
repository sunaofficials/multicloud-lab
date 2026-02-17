module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.15.1"

  # The new v21 variable names:
  name                    = var.cluster_name
  kubernetes_version      = "1.32"
  endpoint_private_access = true
  endpoint_public_access  = false

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Note: enable_irsa = true MUST be removed. 
  # It was

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      ami_type = "AL2_x86_64"
    }
  }

  tags = {
    Environment = "lab"
    Terraform   = "true"
  }
}