# Here S3 bucket and DynamoDB table were already configured in AWS

terraform {
  backend "s3" {
    bucket = "terraformbackend-v"
    key = "statefile"
    region = "us-east-1"
    dynamodb_table = "terraformbackend"
  }
}