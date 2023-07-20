provider "aws" {
  region = var.region
}

resource "aws_security_group" "additional" {
  name_prefix = "redis-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }  

  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    cidr_blocks = [
      data.terraform_remote_state.vpc.outputs.vpc_cidr_block
    ]
 }

  tags = {
    Name = "for redis"
  }
}


module "Redis" {
  source  = "git::git@github.com:slashtec-code/terraform-modules.git//aws-elasticache-redis?ref=main"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  availability_zones= data.terraform_remote_state.eks.outputs.worker_nodes_az
  subnet_group_name= "redis-subnet-group"
  redis_parameter_group_name= "default.redis6.x"
  apply_immediately  = "true"
  auto_minor_version_upgrade = "true"
  ## redis_auth_token = null
  name = "redis-dev-a"
  cluster_size = "2"
  automatic_failover_enabled = "true"
  multi_az_enabled   = "false"
  redis_node_type = "cache.t4g.small"
  redis_port = "6379"
  family = "redis6.x"
  redis_version = "6.2.6"
  at_rest_encryption_enabled = "true"
  transit_encryption_enabled = "true"
  cluster_mode_enabled = "false"
  cluster_mode_replicas_per_node_group = "0"
  cluster_mode_num_node_groups = "0"
  redis_maintenance_window = "fri:08:00-fri:09:00"
  redis_snapshot_window = "06:30-07:30"
  redis_snapshot_retention_limit = "0"
  tags = {
        Owner       = "DevOps Team"
        Environment = "Development"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "viwell-iac"
    key    = "dev/services/vpc/vpc.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "viwell-iac"
    key    = "dev/services/eks-cluster/eks.tfstate"
    region = "us-east-1"
  }
}