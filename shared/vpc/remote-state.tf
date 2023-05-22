terraform {
  backend "s3" {
    bucket = "viwell-iac"
    key    = "shared/services/vpc/vpc.tfstate"
    region = "us-east-1"
  }
}