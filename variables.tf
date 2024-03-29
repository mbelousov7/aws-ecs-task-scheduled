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

variable "region" {
  type    = string
  default = "us-east-1"
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

variable "ecs_cluster_new" {
  type        = bool
  description = <<-EOT
      optionally set to false, then no new ecs cluster will be created
    EOT
  default     = true
}

variable "ecs_cluster_arn" {
  type        = string
  description = <<-EOT
      provide value if ecs_cluster_new == false
    EOT
  default     = null
}

variable "aws_ecs_cluster_containerInsights" {
  type        = string
  description = "option to enabled | disabled CloudWatch Container Insights for a cluster"
  default     = "enabled"
}

variable "scheduled_iam_role_name" {
  description = <<-EOT
      optionally define a custom value for the iam role name and tag=Name parameter
      in aws_iam_role. By default, it is defined as a construction from var.labels
    EOT
  default     = "default"
}


########################################  configs ########################################

variable "event_target_enabled" {
  type        = bool
  description = "using for disaster recovery design if we don't need to have second running task in parallel"
  default     = true
}

variable "launch_type" {
  type        = string
  description = "The launch type on which to run your service. Valid values are `EC2` and `FARGATE`"
  default     = "FARGATE"
}

variable "task_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs used in Service `network_configuration`"
  default     = null
}

variable "task_definition_arn" {
  type        = string
  description = "Task definition arn"
}
variable "task_role_arn" {
  type        = string
  description = "Task role arn"
}

variable "task_security_group_ids" {
  description = "Security group IDs to allow in Service `network_configuration`"
  type        = list(string)
  default     = []
}

variable "task_desired_count" {
  type        = number
  description = "Number of instances of the task definition to place and keep running."
  default     = 1
}



/*variable "task_config" {
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
*/

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

