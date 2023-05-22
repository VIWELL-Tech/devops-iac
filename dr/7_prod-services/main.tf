locals {
  region = "us-west-2"
}

resource "helm_release" "services" {
  count             = length(var.services)
  name              = var.services[count.index]
  repository        = "./Helm-charts"
  chart             = var.services[count.index]
  namespace         = "prod"
  create_namespace  = false
  force_update      = true
  dependency_update = true #helm repo update command

  set {
    name  = "image.tag"
    value = "latest"
  }

    set {
    name  = "DB_HOST"
    value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
  }

    set {
    name  = "DB_USER"
    value = data.terraform_remote_state.mongo_atlas.outputs.username
  }

    set {
    name  = "DB_PASS"
    value = data.terraform_remote_state.mongo_atlas.outputs.user_password
  }

    set {
    name  = "kafkabroker1"
    value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
  }  

    set {
    name  = "kafkabroker2"
    value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
  }  

    set {
    name  = "mquser"
    value = data.terraform_remote_state.mq.outputs.application_username
  }

    set {
    name  = "mqpass"
    value = var.rabbitmq_password
  }

    set {
    name  = "broker_id"
    value = data.terraform_remote_state.mq.outputs.broker_id
  }  

    set {
    name  = "redis_endpoint"
    value = data.terraform_remote_state.redis.outputs.redis_endpoint
  }    

    set {
    name  = "region"
    value = local.region
  }      

}

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }

# resource "helm_release" "assessment" {
#   # count             = length(var.services)
#   # name              = var.services[count.index]
#   name              = "assessment"
#   repository        = "./Helm-charts"
#   # chart             = var.services[count.index]
#   chart             = "assessment"
#   namespace         = "prod"
#   create_namespace  = false
#   force_update      = true
#   dependency_update = true #helm repo update command

#   set {
#     name  = "image.tag"
#     value = "prod-37"
#   }

#     set {
#     name  = "DB_HOST"
#     value = data.terraform_remote_state.mongo_atlas.outputs.atlas_cluster_connection_string
#   }

#     set {
#     name  = "DB_USER"
#     value = data.terraform_remote_state.mongo_atlas.outputs.username
#   }

#     set {
#     name  = "DB_PASS"
#     value = data.terraform_remote_state.mongo_atlas.outputs.user_password
#   }

#     set {
#     name  = "kafkabroker1"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[0]
#   }  

#     set {
#     name  = "kafkabroker2"
#     value = data.terraform_remote_state.kafka.outputs.all_brokers[1]
#   }  

#     set {
#     name  = "mquser"
#     value = data.terraform_remote_state.mq.outputs.application_username
#   }

#     set {
#     name  = "mqpass"
#     value = var.rabbitmq_password
#   }

#     set {
#     name  = "broker_id"
#     value = data.terraform_remote_state.mq.outputs.broker_id
#   }  

#     set {
#     name  = "redis_endpoint"
#     value = data.terraform_remote_state.redis.outputs.redis_endpoint
#   }    

#     set {
#     name  = "region"
#     value = local.region
#   }      

# }
# # resource "kubernetes_config_map" "dbconfig" {
# #    metadata {
# #        name = "dbconfig"
# #    }
# #    data = {
# #        dbconnection = "db"
# #    }
# # }

# # resource "helm_release" "kibana" {
# #   name              = "kibana"
# #   repository        = "./eck-resources-with-helm-charts/stack/charts"
# #   chart             = "kibana"
# #   namespace         = "mon"
# #   create_namespace  = false
# #   force_update      = true
# #   dependency_update = true #helm repo update command

# #   depends_on = [
# #     helm_release.elasticsearch
# #   ]

# #   values = [
# #     "${file("kibana-values.yml")}"
# #   ]
# # }

# # resource "helm_release" "logstash" {
# #   name       = "logstash"
# #   repository = "https://helm.elastic.co"
# #   chart      = "logstash"
# #   version    = "7.17.3"
# #   timeout    = 900
# #   namespace  = "mon"

# #   depends_on = [
# #     helm_release.elasticsearch
# #   ]

# #   values = [
# #     "${file("logstash-values.yml")}"
# #   ]

# #   set {
# #     name  = "imageTag"
# #     value = "7.17.5"
# #   }
# # }

# # resource "helm_release" "filebeat" {
# #   name       = "filebeat"
# #   repository = "./eck-resources-with-helm-charts"
# #   chart      = "filebeat"
# #   version    = "0.1.0"
# #   timeout    = 900
# #   namespace  = "mon"

# #   depends_on = [
# #     helm_release.logstash
# #   ]

# #   values = [
# #     "${file("filebeat-values.yml")}"
# #   ]

# #   set {
# #     name  = "imageTag"
# #     value = "7.17.3"
# #   }
# # }


# data "terraform_remote_state" "eks" {
#   backend = "s3"
#   config = {
#     bucket = "dr-test-viwell"
#     key    = "infrastructure/prod/eks.tfstate"
#     region = "us-west-2"
#   }
# }

# data "terraform_remote_state" "mongo_atlas" {
#   backend = "s3"
#   config = {
#     bucket = "dr-test-viwell"
#     key    = "infrastructure/prod/mongo-atlas.tfstate"
#     region = "us-west-2"
#   }
# }

# data "terraform_remote_state" "kafka" {
#   backend = "s3"
#   config = {
#     bucket = "dr-test-viwell"
#     key    = "infrastructure/prod/msk-apache-kafka-cluster.tfstate"
#     region = "us-west-2"
#   }
# }

# data "terraform_remote_state" "mq" {
#   backend = "s3"
#   config = {
#     bucket = "dr-test-viwell"
#     key    = "infrastructure/prod/amazon-mq.tfstate"
#     region = "us-west-2"
#   }
# }

# data "terraform_remote_state" "redis" {
#   backend = "s3"
#   config = {
#     bucket = "dr-test-viwell"
#     key    = "infrastructure/prod/redis.tfstate"
#     region = "us-west-2"
#   }
# }