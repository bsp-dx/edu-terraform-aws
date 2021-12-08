variable "create_iam_instance_profile" {
  description = "Whether to create iam_instance_profile or not."
  type        = bool
}

variable "iam_instance_role_name" {
  description = "The name attribute of the IAM instance role to associate with launched instances"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "The name attribute of the IAM instance profile to associate with launched instances"
  type        = string
}

variable "tags" {
  description = "The name attribute of the IAM instance profile to associate with launched instances"
  type        = map(string)
}