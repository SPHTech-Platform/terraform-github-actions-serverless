
data "aws_iam_policy_document" "cf_execution" {
  statement {
    sid = "DeployLambda"

    actions = [
      "lambda:Get*",
      "lambda:List*",
      "lambda:CreateFunction",
      "lambda:DeleteFunction",
      "lambda:CreateFunction",
      "lambda:DeleteFunction",
      "lambda:UpdateFunctionConfiguration",
      "lambda:UpdateFunctionCode",
      "lambda:PublishVersion",
      "lambda:CreateAlias",
      "lambda:DeleteAlias",
      "lambda:UpdateAlias",
      "lambda:AddPermission",
      "lambda:RemovePermission",
      "lambda:InvokeFunction",
      "lambda:TagResource",
      "lambda:UnTagResource",
    ]

    resources = ["arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.prefix}*"]
  }

  statement {
    sid = "DeployLogGroups"

    actions = [
      "logs:CreateLogGroup",
      "logs:Get*",
      "logs:Describe*",
      "logs:List*",
      "logs:DeleteLogGroup",
      "logs:PutResourcePolicy",
      "logs:DeleteResourcePolicy",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy",
      "logs:TagLogGroup",
      "logs:UntagLogGroup",
      "logs:Put*",
    ]

    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.prefix}*"]
  }

  statement {
    sid = "ReadLogGroup"

    actions = [
      "logs:Describe*",
    ]

    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"]
  }

  statement {
    sid = "LogDelivery"

    actions = [
      "logs:CreateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups",
    ]

    resources = ["*"]
  }

  statement {
    sid = "DeployLambdaExecutionRoles"

    actions = [
      "iam:Get*",
      "iam:List*",
      "iam:PassRole",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:AttachRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:PutRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:DetachRolePolicy",
    ]

    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.prefix}*"]
  }

  statement {
    sid = "DescribeEC2"

    actions = [
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs"
    ]

    resources = ["*"]
  }

  statement {
    sid = "ManageSlsDeploymentBucket"

    actions = [
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:PutBucketAcl",
      "s3:GetEncryptionConfiguration",
      "s3:PutEncryptionConfiguration",
    ]

    resources = ["arn:aws:s3:::${var.prefix}*"]
  }

}

data "aws_iam_policy_document" "cf_execution_concat" {
  source_policy_documents = concat([
    data.aws_iam_policy_document.cf_execution.json,
  ], var.additional_execution_role)
}

module "cf_execution_role_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = ">= 5.3.0"

  create_policy = true

  name        = format("%s%s", substr(local.iam_role_name_prefix, 0, 52), "-execution")
  path        = "/"
  description = "cf-execution IAM Policy"
  policy      = data.aws_iam_policy_document.cf_execution_concat.json
}

module "cf_execution_assume_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = ">= 5.3.0"

  create_role = true

  trusted_role_services = [
    "cloudformation.amazonaws.com",
  ]

  role_name = "${local.iam_role_name_prefix}-execution-iam-role"

  role_requires_mfa = false

  custom_role_policy_arns = [
    module.cf_execution_role_policy.arn,
  ]

}
