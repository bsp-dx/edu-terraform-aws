data "aws_partition" "current" {}

locals {
  ec2_instance_role_name    = "${var.context.project}EC2InstanceRole"
  ec2_instance_profile_name = "${var.context.project}EC2InstanceProfile"
  aws_partition             = data.aws_partition.current.partition
}

resource "aws_iam_role" "this" {
  count = local.create_lt && var.create_iam_instance_profile ? 1 : 0

  name               = local.ec2_instance_role_name
  path               = "/"
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

  tags = merge(var.context.tags, { Name = local.ec2_instance_profile_name })
}

resource "aws_iam_instance_profile" "this" {
  count = local.create_lt && var.create_iam_instance_profile ? 1 : 0
  name  = local.ec2_instance_profile_name
  role  = try(aws_iam_role.this[0].name, "")
  tags  = merge(var.context.tags, { Name = local.ec2_instance_profile_name })
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  count      = local.create_lt && var.create_iam_instance_profile ? 1 : 0
  role       = try(aws_iam_role.this[0].id, "")
  policy_arn = "arn:${local.aws_partition}:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "amazon_ssm_managed_instance_core" {
  count      = local.create_lt && var.create_iam_instance_profile ? 1 : 0
  role       = try(aws_iam_role.this[0].id, "")
  policy_arn = "arn:${local.aws_partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  count      = local.create_lt && var.create_iam_instance_profile ? 1 : 0
  role       = try(aws_iam_role.this[0].id, "")
  policy_arn = "arn:${local.aws_partition}:iam::aws:policy/CloudWatchLogsFullAccess"
}