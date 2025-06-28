output "RDSEndpoint" {
  description = "RDS endpoint"
  value = aws_db_instance.vprofile-rds.endpoint
}

output "MemecacheEndpoint" {
  description = "Memecache endpoint"
  value = aws_elasticache_cluster.vprofile-cache.configuration_endpoint
}

output "RabbitMQEndpoint" {
  description = "RabbitMQ endpoint"
  value = aws_mq_broker.vprofile-rmq.instances.0.endpoints
}