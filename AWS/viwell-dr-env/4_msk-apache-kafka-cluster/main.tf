resource "aws_security_group" "additional" {
  name_prefix = "msk-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }  

  ingress {
    from_port = 9091
    to_port   = 9095
    protocol  = "tcp"
    cidr_blocks = [
      data.terraform_remote_state.vpc.outputs.vpc_cidr_block
    ]
  }

  ingress {
    from_port = 2181
    to_port   = 2181
    protocol  = "tcp"
    cidr_blocks = [
      data.terraform_remote_state.vpc.outputs.vpc_cidr_block
    ]
 }

  tags = {
    Name = "for msk"
  }
}


module "kafka" {
  source = "cloudposse/msk-apache-kafka-cluster/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version = "1.1.1"

  namespace                        = "viwell"
  stage                            = "prod"
  name                             = "app"
  vpc_id                           = data.terraform_remote_state.vpc.outputs.vpc_id
  # zone_id                          = "Z006534626WVGKU0BOA57"
  subnet_ids                       = data.terraform_remote_state.vpc.outputs.private_subnets
  kafka_version                    = "3.2.0"
  broker_per_zone                  = 1 # this has to be a multiple of the # of subnet_ids
  broker_instance_type             = "kafka.t3.small"
  broker_volume_size               = 50
  storage_autoscaling_max_capacity = 100
  create_security_group            = false
  client_broker                    = "TLS_PLAINTEXT"
  properties                       = {
                                      "auto.create.topics.enable"="true"
                                      "default.replication.factor"="2"
                                      "min.insync.replicas"="2"
                                      "num.io.threads"="8"
                                      "num.network.threads"="5"
                                      "num.partitions"="1"
                                      "num.replica.fetchers"="2"
                                      "replica.lag.time.max.ms"="30000"
                                      "socket.receive.buffer.bytes"="102400"
                                      "socket.request.max.bytes"="104857600"
                                      "socket.send.buffer.bytes"="102400"
                                      "unclean.leader.election.enable"="true"
                                      "zookeeper.session.timeout.ms"="18000"
                                      "delete.topic.enable"="true"
                                     }
  # security groups to put on the cluster itself
  associated_security_group_ids = [aws_security_group.additional.id]
  # security groups to give access to the cluster
  # allowed_security_group_ids = ["sg-XXXXXXXXX", "sg-YYYYYYYY"]
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "dr-test-viwell"
    key    = "infrastructure/prod/vpc.tfstate"
    region = "us-west-2"
  }
}