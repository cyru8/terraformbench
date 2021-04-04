terraform {
  required_version = ">= 0.12.26"
}

provider "aws" {
  region = "us-east-2"
}

#---------
# Create the S3 Bucket
#---------
resource "aws_s3_bucket" "cyru8_s3_state" {
    # TODO: S3 bucket names must be *globally* unique.
    bucket = "terraform-up-andrunning-state"

    versioning {
      enabled = true
    }

    # Enable server-side encryption by default 
    server_side_encryption_configuration {
      rule {
          apply_server_side_encryption_by_default {
              sse_algorithm = "AES256"
        }
      }
    }
}

#------
# Create the Dynamodb Table
#------

resource "aws_dynamodb_table" "cyru8_s3_locks" {
    name = "terraform-up-and-running-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
}