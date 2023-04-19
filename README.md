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
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_cluster) | data source |
| [aws_iam_policy_document.scheduled_iam](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_ecs_cluster_arn"></a> [aws\_ecs\_cluster\_arn](#output\_aws\_ecs\_cluster\_arn) | ecs cluster arn |
| <a name="output_aws_ecs_cluster_name"></a> [aws\_ecs\_cluster\_name](#output\_aws\_ecs\_cluster\_name) | ecs cluster name |
<!-- END_TF_DOCS -->