Terraform module to create AWS ECS scheduled task .

terrafrom config example:

```
module "ecs_task_security_group" {
  source        = "git::https://github.com/mbelousov7/aws-security-group.git?ref=v1.0.0"
  vpc_id        = var.vpc_id
  ingress_rules = var.security_group.ingress_rules
  egress_rules  = var.security_group.egress_rules
  labels        = local.labels
}

module "ecs_task_definition" {
  source                      = "git::https://github.com/mbelousov7/aws-ecs-task-definition.git?ref=v1.0.0"
  aws_region                  = var.region
  container_name              = var.container_name
  container_image             = var.container_image
  task_cpu                    = var.task_cpu
  task_memory                 = var.task_memory
  task_role_policy_arns       = local.cloudteam_policy_arns
  task_role_policy_statements = var.task_role_policy_statements
  labels                      = local.labels
}


module "ecs_task_scheduled" {
  source                  = "../.."
  task_role_arn           = module.ecs_task_definition.task_role_arn
  task_definition_arn     = module.ecs_task_definition.task_definition_arn
  task_security_group_ids = [module.ecs_task_security_group.id]
  task_subnet_ids         = var.subnet_ids

  event_schedule_expression  = "rate(5 minutes)"
  scheduled_role_policy_arns = local.cloudteam_policy_arns
  labels                     = local.labels
}


```
more info see [examples/test](examples/test)


terraform run example
```
cd examples/test
terraform init
terraform plan
``` 

Terraform versions tested
- 0.15.3
- 1.1.8

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.scheduled_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.scheduled_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_iam_role.scheduled_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.scheduled_iam_role_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.scheduled_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.scheduled_iam_role_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.scheduled_iam](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_ecs_cluster_containerInsights"></a> [aws\_ecs\_cluster\_containerInsights](#input\_aws\_ecs\_cluster\_containerInsights) | option to enabled \| disabled CloudWatch Container Insights for a cluster | `string` | `"enabled"` | no |
| <a name="input_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#input\_ecs\_cluster\_arn) | provide value if ecs\_cluster\_new == false | `string` | `null` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | optionally define a custom value for the ecs cluster name and tag=Name parameter<br>in aws\_ecs\_cluster. By default, it is defined as a construction from var.labels | `string` | `"default"` | no |
| <a name="input_ecs_cluster_new"></a> [ecs\_cluster\_new](#input\_ecs\_cluster\_new) | optionally set to false, then no new ecs cluster will be created | `bool` | `true` | no |
| <a name="input_event_name"></a> [event\_name](#input\_event\_name) | optionally define a custom value for the event name and tag=Name parameter<br>in aws\_ecs\_task\_definition. By default, it is defined as a construction from var.labels | `string` | `"default"` | no |
| <a name="input_event_schedule_expression"></a> [event\_schedule\_expression](#input\_event\_schedule\_expression) | value for schedule\_expression parameter in aws\_cloudwatch\_event\_rule | `string` | `"rate(5 minutes)"` | no |
| <a name="input_event_target_enabled"></a> [event\_target\_enabled](#input\_event\_target\_enabled) | using for disaster recovery design if we don't need to have second running task in parallel | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Minimum required map of labels(tags) for creating aws resources | <pre>object({<br>    prefix    = string<br>    stack     = string<br>    component = string<br>    env       = string<br>  })</pre> | n/a | yes |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | The launch type on which to run your service. Valid values are `EC2` and `FARGATE` | `string` | `"FARGATE"` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | A permissions boundary ARN to apply to the roles that are created. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_scheduled_iam_role_name"></a> [scheduled\_iam\_role\_name](#input\_scheduled\_iam\_role\_name) | optionally define a custom value for the iam role name and tag=Name parameter<br>in aws\_iam\_role. By default, it is defined as a construction from var.labels | `string` | `"default"` | no |
| <a name="input_scheduled_role_policy_arns"></a> [scheduled\_role\_policy\_arns](#input\_scheduled\_role\_policy\_arns) | A list of IAM Policy ARNs to attach to the generated task role. | `list(string)` | `[]` | no |
| <a name="input_scheduled_role_policy_arns_default"></a> [scheduled\_role\_policy\_arns\_default](#input\_scheduled\_role\_policy\_arns\_default) | default arns list for scheduling task | `list` | <pre>[<br>  "arn:aws:iam::aws:policy/service-role/CloudWatchEventsBuiltInTargetExecutionAccess",<br>  "arn:aws:iam::aws:policy/service-role/CloudWatchEventsInvocationAccess"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags | `map(string)` | `{}` | no |
| <a name="input_task_definition_arn"></a> [task\_definition\_arn](#input\_task\_definition\_arn) | Task definition arn | `string` | n/a | yes |
| <a name="input_task_desired_count"></a> [task\_desired\_count](#input\_task\_desired\_count) | Number of instances of the task definition to place and keep running. | `number` | `1` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | Task role arn | `string` | n/a | yes |
| <a name="input_task_security_group_ids"></a> [task\_security\_group\_ids](#input\_task\_security\_group\_ids) | Security group IDs to allow in Service `network_configuration` | `list(string)` | `[]` | no |
| <a name="input_task_subnet_ids"></a> [task\_subnet\_ids](#input\_task\_subnet\_ids) | Subnet IDs used in Service `network_configuration` | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_ecs_cluster_arn"></a> [aws\_ecs\_cluster\_arn](#output\_aws\_ecs\_cluster\_arn) | ecs cluster arn |
| <a name="output_aws_ecs_cluster_name"></a> [aws\_ecs\_cluster\_name](#output\_aws\_ecs\_cluster\_name) | ecs cluster name |
<!-- END_TF_DOCS -->