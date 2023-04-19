locals {

  event_name = var.event_name == "default" ? (
    "${var.labels.prefix}-${var.labels.stack}-${var.labels.component}-event-${var.labels.env}"
  ) : var.event_name

  ecs_cluster_name = var.ecs_cluster_name == "default" ? (
    "${var.labels.prefix}-${var.labels.stack}-${var.labels.component}-cl-${var.region}-${var.labels.env}"
  ) : var.ecs_cluster_name

  ecs_cluster_arn = var.ecs_cluster_new == true ? join("", aws_ecs_cluster.ecs_cluster.*.arn) : var.ecs_cluster_arn

}

resource "aws_cloudwatch_event_rule" "scheduled_task" {
  name                = local.event_name
  description         = "Runs Fargate task ${local.event_name}"
  schedule_expression = var.event_schedule_expression
}

resource "aws_ecs_cluster" "ecs_cluster" {
  count = var.ecs_cluster_new == true ? 1 : 0
  name  = local.ecs_cluster_name
  setting {
    name  = "containerInsights"
    value = var.aws_ecs_cluster_containerInsights
  }
  tags = merge(
    var.labels,
    var.tags,
    { Name = local.ecs_cluster_name }
  )
}

resource "aws_cloudwatch_event_target" "scheduled_task" {
  count     = var.event_target_enabled == true ? 1 : 0
  rule      = aws_cloudwatch_event_rule.scheduled_task.name
  target_id = local.event_name
  arn       = local.ecs_cluster_arn
  role_arn  = aws_iam_role.scheduled_iam_role.arn
  input     = "{}"

  ecs_target {
    task_count          = var.task_desired_count
    task_definition_arn = var.task_definition_arn
    launch_type         = var.launch_type
    platform_version    = "LATEST"

    network_configuration {
      assign_public_ip = false
      security_groups  = var.task_security_group_ids
      subnets          = var.task_subnet_ids
    }
  }
}

