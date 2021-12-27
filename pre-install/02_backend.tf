resource "aws_s3_bucket" "tfstate" {
  bucket = var.tfstate_bucket_name
  acl    = "private"

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${self.bucket} --recursive"
  }
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name           = var.lock_dynamo_table
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}
