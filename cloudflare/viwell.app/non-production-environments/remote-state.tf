terraform {
  backend "s3" {
    bucket         = "viwell-dev-infra"
    key            = "cloudflare/viwll-app.tfstate"
    region         = "us-east-1"
  }
}