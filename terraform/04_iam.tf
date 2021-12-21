# IAM Role so that ECS tasks have the correct permission to execute
# The policy allows the Amazon ECS and EC2 services to assume the role
resource "aws_iam_role" "ecs-task-exec" {
  name               = "ecs_task_execution_role"
  assume_role_policy = file("policies/ecs-role.json")
}

resource "aws_iam_role_policy" "ecs-task-exec" {
  name   = "ecs_instance_role_policy"
  policy = file("policies/ecs-task-role-policy.json")
  role   = aws_iam_role.ecs-task-exec.id
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs_instance_profile_prod"
  path = "/"
  role = aws_iam_role.ecs-task-exec.name
}

# resource "aws_iam_role" "ecs-service" {
#   name               = "ecs_service_role"
#   assume_role_policy = file("policies/ecs-role.json")
# }

# resource "aws_iam_role_policy" "ecs-service-role-policy" {
#   name   = "ecs_service_role_policy"
#   policy = file("policies/ecs-service-role-policy.json")
#   role   = aws_iam_role.ecs-service-role.id
# }
