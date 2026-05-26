output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "arn" {
  description = "ARN of the Lambda alias"
  value       = try(aws_lambda_alias.this[0].arn, null)
}

output "invoke_arn" {
  description = "Invoke ARN of the Lambda alias"
  value       = try(aws_lambda_alias.this[0].invoke_arn, null)
}
