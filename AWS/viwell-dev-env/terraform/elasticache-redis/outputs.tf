output "id" {
  value       = module.Redis.id
  description = "Redis cluster id."
}

output "redis_endpoint" {
  value       = module.Redis.endpoint
  description = "Redis endpoint address."
}