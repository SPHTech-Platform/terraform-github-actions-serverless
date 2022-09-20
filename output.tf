output "cf_execution_role_arn" {
  description = "Cloudformation Execution Role that will be used by serverless"
  value       = module.cf_execution_assume_role.iam_role_arn
}

output "deployer_role_arn" {
  description = "Deployer Role that Github Actions will assume"
  value       = module.github_actions_repo.role
}
