resource "aws_iam_user" "sandbox_owner" {
  name               = var.sandbox_owner_name
}

resource "aws_iam_policy" "sandbox_owner_policy" {
  name        = "sandbox_owner_policy"
  description = "Policy for Sandbox owner"
  policy      = data.aws_iam_policy_document.sandbox_owner_policy_document.json
}

data "aws_iam_policy_document" "sandbox_owner_policy_document" {
  statement {
    actions = [
        "*"
    ]
    resources = [
        "*"
    ]
  }
}

resource "aws_iam_user_policy_attachment" "sandbox_owner_policy_attachment" {
  user       = aws_iam_user.sandbox_owner.name
  policy_arn = aws_iam_policy.sandbox_owner_policy.arn
}
