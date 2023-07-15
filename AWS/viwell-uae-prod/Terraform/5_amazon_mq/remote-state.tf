terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "viwell/prod-infra/mq/mq.tfstate"
    region         = "me-central-1"
  }
}
