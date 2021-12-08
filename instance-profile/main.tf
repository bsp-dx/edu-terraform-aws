data "aws_partition" "current" {}

locals {
  aws_partition = data.aws_partition.current.partition

  iam_instance_role_name = format("%s%s", upper( substr(var.iam_instance_role_name, 0, 1 )), substr(var.iam_instance_role_name, 1, length(var.iam_instance_role_name) ) )

}

resource "aws_iam_role" "this" {
  count = var.create_iam_instance_profile ? 1 : 0

  name               = local.iam_instance_role_name
  # name               = var.iam_instance_role_name
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

  tags = merge(var.tags, { Name = var.iam_instance_role_name })
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_iam_instance_profile ? 1 : 0
  name  = var.iam_instance_profile_name
  role  = try(aws_iam_role.this[0].name, "")
  tags  = merge(var.tags, { Name = var.create_iam_instance_profile })
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  count      = var.create_iam_instance_profile ? 1 : 0
  role       = try(aws_iam_role.this[0].id, "")
  policy_arn = "arn:${local.aws_partition}:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "amazon_ssm_managed_instance_core" {
  count      = var.create_iam_instance_profile ? 1 : 0
  role       = try(aws_iam_role.this[0].id, "")
  policy_arn = "arn:${local.aws_partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  count      = var.create_iam_instance_profile ? 1 : 0
  role       = try(aws_iam_role.this[0].id, "")
  policy_arn = "arn:${local.aws_partition}:iam::aws:policy/CloudWatchLogsFullAccess"
}