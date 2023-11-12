data "aws_iam_openid_connect_provider" "github_oidc" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "ecs_deploy_assume_role_policy_doc" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github_oidc.arn]
    }

    condition {
      test     = "StringLike"
      variable = "${data.aws_iam_openid_connect_provider.github_oidc.url}:sub"
      values   = ["repo:jdial1996/ecs-platform-app:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "${data.aws_iam_openid_connect_provider.github_oidc.url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_deploy_oidc_iam_role" {
  name               = "ecs-deploy-role-rw"
  assume_role_policy = data.aws_iam_policy_document.ecs_deploy_assume_role_policy_doc.json
}


data "aws_iam_policy_document" "ecs_deploy_tf_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "iam:PassRole",
      "logs:*",
      "ecs:*",
      "ec2:*",
      "elasticloadbalancing:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_deploy_tf_policy" {
  name        = "tf_policy"
  description = "Allow Terraform Actions & ECS Deploy"
  policy      = data.aws_iam_policy_document.ecs_deploy_tf_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_deploy_tf_policy_attachment" {
  role       = aws_iam_role.ecs_deploy_oidc_iam_role.name
  policy_arn = aws_iam_policy.ecs_deploy_tf_policy.arn
}