output "cf_execution_role_arn" {
  description = "Cloudformation Execution Role that will be used by serverless"
  value       = module.cf_execution_assume_role.iam_role_arn
}
