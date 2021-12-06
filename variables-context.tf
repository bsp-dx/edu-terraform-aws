variable "context" {
  type = object({
    aws_profile  = string
    aws_region   = string
    region_alias = string
    project      = string
    environment  = string
    env_alias    = string
    owner        = string
    team         = string
    cost_center  = number
    name_prefix = string
    tags        = map(string)
  })
}