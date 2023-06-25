terraform {
  backend "s3" {
    bucket = "viwell-iac"
    key    = "shared/services/ec2/jenkins/tfstate"
    region = "us-east-1"
  }
}