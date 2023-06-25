terraform {
  backend "s3" {
    bucket = "viwell-iac"
    key    = "shared/services/ec2/vpn/tfstate"
    region = "us-east-1"
  }
}