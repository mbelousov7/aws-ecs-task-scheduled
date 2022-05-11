######################################## names, labels, tags ########################################
variable "labels" {
  type = object({
    prefix    = string
    stack     = string
    component = string
    env       = string
  })
  description = "Minimum required map of labels(tags) for creating aws resources"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}

variable "event_name" {
  type        = string
  description = <<-EOT
      optionally define a custom value for the event name and tag=Name parameter
      in aws_ecs_task_definition. By default, it is defined as a construction from var.labels
    EOT
  default     = "default"
}

variable "ecs_cluster_name" {
  type        = string
  description = <<-EOT
      optionally define a custom value for the ecs cluster name and tag=Name parameter
      in aws_ecs_cluster. By default, it is defined as a construction from var.labels
    EOT
  default     = "default"
}

variable "scheduled_iam_role_name" {
  description = <<-EOT
      optionally define a custom value for the iam role name and tag=Name parameter
      in aws_iam_role. By default, it is defined as a construction from var.labels
    EOT
  default     = "default"
}


########################################  configs ########################################

variable "event_schedule_expression" {
  type        = string
  description = "value for schedule_expression parameter in aws_cloudwatch_event_rule"
  default     = "rate(5 minutes)"
}


variable "permissions_boundary" {
  type        = string
  description = "A permissions boundary ARN to apply to the roles that are created."
  default     = ""
}

variable "scheduled_role_policy_arns_default" {
  description = "default arns list for scheduling task"
  default = [
    "arn:aws:iam::aws:policy/service-role/CloudWatchEventsBuiltInTargetExecutionAccess",
    "arn:aws:iam::aws:policy/service-role/CloudWatchEventsInvocationAccess"
  ]
}

variable "scheduled_role_policy_arns" {
  type        = list(string)
  description = "A list of IAM Policy ARNs to attach to the generated task role."
  default     = []
}

variable "task_config" {
  type = object({
    task_definition_arn    = string
    task_role_arn          = string
    task_security_group_id = string
  })
  description = "A map of nessesary fargete task config"
}

variable "vpc_config" {
  type = object({
    vpc_id     = string
    subnet_ids = list(string)
  })
  description = "A map of nessesary vpc config"
}
