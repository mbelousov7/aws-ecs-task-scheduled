# Changelog

Make sure to update this file for each merge into *develop*, otherwise the build fails.

The build relies on the latest version in this file.

Latest versions must be at the top!

## [1.1.0] - 2023-04-19

- rename input vars

## [1.0.4] - 2022-12-02

- add aws region in ecs cluster name

## [1.0.3] - 2022-09-08

- add ecs_cluster_new varible and crating cluster logic

## [1.0.2] - 2022-09-01

- add var launch_type - "The launch type on which to run your service. Valid values are `EC2` and `FARGATE`"
- add var task_count - "Number of instances of the task definition to place and keep running."
- add var event_target_enabled - "using for disaster recovery design if we don't need to have second running task in parallel"

## [1.0.1] - 2022-04-26

- fix: rm task_iam_role_logging

## [1.0.0] - 2022-04-12

- add tf module, example, readme, gitlab-ci
