# Bucket S3 to save the terraform.tfstate file
#
resource "aws_s3_bucket" "tfstate" {
  bucket = var.tfstate_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${self.bucket} --recursive"
  }
}

data "aws_iam_policy_document" "tfstate" {
  statement {
    sid = "GetTfStateBucketElements"

    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.tfstate.arn,
    ]

    principals {
      type        = "AWS"
      identifiers = [ aws_iam_user.programmatic_user.arn ]
    }
  }

  statement {
    sid = "ReadAndWriteTfstateBucketObjects"

    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.tfstate.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [ aws_iam_user.programmatic_user.arn ]
    }    
  }
}

resource "aws_s3_bucket_policy" "tfstate" {  
  bucket = aws_s3_bucket.tfstate.id
  policy = data.aws_iam_policy_document.tfstate.json
}

resource "aws_s3_bucket_public_access_block" "s3Public" {
  bucket = aws_s3_bucket.tfstate.id
  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}


# DynamoDB table to lock access to terraform state bucket
#
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
