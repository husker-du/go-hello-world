resource "aws_iam_user" "programmatic_user" {
  name = var.programmatic_username
  path = "/"
}

resource "aws_iam_access_key" "programmatic_user" {
  user = aws_iam_user.programmatic_user.name
}

resource "aws_iam_user_policy_attachment" "ec2_full_access_user_policy_attach" {
  user       = aws_iam_user.programmatic_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_user_policy_attachment" "iam_full_access_user_policy_attach" {
  user       = aws_iam_user.programmatic_user.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_user_policy_attachment" "ecr_full_access_user_policy_attach" {
  user       = aws_iam_user.programmatic_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_user_policy_attachment" "s3_full_access_user_policy_attach" {
  user       = aws_iam_user.programmatic_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user_policy_attachment" "dynamodb_full_access_user_policy_attach" {
  user       = aws_iam_user.programmatic_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_user_policy_attachment" "ecs_full_access_user_policy_attach" {
  user       = aws_iam_user.programmatic_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
