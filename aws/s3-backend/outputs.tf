output "s3_bucket_arn" {
    value = aws_s3_bucket.cyru8_s3_state.arn
    description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
    value = aws_dynamodb_table.cyru8_s3_locks.name 
    description = "The name of the DynamodDB table"
}