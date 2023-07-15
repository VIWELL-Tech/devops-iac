terraform {
    required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/lambda/github_backup.tfstate"
    region         = "me-central-1"
  }
}
