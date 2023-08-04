provider "aws" {
  region = "me-central-1"
}

module "viwell-sec-cluster" {
  source = "git::git@github.com:VIWELL-Tech/devops-terraform-modules.git//aws-elasticache-redis?ref=main"
  apply_immediately = "true"
  auto_minor_version_upgrade = "true"
  node_type = "cache.t3.small"
  name_prefix                 = "sec-redis"
  #cluster_size               = "1"
  num_cache_clusters          = "1"
  automatic_failover_enabled  = "false"
  multi_az_enabled            = "false"
  #edis_node_type             = "cache.t2.small"
  family                      = "redis6.x"
  #redis_version               = "6.x"
  engine_version              = "6.x"
  at_rest_encryption_enabled  = "false"
  transit_encryption_enabled  = "false"
  cluster_mode_enabled        = "false"
  vpc_id                      = "vpc-0aea6cdaac7f36ae6"
  subnet_ids                  = ["subnet-0e48a43d9c6ffe000","subnet-02b40fb935615acd6"]
  ingress_cidr_blocks = ["10.60.0.0/16"]
}
