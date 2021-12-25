# Role assumed by the ECS service
resource "aws_iam_role" "ecs_service" {
  name               = "ecs_service_role"
  assume_role_policy = file("policies/ecs-role.json")
  tags               = var.tags
}

resource "aws_iam_role_policy" "ecs_service" {
  name   = "ecs_service_role_policy"
  policy = file("policies/ecs-service-role-policy.json")
  role   = aws_iam_role.ecs_service.id
}

# Role associated to launched EC2 instances
resource "aws_iam_role" "ecs_instance" {
  name               = "ecs_instance_role"
  assume_role_policy = file("policies/ecs-role.json")
  tags               = var.tags
}

resource "aws_iam_role_policy" "ecs_instance" {
  name   = "ecs_instance_role_policy"
  policy = file("policies/ecs-instance-role-policy.json")
  role   = aws_iam_role.ecs_instance.id
}

# IAM instance profile to associate with launched instances
# Use an instance profile to pass an IAM role to an EC2 instance
resource "aws_iam_instance_profile" "ecs_instance" {
  name = "ecs_instance_profile"
  path = "/"
  role = aws_iam_role.ecs_instance.name
  tags = var.tags
}

# Role to grant autoscaling permissions to the Amazon autoscaling application
resource "aws_iam_role" "ecs_autoscaling" {
  name               = "ecs-autoscaling-application"
  assume_role_policy = file("policies/ecs-autoscaling-role.json")
  tags               = var.tags
}

resource "aws_iam_role_policy" "ecs_autoscaling" {
  name   = "ecs_service_scaling_role_policy"
  policy = file("policies/ecs-autoscaling-role-policy.json")
  role   = aws_iam_role.ecs_autoscaling.id
}
