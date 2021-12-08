variable "context" {
  description = "Provides standardized naming policy and attribute information for data source reference to define cloud resources for a Project."
  type        = object({
    project     = string # project name
    name_prefix = string # resource name prefix
    tags        = map(string)
  })
}
