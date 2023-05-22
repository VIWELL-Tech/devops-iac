data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_security_group" "es" {
  name        = "${var.es-domain}-es-sg"
  vpc_id      = var.vpc-id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = var.cidrs-to-whitelist
  }
}

#resource "aws_iam_service_linked_role" "es" {
 # aws_service_name = "es.amazonaws.com"
#}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.es-domain
  elasticsearch_version = var.es-version

  cluster_config {
    instance_type = var.instance-type
    instance_count = var.instance-count
    zone_awareness_enabled = true
    zone_awareness_config {
      availability_zone_count = var.zone-count
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.volume-size
  }

  vpc_options {
    subnet_ids = slice(var.pvt-sub-ids, 0, var.zone-count)

    security_group_ids = ["${aws_security_group.es.id}"]
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es-domain}/*"
        }
    ]
}
CONFIG

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = {
    Domain = var.es-domain
  }

 # depends_on = [
  #  "aws_iam_service_linked_role.es",
 #]
}
