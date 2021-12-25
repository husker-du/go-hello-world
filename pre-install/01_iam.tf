resource "aws_iam_user" "prog_user" {
  name = var.username
  path = "/"
}

resource "aws_iam_access_key" "prog_user" {
  user = aws_iam_user.prog_user.name
}

resource "aws_iam_user_policy_attachment" "ec2-full-access-user-policy-attach" {
  user       = aws_iam_user.prog_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_user_policy_attachment" "iam-full-access-user-policy-attach" {
  user       = aws_iam_user.prog_user.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_user_policy_attachment" "ecr-full-access-user-policy-attach" {
  user       = aws_iam_user.prog_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_user_policy_attachment" "s3-full-access-user-policy-attach" {
  user       = aws_iam_user.prog_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user_policy_attachment" "dynamodb-full-access-user-policy-attach" {
  user       = aws_iam_user.prog_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_user_policy_attachment" "ecs-full-access-user-policy-attach" {
  user       = aws_iam_user.prog_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
