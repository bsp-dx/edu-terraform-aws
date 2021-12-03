locals {
  region_alias = lookup(local.aws_region_codes, var.context.region, "nn")
  env_alias    = lower(substr(var.context.environment, 0, 1))
  local_tags   = {
    Project     = var.context.project
    Environment = var.context.environment
    Team        = var.context.team
    Owner       = var.context.owner
  }

  name_prefix = var.name_prefix == null ? format("%s-%s%s", var.context.project, local.region_alias, local.env_alias) : var.name_prefix

  tags = merge(var.additional_tags, local.local_tags)

  # AWS Regions code and alias table.
  aws_region_codes = {
    ap-east-1      = "ae1",
    ap-northeast-1 = "an1",
    ap-northeast-2 = "an2",
    ap-northeast-3 = "an3",
    ap-southeast-1 = "as1",
    ap-southeast-2 = "as2",
    ca-central-1   = "cc1",
    cn-north-1     = "cn1",
    cn-northwest-1 = "cnw1",
    eu-central-1   = "ec1",
    eu-north-1     = "en1",
    eu-south-1     = "es1",
    eu-west-1      = "ew1",
    eu-west-2      = "ew2",
    eu-west-3      = "ew3",
    me-south-1     = "ms1",
    sa-east-1      = "se1",
    us-east-1      = "ue1",
    us-east-2      = "ue2",
    us-west-1      = "uw1",
    us-west-2      = "uw2",
  }
}

output "context" {
  value = {
    aws_profile  = var.context.aws_profile
    region       = var.context.region
    region_alias = local.region_alias
    project      = var.context.project
    environment  = var.context.environment
    env_alias    = local.env_alias
    owner        = var.context.owner
    team         = var.context.team
    cost_center  = var.context.cost_center
    domain       = var.context.domain
    pri_domain   = var.context.pri_domain
    name_prefix  = local.name_prefix
    tags         = local.tags
    eks_name     = var.context.project
  }
}

output "context_string" {
  value = join(",", [for key, value in var.context : "${key}=${value}"])
}

output "name_prefix" {
  value = local.name_prefix
}

output "vpc_name" {
  value = format("%s-vpc", local.name_prefix)
}

output "eks_name" {
  value = format("%s-eks", local.name_prefix)
}

output "tags" {
  value = local.tags
}

output "tags_string" {
  value = join(",", [for key, value in local.tags : "${key}=${value}"])
}

output "region" {
  value = var.context.region
}

output "region_alias" {
  value = local.region_alias
}

output "project" {
  value = var.context.project
}

output "environment" {
  value = var.context.environment
}

output "env_alias" {
  value = local.env_alias
}

output "owner" {
  value = var.context.owner
}

output "team" {
  value = var.context.team
}

output "cost_center" {
  value = var.context.cost_center
}

output "domain" {
  value = var.context.domain
}

output "pri_domain" {
  value = var.context.pri_domain
}
