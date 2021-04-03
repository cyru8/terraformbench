output "Feranmi_arn" {
    value = aws_iam_user.loopdemo[0].arn
    description = "The ARN for user Feranmi"
}

output "all_arn" {
    value = aws_iam_user.loopdemo[*].arn
    description = "The ARN for all Users"
}