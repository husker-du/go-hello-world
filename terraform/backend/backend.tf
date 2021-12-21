resource "aws_s3_bucket" "tfstate" {
  bucket = var.bucket-tfstate
  acl    = "private"
}

resource "aws_dynamodb_table" "tfstate-lock" {
  name           = var.lock-dynamo-table
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}