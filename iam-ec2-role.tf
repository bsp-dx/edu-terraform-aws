data "aws_partition" "current" {}

locals {
  middle_name     = var.middle_name == null ? "" : format("-%s%s", upper( substr(var.middle_name, 0, 1 )), substr(var.middle_name, 1 ) )
  iam_name_prefix = format("%s%s", var.context.project, local.middle_name)
}

resource "aws_iam_role" "this" {
  count = var.create_ecs && var.create_ec2_instance_role ? 1 : 0

  name = "${local.iam_name_prefix}EcsInstanceRole"
  path = "/ecs/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = merge(var.context.tags, { Name = "${local.iam_name_prefix}EcsInstanceRole" })

}

resource "aws_iam_instance_profile" "this" {
  count = var.create_ecs && var.create_ec2_instance_role ? 1 : 0

  name = "${local.iam_name_prefix}EcsInstanceProfile"
  role = concat(aws_iam_role.this.*.name, [""])[0]

  tags = merge(var.context.tags, { Name = "${local.iam_name_prefix}EcsInstanceProfile" })
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  count = var.create_ecs && var.create_ec2_instance_role ? 1 : 0

  role       = concat(aws_iam_role.this.*.id, [""])[0]
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "amazon_ssm_managed_instance_core" {
  count = var.create_ecs && var.create_ec2_instance_role ? 1 : 0

  role       = concat(aws_iam_role.this.*.id, [""])[0]
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  count = var.create_ecs && var.create_ec2_instance_role ? 1 : 0

  role       = concat(aws_iam_role.this.*.id, [""])[0]
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/CloudWatchLogsFullAccess"
}