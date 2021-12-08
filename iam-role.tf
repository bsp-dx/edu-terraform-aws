resource "aws_iam_service_linked_role" "autoscaling" {
  count            = var.create_asg && var.create_service_linked_role ? 1 : 0
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix    = format("%s_%s", var.context.project, var.name)
  description      = "Default service linked role enables access to AWS Services and Resources used or managed by Auto Scaling"

  provisioner "local-exec" {
    command = "sleep 10"
  }
}