output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = module.kafka.cluster_arn
}

output "all_brokers" {
  description = "A list of all brokers"
  value       = module.kafka.all_brokers
}