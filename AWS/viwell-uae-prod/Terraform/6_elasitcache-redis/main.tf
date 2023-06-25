provider "aws" {
  region = "me-central-1"
}

module "viwell-prod-cluster" {
  source = "git::git@github.com:VIWELL-Tech/devops-terraform-modules.git//aws-elasticache-redis?ref=main"
  apply_immediately = "true"
  auto_minor_version_upgrade = "true"
  node_type = "cache.t3.medium"
  name_prefix                       = "viwell-prod-cluster"
  #cluster_size               = "1"
  num_cache_clusters          = "2"
  automatic_failover_enabled  = "false"
  multi_az_enabled            = "false"
  #edis_node_type             = "cache.t2.small"
  family                      = "redis6.x"
  #redis_version               = "6.x"
  engine_version              = "6.x"
  at_rest_encryption_enabled  = "false"
  transit_encryption_enabled  = "false"
  cluster_mode_enabled        = "false"
  vpc_id                      = "vpc-0c708b8993066e7fe"
  subnet_ids                  = ["subnet-0e227f493a97404ac","subnet-02230bb50ebc733f1","subnet-07bcff630d9622561"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
}
