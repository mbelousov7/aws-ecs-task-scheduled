locals {

  event_name = var.event_name == "default" ? (
    "${var.labels.prefix}-${var.labels.stack}-${var.labels.component}-event-${var.labels.env}"
  ) : var.event_name

  ecs_cluster_name = var.ecs_cluster_name == "default" ? (
    "${var.labels.prefix}-${var.labels.stack}-${var.labels.component}-cl-${var.labels.env}"
  ) : var.ecs_cluster_name

}

resource "aws_cloudwatch_event_rule" "scheduled_task" {
  name                = local.event_name
  description         = "Runs Fargate task ${local.event_name}"
  schedule_expression = var.event_schedule_expression
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.ecs_cluster_name
  tags = merge(
    var.labels,
    var.tags,
    { Name = local.ecs_cluster_name }
  )
}

resource "aws_cloudwatch_event_target" "scheduled_task" {
  rule      = aws_cloudwatch_event_rule.scheduled_task.name
  target_id = local.event_name
  arn       = aws_ecs_cluster.ecs_cluster.arn
  role_arn  = aws_iam_role.scheduled_iam_role.arn
  input     = "{}"

  ecs_target {
    task_count          = 1
    task_definition_arn = var.task_config.task_definition_arn
    launch_type         = "FARGATE"
    platform_version    = "LATEST"

    network_configuration {
      assign_public_ip = false
      security_groups  = [var.task_config.task_security_group_id]
      subnets          = var.vpc_config.subnet_ids
    }
  }
}

