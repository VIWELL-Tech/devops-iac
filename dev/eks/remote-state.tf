terraform {
  backend "s3" {
    bucket = "viwell-iac"
    key    = "dev/services/eks-cluster/eks.tfstate"
    region = "us-east-1"
  }
}