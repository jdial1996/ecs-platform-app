module "ecs-cluster" {
    source = "git@github.com:jdial1996/terraform-modules//modules/ecs?ref=ecs-v0.1.0"
}

data "aws_iam_policy_document" "ecs_task_execution_assume_role_policy_doc" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ECSTaskExecutionRole"
  assume_role_policy      = data.aws_iam_policy_document.ecs_task_execution_assume_role_policy_doc.json
}

data "aws_iam_policy" "ecs_task_execution_policy" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_deploy_tf_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_policy.arn
}