output "aws_ecs_cluster_name" {
  value       = local.ecs_cluster_name
  description = "ecs cluster name"
}

output "aws_ecs_cluster_arn" {
  value       = local.ecs_cluster_arn
  description = "ecs cluster arn"
}