resource "aws_iam_user" "gitlab_ci_iam_user" {
  name = "${var.tenant}-gitlab_ci"
  tags = merge({}, var.tags)
}

resource "aws_iam_access_key" "gitlab_ci_iam_user_key" {
  user    = aws_iam_user.gitlab_ci_iam_user.name
}

resource "aws_iam_user_group_membership" "iac_group" {
  user = aws_iam_user.gitlab_ci_iam_user.name
  groups = [
    var.iac_group_name
  ]
}