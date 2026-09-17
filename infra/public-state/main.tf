# Terraform State 저장용 S3 버킷
resource "aws_s3_bucket" "terraform_state" {
  bucket = "bipa17-std01-ex8-terraform-state"
}


# S3 버킷 버전 관리 활성화
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}


# Terraform Lock용 DynamoDB Table
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "bipa17-std01-ex8-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
