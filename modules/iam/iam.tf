data "aws_iam_policy_document" "assume-role-policy-oidc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "AWS"

      identifiers = var.iam_providers
    }
  }
}

resource "aws_iam_role" "orbis_roles" {
  count              = length(var.service_names)
  name               = var.service_names[count.index]
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy-oidc.json
  path               = var.path
  tags               = var.tags
}


resource "aws_iam_policy_attachment" "policies" {
  for_each = var.service_names
  name = policies.value
  count      = length(var.policy_arns)
  policy_arn = var.policy_arns[count.index]
  roles      = aws_iam_role.orbis_roles[count.index]
}
