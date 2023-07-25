terraform {
  backend "s3" {
    bucket = "viwell-dev-infra"
    key    = "dev/services/node-groups/node-groups.tfstate"
    region = "us-east-1"
  }
}