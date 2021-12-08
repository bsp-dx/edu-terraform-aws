variable "name" {
  description = "Name of launch template to be created"
  type        = string
}

variable "description" {
  description = "(LT) Description of the launch template"
  type        = string
  default     = null
}

## Instance
variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}

variable "create_iam_instance_profile" {
  description = "Whether to create iam_instance_profile or not. default is false."
  type        = bool
  default     = false
}


variable "iam_instance_profile_name" {
  description = "The name attribute of the IAM instance profile to associate with launched instances"
  type        = string
  default     = null
}

variable "iam_instance_profile_arn" {
  description = "(LT) The IAM Instance Profile ARN to launch the instance with"
  type        = string
  default     = null
}

variable "image_id" {
  description = "The AMI from which to launch the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of the instance to launch"
  type        = string
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "The Base64-encoded user data to provide when launching the instance. You should use this for Launch Templates instead user_data"
  type        = string
  default     = null
}

variable "security_groups" {
  description = "A list of security group IDs to associate"
  type        = list(string)
  default     = null
}

variable "default_version" {
  description = "(LT) Default Version of the launch template"
  type        = string
  default     = null
}

variable "disable_api_termination" {
  description = "(LT) If true, enables EC2 instance termination protection"
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "(LT) Shutdown behavior for the instance. Can be `stop` or `terminate`. (Default: `stop`)"
  type        = string
  default     = "stop"
}

# if required custom kernels
# see - https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/UserProvidedKernels.html
#variable "kernel_id" {
#  description = "(LT) The kernel ID"
#  type        = string
#  default     = null
#}

# if required custom kernels
# see - https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/UserProvidedKernels.html
#variable "ram_disk_id" {
#  description = "(LT) The ID of the ram disk"
#  type        = string
#  default     = null
#}

variable "block_device_mappings" {
  description = "(LT) Specify volumes to attach to the instance besides the volumes specified by the AMI"
  type        = list(any)
  default     = []
}

variable "capacity_reservation_specification" {
  description = "(LT) Targeting for EC2 capacity reservations"
  type        = any
  default     = null
}

variable "cpu_options" {
  description = "(LT) The CPU options for the instance"
  type        = map(string)
  default     = null
}

variable "credit_specification" {
  description = "(LT) Customize the credit specification of the instance"
  type        = map(string)
  default     = null
}

variable "elastic_gpu_specifications" {
  description = "(LT) The elastic GPU to attach to the instance"
  type        = map(string)
  default     = null
}

variable "elastic_inference_accelerator" {
  description = "(LT) Configuration block containing an Elastic Inference Accelerator to attach to the instance"
  type        = map(string)
  default     = null
}

variable "enclave_options" {
  description = "(LT) Enable Nitro Enclaves on launched instances"
  type        = bool
  default     = null
}

variable "hibernation_options" {
  description = "(LT) The hibernation options for the instance"
  type        = bool
  default     = null
}

# If purchasing of AWS Marketplace EC2
#variable "instance_market_options" {
#  description = "(LT) The market (purchasing) option for the instance"
#  type        = any
#  default     = null
#}

#
#variable "license_specifications" {
#  description = "(LT) A list of license specifications to associate with"
#  type        = map(string)
#  default     = null
#}

variable "metadata_options" {
  description = "Customize the metadata options for the instance"
  type        = map(string)
  default     = null
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring"
  type        = bool
  default     = null
}

variable "network_interfaces" {
  description = "(LT) Customize network interfaces to be attached at instance boot time"
  type        = list(any)
  default     = []
}

variable "placement" {
  description = "(LT) The placement of the instance"
  type        = map(string)
  default     = null
}

variable "instance_tags" {
  description = "(LT) The tags to apply to the resources during launch"
  type        = map(string)
  default     = null
}
