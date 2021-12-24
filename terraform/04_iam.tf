# IAM Role so that ECS tasks have the correct permission to execute
# The policy allows the Amazon ECS and EC2 services to assume the role
resource "aws_iam_role" "ecs_task_exec" {
  name               = "ecs_task_execution_role"
  assume_role_policy = file("policies/ecs-role.json")
  tags               = var.tags
}

resource "aws_iam_role_policy" "ecs_task_exec" {
  name   = "ecs_task_role_policy"
  policy = file("policies/ecs-task-role-policy.json")
  role   = aws_iam_role.ecs_task_exec.id
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs_task_profile"
  path = "/"
  role = aws_iam_role.ecs_task_exec.name
  tags = var.tags
}

resource "aws_iam_role" "ecs_service" {
  name               = "ecs_service_role"
  assume_role_policy = file("policies/ecs-role.json")
  tags               = var.tags
}

resource "aws_iam_role_policy" "ecs_service_alb" {
  name   = "ecs_service_alb_role_policy"
  policy = templatefile("policies/ecs-service-alb-role-policy.json.tpl", { alb_arn = aws_lb.alb.arn })
  role   = aws_iam_role.ecs_service.id
}

resource "aws_iam_role_policy" "ecs_service_standard" {
  name   = "ecs_service_standard_role_policy"
  policy = file("policies/ecs-service-standard-role-policy.json")
  role   = aws_iam_role.ecs_service.id
}

resource "aws_iam_role_policy" "ecs_service_scaling" {
  name   = "ecs_service_scaling_role_policy"
  policy = file("policies/ecs-service-scaling-role-policy.json")
  role   = aws_iam_role.ecs_service.id
}
