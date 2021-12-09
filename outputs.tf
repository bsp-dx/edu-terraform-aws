output "cluster_id" {
  value       = join("", aws_elasticache_replication_group.default.*.id)
  description = "Redis cluster ID"
}

output "cluster_arn" {
  value       = join("", aws_elasticache_replication_group.default.*.arn)
  description = "Elasticache Replication Group ARN"
}

output "cluster_enabled" {
  value       = join("", aws_elasticache_replication_group.default.*.cluster_enabled)
  description = "Indicates if cluster mode is enabled"
}

output "port" {
  value       = var.port
  description = "Redis port"
}

output "endpoint" {
  value       = var.cluster_mode_enabled ? join("", aws_elasticache_replication_group.default.*.configuration_endpoint_address) : join("", aws_elasticache_replication_group.default.*.primary_endpoint_address)
  description = "Redis primary or configuration endpoint, whichever is appropriate for the given cluster mode"
}

output "reader_endpoint" {
  value       = join("", compact(aws_elasticache_replication_group.default.*.reader_endpoint_address))
  description = "The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled."
}

output "member_clusters" {
  value       = aws_elasticache_replication_group.default.*.member_clusters
  description = "Redis cluster members"
}

output "engine_version_actual" {
  value       = join("", aws_elasticache_replication_group.default.*.engine_version_actual)
  description = "The running version of the cache engine"
}

