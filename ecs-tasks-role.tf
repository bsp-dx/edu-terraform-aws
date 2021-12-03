locals {
  ecs_task_role_name = "${var.context.project}EcsTaskExecutionRole"
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  count = var.create_ecs ? 1 : 0

  name               = "latency-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = merge(var.context.tags, { Name = local.ecs_task_role_name })
}

data "aws_iam_policy" "ecs_task_execution_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  count = var.create_ecs ? 1 : 0

  role       = concat(aws_iam_role.ecs_task_execution_role.*.arn, [""])[0]
  policy_arn = data.aws_iam_policy.ecs_task_execution_policy.arn
}