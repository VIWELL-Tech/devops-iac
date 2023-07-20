terraform {
  backend "s3" {
    bucket = "viwell-iac"
    key    = "dev/services/vpc/vpc.tfstate"
    region = "us-east-1"
  }
}