terraform {
  backend "s3" {
    bucket = "viwell-dev-infra"
    key    = "dev/services/eks-cluster/nginx-controller.tfstate"
    region = "us-east-1"
  }
}
