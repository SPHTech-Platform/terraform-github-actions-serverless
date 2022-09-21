# Github Actions Serverless Deployer
Terraform module that will create the resources for deploying serverless framework using github actions.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cf_execution_assume_role"></a> [cf\_execution\_assume\_role](#module\_cf\_execution\_assume\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | >= 5.3.0 |
| <a name="module_cf_execution_role_policy"></a> [cf\_execution\_role\_policy](#module\_cf\_execution\_role\_policy) | terraform-aws-modules/iam/aws//modules/iam-policy | >= 5.3.0 |
| <a name="module_deployer_role_policy"></a> [deployer\_role\_policy](#module\_deployer\_role\_policy) | terraform-aws-modules/iam/aws//modules/iam-policy | >= 5.3.0 |
| <a name="module_github_actions_repo"></a> [github\_actions\_repo](#module\_github\_actions\_repo) | philips-labs/github-oidc/aws | >= 0.3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.cf_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cf_execution_concat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deployer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deployer_concat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_deployer_role"></a> [additional\_deployer\_role](#input\_additional\_deployer\_role) | (Optional) Additional Deployer Policy Role | `list(any)` | `[]` | no |
| <a name="input_additional_execution_role"></a> [additional\_execution\_role](#input\_additional\_execution\_role) | (Optional) Additional Execution Policy Role | `list(any)` | `[]` | no |
| <a name="input_github_branches"></a> [github\_branches](#input\_github\_branches) | List of github branches allowed for oidc subject claims. | `list(string)` | `[]` | no |
| <a name="input_github_environments"></a> [github\_environments](#input\_github\_environments) | (Optional) Allow GitHub action to deploy to all (default) or to one of the environments in the list. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | GitHub repository to grant access to assume a role via OIDC. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | (Optional) project prefix | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | (Optional) role name of the created role, if not provided the github\_repo will be used to generate. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cf_execution_role_arn"></a> [cf\_execution\_role\_arn](#output\_cf\_execution\_role\_arn) | Cloudformation Execution Role that will be used by serverless |
<!-- END_TF_DOCS -->
