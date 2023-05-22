output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}

output "eks_sa_role" {
  value = "${aws_iam_role.eks_sa_role.arn}"
}

output "eks_ca_cert" {
  value = "${aws_eks_cluster.k8-cluster.certificate_authority.0.data}"
}

output "eks_endpoint" {
  value = "${aws_eks_cluster.k8-cluster.endpoint}"
}