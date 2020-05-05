resource "aws_iam_user" "sandbox_user" {
  name = var.sandbox_user_name
  permissions_boundary = aws_iam_policy.sandbox_user_permissions_boundary.arn
}

resource "aws_iam_policy" "sandbox_user_permissions_boundary" {
  name        = "sandbox_user_permissions_boundary"
  description = "Permissions boundary for sandbox user"
  policy      = data.aws_iam_policy_document.sandbox_user_permissions_boundary_document.json
}

data "aws_iam_policy_document" "sandbox_user_permissions_boundary_document" {
  statement {
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Deny"
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "iam:UpdateAccountPasswordPolicy",
      "iam:DeleteAccountPasswordPolicy",
      "iam:DeleteUserPermissionsBoundary",
      "iam:DeleteRolePermissionsBoundary",
      "s3:PutAccountPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "es:*"
    ]
    resources = [
        "*"
    ]
  }
  statement {
    effect = "Deny"
    not_actions = [
      "iam:Get*",
      "iam:List*",
      "iam:Describe*"
    ]
    resources = [
      "arn:aws:iam::${local.account_id}:policy/sandbox_user_permissions_boundary", #Hack to remove circular dependency
      "arn:aws:iam::${local.account_id}:role/${var.sandbox_user_name}",
      aws_iam_policy.sandbox_user_policy.arn,
      aws_iam_policy.sandbox_owner_policy.arn,
      aws_iam_user.sandbox_owner.arn
    ]
  }
  statement {
    effect = "Deny"
    actions = [
      "iam:AttachUserPolicy",
      "iam:AttachRolePolicy",
      "iam:CreateUser",
      "iam:CreateRole",
      "iam:DeleteUserPolicy",
      "iam:DeleteRolePolicy",
      "iam:DetachUserPolicy",
      "iam:DetachRolePolicy",
      "iam:PutUserPermissionsBoundary",
      "iam:PutRolePermissionsBoundary",
      "iam:PutUserPolicy",
      "iam:PutRolePolicy"
    ]
    resources = [
      "*"
    ]
    condition {
      test = "StringNotEquals"
      variable = "iam:PermissionsBoundary"
      values = [
       "arn:aws:iam::${local.account_id}:policy/sandbox_user_permissions_boundary"
      ]
    }
  }
}


resource "aws_iam_policy" "sandbox_user_policy" {
  name        = "sandbox_user_policy"
  description = "Policy for Sandbox user"
  policy      = data.aws_iam_policy_document.sandbox_user_policy_document.json
}

data "aws_iam_policy_document" "sandbox_user_policy_document" {
  statement {
    actions = [
        "*"
    ]
    resources = [
        "*"
    ]
  }
}

resource "aws_iam_user_policy_attachment" "sandbox_user_policy_attachment" {
  user       = aws_iam_user.sandbox_user.name
  policy_arn = aws_iam_policy.sandbox_user_policy.arn
}
