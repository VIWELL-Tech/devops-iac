terraform {
  backend "s3" {
    bucket = "viwell-dev-infra"
    key    = "dev/services/eks-cluster/eks.tfstate"
    region = "us-east-1"
  }
}