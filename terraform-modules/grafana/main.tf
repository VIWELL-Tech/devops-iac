resource "grafana_dashboard" "kafka_dashboard" {
  config_json = file(var.kafka_dashboard)
}

resource "grafana_dashboard" "k8_cluster" {
  config_json = file(var.k8_cluster)
}

resource "grafana_dashboard" "k8_pod_overview" {
  config_json = file(var.k8_pod_overview)
}

resource "grafana_dashboard" "nginx_ingress_controller" {
  config_json = file(var.nginx_ingress_controller)
}

resource "grafana_dashboard" "node_exporter_full" {
  config_json = file(var.node_exporter_full)
}

resource "grafana_data_source" "data_source_weave" {
  name = "Prometheus-Weave"
  type = "prometheus"
  url = var.weave_prometheus_url
  basic_auth_enabled = "true"
  basic_auth_username = "weave"
  basic_auth_password = var.prometheus_passwd
}

resource "grafana_data_source" "data_source_aiven" {
  name = "Prometheus-Aiven"
  type = "prometheus"
  url = var.aiven_prometheus_url

}
resource "grafana_alert_notification" "alert_slack" {
  name = "notify-slack"
  type = "slack"

  settings  = {
    url = var.slack_channel_webhook
    username = "Aiven-Kafka"
  }
}