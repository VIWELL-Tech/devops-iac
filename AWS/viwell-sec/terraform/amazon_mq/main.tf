provider "aws" {
  region = var.region

}

module "mq_broker" {
  source  = "cloudposse/mq-broker/aws"
  version = "2.0.1"

  vpc_id     = "vpc-0aea6cdaac7f36ae6"
  subnet_ids = ["subnet-0bf0e6c09539de809"]

  allowed_security_group_ids = ["sg-067204ddef978cf01"]
  allowed_cidr_blocks        = ["10.60.0.0/16"]
  allowed_ingress_ports      = [8162, 5671, 443]
  name                       = "sec-amazonmq"
  apply_immediately          = "true"
  auto_minor_version_upgrade = "true"
  deployment_mode            = "SINGLE_INSTANCE"
  engine_type                = "RabbitMQ"
  engine_version             = "3.10.20"
  host_instance_type         = "mq.t3.micro"
  publicly_accessible        = "false"
  general_log_enabled        = "true"
  audit_log_enabled          = "false"
  encryption_enabled         = "true"
  mq_admin_user              = [var.mq_admin_user]
  mq_admin_password          = [var.mq_admin_password]
  mq_application_user        = [var.mq_application_user]
  mq_application_password    = [var.mq_application_password]

  # ssm_path = "eg/mq/${var.attributes[0]}"

  security_group_create_before_destroy = true

  # context = module.this.context
}

#data "terraform_remote_state" "vpc" {
#  backend = "s3"
#  config = {
#    bucket         = "viwell-prod-infra"
#    key            = "dev/services/vpc/vpc.tfstate"
#    region         = "me-central-1"
#      }
#}

#data "terraform_remote_state" "eks" {
#  backend = "s3"
#  config = {
#    bucket         = "viwell-prod-infra"
#    key            = "dev/services/eks-cluster//eks.tfstate"
#    region         = "me-central-1"
#  }
#}