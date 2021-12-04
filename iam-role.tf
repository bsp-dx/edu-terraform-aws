resource "aws_iam_service_linked_role" "autoscaling" {
  count            = var.create_asg && var.create_schedule && var.service_linked_role_arn == null ? 1 : 0
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix    = var.context.project
  description      = "Default service linked role enables access to AWS Services and Resources used or managed by Auto Scaling"
}