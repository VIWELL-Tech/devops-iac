provider "aws" {
  region = "me-central-1"
}

module "viwell-prod-cluster" {
  source = "git::git@github.com:slashtec-code/terraform-modules.git//aws-elasticache-redis?ref=main"
  apply_immediately = "true"
  auto_minor_version_upgrade = "true"
  name                       = "viwell-prod-cluster"
  cluster_size               = "1"
  automatic_failover_enabled  = "false"
  multi_az_enabled            = "false"
  redis_node_type             = "cache.t2.small"
  family                      = "redis6.x"
  redis_version               = "6.x"
  at_rest_encryption_enabled  = "false"
  transit_encryption_enabled  = "false"
  cluster_mode_enabled        = "false"
  vpc_id                      = "vpc-0c708b8993066e7fe"
  subnet_ids                  = ["subnet-0e227f493a97404ac","subnet-02230bb50ebc733f1","subnet-07bcff630d9622561"]
  subnet_group_name           = "viwell-prod-cluster"
  availability_zones          = ["me-central-1c"]
  redis_secret_name           = "viwell_prod_cluster"
  redis_parameter_group_name  = "viwell-prod-cluster-redis6-pg"
  redis_ingress_rules = [{
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    cidr_blocks = "10.50.0.0/16"
    description = "allow access to Redis from VPC "
  }
  ]
}
