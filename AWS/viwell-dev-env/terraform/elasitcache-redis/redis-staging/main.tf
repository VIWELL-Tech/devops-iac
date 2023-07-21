provider "aws" {
  region = "us-east-1"
}

module "viwell-redis-staging" {
  source = "git::git@github.com:VIWELL-Tech/devops-terraform-modules.git//aws-elasticache-redis?ref=main"
  apply_immediately = "true"
  auto_minor_version_upgrade  = "true"
  node_type                   = "cache.t4g.small"
  name_prefix                 = "viwell-staging"
  num_cache_clusters          = "1"
  automatic_failover_enabled  = "false"
  multi_az_enabled            = "false"
  family                      = "redis6.x"
  engine_version              = "6.x"
  at_rest_encryption_enabled  = "true"
  transit_encryption_enabled  = "true"
  cluster_mode_enabled        = "false"
  vpc_id                      = "vpc-0721620c5d7fa2d09"
  subnet_ids                  = ["subnet-0b4a643d057a201a7","subnet-02a91050110471adc"]
  ingress_cidr_blocks         = ["10.21.0.0/16"]
  description                 = "Redis Instance For STG ENV Managed by Terraform"
}
