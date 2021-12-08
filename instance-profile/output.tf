output "instance_role_id" {
  description = "The ID of EC2 instance role"
  value       = concat(aws_iam_role.this.*.id, [""])[0]
}

output "instance_role_arn" {
  description = "The ARN of EC2 instance role"
  value       = concat(aws_iam_role.this.*.arn, [""])[0]
}

output "instance_profile_name" {
  description = "The name of EC2 instance profile"
  value       = concat(aws_iam_instance_profile.this.*.name, [""])[0]
}

output "instance_profile_arn" {
  description = "The ARN of EC2 instance profile"
  value       = concat(aws_iam_instance_profile.this.*.arn, [""])[0]
}