terraform {
  backend "s3" {
    bucket = "viwell-iac"
    key    = "dev/services/node-groups/node-groups.tfstate"
    region = "us-east-1"
  }
}