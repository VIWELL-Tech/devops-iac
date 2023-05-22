# -----------------------------------------------------------------------------
# Configure Kubernetes to permit the nodes to register
# -----------------------------------------------------------------------------
# data "aws_eks_cluster" "selected" {
#   name = "eks_cluster"
# }

data "aws_eks_cluster_auth" "selected" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  config_path            = "~/.kube/config"
  host                   = data.aws_eks_cluster.selected.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.selected.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.selected.token
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<-EOT
      - rolearn: ${aws_iam_role.eks_self_managed_node_group.arn}
        username: system:node:{{EC2PrivateDNSName}}
        groups:
          - system:bootstrappers
          - system:nodes
      - rolearn: arn:aws:iam::814880204573:role/jenkins
        username: jenkins                 
        groups:
          - system:masters
    EOT
    mapUsers = <<-EOT
    EOT
  }
}
