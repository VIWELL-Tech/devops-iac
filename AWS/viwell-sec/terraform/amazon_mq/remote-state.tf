terraform {
  backend "s3" {
    bucket         = "viwell-prod-infra"
    key            = "sec/services/mq/mq.tfstate"
    region         = "me-central-1"
  }
}
