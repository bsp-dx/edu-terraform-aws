locals {
  name_prefix       = var.context.name_prefix
  name              = var.middle_name == null ? format("%s-redis", local.name_prefix) : format("%s-%s-redis", local.name_prefix, var.middle_name)
  tags              = merge(var.context.tags, var.additional_tags)
  subnet_group_name = format("%s-sng", local.name)
  member_clusters   = var.create_redis ? tolist(aws_elasticache_replication_group.default.0.member_clusters) : []

  # member_clusters_count 수는 cluster_mode_enabled 라면 shard*(replica + 1) 이고, 그렇지 않다면 cluster_size 이다.
  member_clusters_count = (var.cluster_mode_enabled ? (var.cluster_mode_num_node_groups * (var.cluster_mode_replicas_per_node_group + 1)) : var.cluster_size )
}

resource "aws_elasticache_subnet_group" "default" {
  count      = var.create_redis && length(var.subnet_ids) > 0 ? 1 : 0
  name       = local.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = merge(local.tags, { Name = local.subnet_group_name })
}

resource "aws_elasticache_parameter_group" "default" {
  count  = var.create_redis ? 1 : 0
  name   = "${local.name}-params"
  family = var.family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(local.tags, { Name = "${local.name}-params" })
}

resource "aws_elasticache_replication_group" "default" {
  count = var.create_redis ? 1 : 0

  auth_token                    = var.transit_encryption_enabled ? var.auth_token : null
  replication_group_id          = var.replication_group_id == "" ? local.name : var.replication_group_id
  replication_group_description = local.name
  node_type                     = var.instance_type
  number_cache_clusters         = var.cluster_mode_enabled ? null : var.cluster_size
  port                          = var.port
  parameter_group_name          = join("", aws_elasticache_parameter_group.default.*.name)
  availability_zones            = length(var.availability_zones) == 0 ? null : [for n in range(0, var.cluster_size) : element(var.availability_zones, n)]
  automatic_failover_enabled    = var.automatic_failover_enabled
  multi_az_enabled              = var.multi_az_enabled
  subnet_group_name             = local.subnet_group_name
  security_group_ids            = concat(var.security_group_ids, [])
  maintenance_window            = var.maintenance_window
  notification_topic_arn        = var.notification_topic_arn
  engine_version                = var.engine_version
  kms_key_id                    = var.at_rest_encryption_enabled ? var.kms_key_id : null
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled || var.auth_token != null
  snapshot_name                 = var.snapshot_name
  snapshot_arns                 = var.snapshot_arns
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  final_snapshot_identifier     = var.final_snapshot_identifier
  apply_immediately             = var.apply_immediately

  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? ["true"] : []
    content {
      replicas_per_node_group = var.cluster_mode_replicas_per_node_group
      num_node_groups         = var.cluster_mode_num_node_groups
    }
  }

  tags = merge(local.tags, { Name = local.name })

  depends_on = [aws_elasticache_subnet_group.default, aws_elasticache_parameter_group.default]
}

##### aws_cloudwatch_metric_alarm
resource "aws_cloudwatch_metric_alarm" "cpu" {
  count               = var.create_redis && var.cloudwatch_metric_alarms_enabled ? local.member_clusters_count : 0
  alarm_name          = "${element(local.member_clusters, count.index)}-cpu-utilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = var.alarm_cpu_threshold_percent

  dimensions = {
    CacheClusterId = element(local.member_clusters, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  tags = merge(local.tags, { Name = "${element(local.member_clusters, count.index)}-cpu-utilization" })

  depends_on = [aws_elasticache_replication_group.default]
}

resource "aws_cloudwatch_metric_alarm" "memory" {
  count               = var.create_redis && var.cloudwatch_metric_alarms_enabled ? local.member_clusters_count : 0
  alarm_name          = "${element(local.member_clusters, count.index)}-freeable-memory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = var.alarm_memory_threshold_bytes

  dimensions = {
    CacheClusterId = element(local.member_clusters, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  tags = merge(local.tags, { Name = "${element(local.member_clusters, count.index)}-freeable-memory" })

  depends_on = [aws_elasticache_replication_group.default]
}
