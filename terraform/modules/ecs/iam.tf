# Role assumed by the ECS service
resource "aws_iam_role" "ecs_service" {
  name               = "ecs-service-role-${terraform.workspace}"
  assume_role_policy = file("${path.module}/policies/ecs-service-role.json")
  tags               = var.config.tags
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
  role       = aws_iam_role.ecs_service.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# Role associated to launched EC2 instances
resource "aws_iam_role" "ecs_instance" {
  name               = "ecs-instance-role-${terraform.workspace}"
  assume_role_policy = file("${path.module}/policies/ecs-instance-role.json")
  tags               = var.config.tags
}

resource "aws_iam_role_policy_attachment" "ecs_instance" {
  role       = aws_iam_role.ecs_instance.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# IAM instance profile to associate with launched instances
# Use an instance profile to pass an IAM role to an EC2 instance
resource "aws_iam_instance_profile" "ecs_instance" {
  name = "ecs-instance-profile-${terraform.workspace}"
  path = "/"
  role = aws_iam_role.ecs_instance.name
  tags = var.config.tags
}
