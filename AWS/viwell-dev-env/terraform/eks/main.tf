locals {
  region          = "us-east-1"
  cluster_version = "1.22"
  cluster_name    = "dev-viwell"
  vpc_id          = "vpc-0721620c5d7fa2d09"
  profile         = "default" # awscli profile
}


module "eks-cluster" {
  source = "../../terraform-modules/eks-cluster"

  region          = local.region
  cluster_version = local.cluster_version
  cluster_name    = local.cluster_name
  vpc_id          = local.vpc_id
}


resource "null_resource" "merge_kubeconfig" {
  triggers = {
    always = timestamp()
  }

  depends_on = [module.eks-cluster]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<EOT
      set -e
      echo 'Applying Auth ConfigMap with kubectl...'
      aws eks wait cluster-active --name '${local.cluster_name}'
      aws eks update-kubeconfig --name '${local.cluster_name}' --alias '${local.cluster_name}' --region=${local.region} --profile=${local.profile}
    EOT
  }
}