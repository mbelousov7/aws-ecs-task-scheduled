Terraform module to create AWS ECS scheduled task .

terrafrom config example:

```
module "ecs_task_security_group" {
  source        = "git::https://github.com/mbelousov7/aws-security-group.git?ref=main"
  vpc_id        = var.vpc_config.vpc_id
  ingress_rules = var.security_group.ingress_rules
  egress_rules  = var.security_group.egress_rules
  labels        = local.labels
}

module "ecs_task_definition" {
  source                      = "git::https://github.com/mbelousov7/aws-ecs-task-definition.git?ref=main"
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
  source = "../.."
  task_config = {
    task_role_arn          = module.ecs_task_definition.task_role_arn
    task_definition_arn    = module.ecs_task_definition.task_definition_arn
    task_security_group_id = module.ecs_task_security_group.id
  }

  vpc_config                 = var.vpc_config
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.scheduled_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.scheduled_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_iam_role.scheduled_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.scheduled_iam_role_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.scheduled_iam_role_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.scheduled_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.scheduled_iam_role_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.scheduled_iam](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_cloudwatch_log_group_arn"></a> [aws\_cloudwatch\_log\_group\_arn](#input\_aws\_cloudwatch\_log\_group\_arn) | aws cloudwatch log group arn for task logs, used in aws\_iam\_role\_policy | `string` | n/a | yes |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | optionally define a custom value for the ecs cluster name and tag=Name parameter<br>in aws\_ecs\_cluster. By default, it is defined as a construction from var.labels | `string` | `"default"` | no |
| <a name="input_event_name"></a> [event\_name](#input\_event\_name) | optionally define a custom value for the event name and tag=Name parameter<br>in aws\_ecs\_task\_definition. By default, it is defined as a construction from var.labels | `string` | `"default"` | no |
| <a name="input_event_schedule_expression"></a> [event\_schedule\_expression](#input\_event\_schedule\_expression) | value for schedule\_expression parameter in aws\_cloudwatch\_event\_rule | `string` | `"rate(5 minutes)"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Minimum required map of labels(tags) for creating aws resources | <pre>object({<br>    prefix    = string<br>    stack     = string<br>    component = string<br>    env       = string<br>  })</pre> | n/a | yes |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | A permissions boundary ARN to apply to the roles that are created. | `string` | `""` | no |
| <a name="input_scheduled_iam_role_name"></a> [scheduled\_iam\_role\_name](#input\_scheduled\_iam\_role\_name) | optionally define a custom value for the iam role name and tag=Name parameter<br>in aws\_iam\_role. By default, it is defined as a construction from var.labels | `string` | `"default"` | no |
| <a name="input_scheduled_role_policy_arns"></a> [scheduled\_role\_policy\_arns](#input\_scheduled\_role\_policy\_arns) | A list of IAM Policy ARNs to attach to the generated task role. | `list(string)` | `[]` | no |
| <a name="input_scheduled_role_policy_arns_default"></a> [scheduled\_role\_policy\_arns\_default](#input\_scheduled\_role\_policy\_arns\_default) | default arns list for scheduling task | `list` | <pre>[<br>  "arn:aws:iam::aws:policy/service-role/CloudWatchEventsBuiltInTargetExecutionAccess",<br>  "arn:aws:iam::aws:policy/service-role/CloudWatchEventsInvocationAccess"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags | `map(string)` | `{}` | no |
| <a name="input_task_config"></a> [task\_config](#input\_task\_config) | A map of nessesary fargete task config | <pre>object({<br>    task_definition_arn    = string<br>    task_role_arn          = string<br>    task_security_group_id = string<br>  })</pre> | n/a | yes |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | A map of nessesary vpc config | <pre>object({<br>    vpc_id     = string<br>    subnet_ids = list(string)<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->