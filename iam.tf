resource "aws_iam_user" "gitlab_ci_iam_user" {
  name = "${var.tenant}-gitlab_ci"
  tags = merge({}, var.tags)
}
