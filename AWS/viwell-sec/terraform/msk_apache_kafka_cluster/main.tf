resource "aws_security_group" "additional" {
  name_prefix = "sec-msk-sg"
  vpc_id      = "vpc-0aea6cdaac7f36ae6"

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
      "10.60.0.0/16"
    ]
  }

  ingress {
    from_port = 2181
    to_port   = 2181
    protocol  = "tcp"
    cidr_blocks = [
       "10.60.0.0/16"
    ]
 }

  tags = {
    Name = "sec kafka cluster "
    ENV = "sec"
  }
}


module "kafka" {
  source = "cloudposse/msk-apache-kafka-cluster/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version = "2.3.0"

#  namespace                        = "sec"
#  stage                            = "sec"
  name                             = "sec-msk"
  vpc_id                           = "vpc-0aea6cdaac7f36ae6"
  # zone_id                          = "Z006534626WVGKU0BOA57"
  subnet_ids                       = ["subnet-008d919761eed7a26","subnet-0b6f91ece23799d10"]
  kafka_version                    = "3.2.0"
  broker_per_zone                  = 1 # this has to be a multiple of the # of subnet_ids
  broker_instance_type             = "kafka.t3.small"
  broker_volume_size               = 50
  storage_autoscaling_max_capacity = 100
  client_allow_unauthenticated     = true
  create_security_group            = true
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

#data "terraform_remote_state" "vpc" {
#  backend = "s3"
#  config = {
#    bucket         = "viwell-prod-infra"
#    key            = "dev/services/vpc/vpc.tfstate"
#    region         = "me-central-1"
#  }
#}