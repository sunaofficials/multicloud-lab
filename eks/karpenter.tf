module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.0"

  cluster_name             = module.eks.cluster_name
  irsa_oidc_provider_arn   = module.eks.oidc_provider_arn
}

resource "helm_release" "karpenter" {
  name       = "karpenter"
  namespace  = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"

  create_namespace = true

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter.service_account_role_arn

  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "clusterEndpoint"
    value = module.eks.cluster_endpoint
  }
}

resource "kubectl_manifest" "nodeclass" {
  yaml_body = <<YAML
apiVersion: karpenter.k8s.aws/v1beta1
kind: EC2NodeClass
metadata:
  name: default
spec:
  amiFamily: AL2
  role: ${module.karpenter.node_iam_role_name}
  subnetSelectorTerms:
    - tags:
        kubernetes.io/role/internal-elb: "1"
  securityGroupSelectorTerms:
    - tags:
        aws:eks:cluster-name: ${var.cluster_name}
YAML
}


resource "kubectl_manifest" "nodepool" {
  yaml_body = <<YAML
apiVersion: karpenter.sh/v1beta1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      requirements:
        - key: "node.kubernetes.io/instance-type"
          operator: In
          values: ["${var.node_instance_type}"]
      nodeClassRef:
        name: default
  disruption:
    consolidationPolicy: WhenUnderutilized
YAML
}
