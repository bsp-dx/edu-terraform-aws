variable "create_ecs" {
  description = "Controls if ECS should be created"
  type        = bool
  default     = true
}

variable "middle_name" {
  description = "The middle name of ECS Cluster"
  type        = string
  default     = null
}

variable "capacity_providers" {
  description = "List of short names of one or more capacity providers to associate with the cluster. Valid values also include FARGATE and FARGATE_SPOT."
  type        = list(string)
  default     = []
}

variable "default_capacity_provider_strategy" {
  description = "The capacity provider strategy to use by default for the cluster. Can be one or more."
  type        = list(map(any))
  default     = []
}

variable "container_insights" {
  description = "Controls if ECS Cluster has container insights enabled"
  type        = bool
  default     = false
}

variable "create_ecs_task_execution_role" {
  description = "Whether to create ECS task-execution-role. default is `false`."
  type        = bool
  default     = false
}

variable "create_ec2_instance_role" {
  description = "Whether to create EC2 instance-role and instance profile."
  type        = bool
  default     = true
}
