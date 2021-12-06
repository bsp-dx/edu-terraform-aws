variable "context" {
  description = "Provides standardized naming policy and attribute information for data source reference to define cloud resources for a Project."
  type = object({
    region       = string
    region_alias = string
    project      = string
    environment  = string
    env_alias    = string
    owner        = string
    team         = string
    cost_center  = number
    name_prefix  = string
    tags         = map(string)
  })
}