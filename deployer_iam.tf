data "aws_iam_policy_document" "deployer" {
  statement {
    sid = "DelegateToCF"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      module.cf_execution_assume_role.iam_role_arn,
    ]
  }

  statement {
    sid = "ValidateCF"

    actions = [
      "cloudformation:ValidateTemplate",
    ]

    resources = ["*"]
  }

  statement {
    sid = "ExecuteCF"

    actions = [
      "cloudformation:CreateChangeSet",
      "cloudformation:CreateStack",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeChangeSet",
      "cloudformation:DescribeStackEvents",
      "cloudformation:DescribeStackResource",
      "cloudformation:DescribeStackResources",
      "cloudformation:DescribeStacks",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:ListStackResources",
      "cloudformation:SetStackPolicy",
      "cloudformation:UpdateStack",
      "cloudformation:UpdateTerminationProtection",
      "cloudformation:GetTemplate",
    ]

    resources = ["arn:aws:cloudformation:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stack/${var.prefix}*/*"]
  }

  statement {
    sid = "ReadLambda"

    actions = [
      "lambda:Get*",
      "lambda:List*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "DeleteLambdaVersion"

    actions = [
      "lambda:DeleteFunction",
    ]

    resources = ["arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.prefix}*"]
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

data "aws_iam_policy_document" "deployer_concat" {
  source_policy_documents = concat([
    data.aws_iam_policy_document.deployer.json,
  ], var.additional_deployer_role)
}

module "deployer_role_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = ">= 5.3.0"

  create_policy = true

  name        = format("%s%s", substr(local.iam_role_name_prefix, 0, 52), "-deployer")
  path        = "/"
  description = "deployer IAM Policy"
  policy      = data.aws_iam_policy_document.deployer_concat.json
}
