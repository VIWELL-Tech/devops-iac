provider "aws" {
  region = "me-central-1"
}

module "ecr" {
  source       = "cloudposse/ecr/aws"
  version      = "0.35.0"
  namespace    = "eg"
  stage        = "prod"
  name         = "app"
  use_fullname = false
  image_names  = ["api-gateway","activity", "assessment", "gateway", "auth", "avatar", "booking", "category", "checkins", "content", "email", "favorite", "logger", "loyalty", "media", "notification", "organization", "personalisation", "pillar", "progress", "push-notification", "rbac", "report", "review", "reward", "schedular", "sms", "socket", "tag", "trigger"]
}