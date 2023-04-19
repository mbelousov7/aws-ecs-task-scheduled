locals {

  scheduled_iam_role_name = var.scheduled_iam_role_name == "default" ? (
    "${var.labels.prefix}-${var.labels.stack}-${var.labels.component}-event-${var.labels.env}"
  ) : var.scheduled_iam_role_name

}

# IAM role that the Amazon ECS container agent and the Docker daemon can assume
data "aws_iam_policy_document" "scheduled_iam" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "scheduled_iam_role" {
  name                 = local.scheduled_iam_role_name
  assume_role_policy   = join("", data.aws_iam_policy_document.scheduled_iam.*.json)
  permissions_boundary = var.permissions_boundary == "" ? null : var.permissions_boundary
  tags = merge(
    var.labels,
    var.tags,
    { Name = local.scheduled_iam_role_name }
  )
}


resource "aws_iam_role_policy" "scheduled_iam_role_policies" {
  name = "${local.scheduled_iam_role_name}-policies"
  role = aws_iam_role.scheduled_iam_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:PassRole",
        ]
        Effect   = "Allow"
        Resource = "${var.task_role_arn}"
      },
      {
        Action = [
          "ecs:RunTask",
        ]
        Effect   = "Allow"
        Resource = "${var.task_definition_arn}"
      },
    ]
  })
}



resource "aws_iam_role_policy_attachment" "scheduled_iam_role_default" {
  for_each   = toset(var.scheduled_role_policy_arns_default)
  role       = aws_iam_role.scheduled_iam_role.name
  policy_arn = each.key
}

resource "aws_iam_role_policy_attachment" "scheduled_iam_role" {
  for_each   = toset(var.scheduled_role_policy_arns)
  role       = aws_iam_role.scheduled_iam_role.name
  policy_arn = each.key
}