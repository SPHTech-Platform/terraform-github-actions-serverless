locals {
  iam_role_name_prefix = replace(var.github_repo, "/", "-")
}

module "github_actions_repo" {
  source  = "philips-labs/github-oidc/aws"
  version = ">= 0.3.0"

  openid_connect_provider_arn = data.aws_iam_openid_connect_provider.github.arn
  repo                        = var.github_repo
  role_name                   = var.role_name
  default_conditions          = ["allow_environment", "allow_main"]
  github_environments         = var.github_environments

  conditions = (var.github_branches != []) ? [
    {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for branch in var.github_branches : "repo:${var.github_repo}:ref:refs/heads/${branch}"]
    },
  ] : []

  role_policy_arns = [
    module.deployer_role_policy.arn,
  ]
}
