resource "aws_cloudwatch_log_group" "ecs_task_log_group" {
  name = "${var.service_name}-log-group-${terraform.workspace}"
}

resource "aws_security_group" "ecs_security_group" {
  name   = "${var.service_name}-ecs-sg-${terraform.workspace}"
  vpc_id = module.ecs-cluster.vpc_id

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "test-deployment2" {
  family                   = "${var.service_name}-${terraform.workspace}"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.image_name}:${var.image_tag}"
      cpu       = 256
      memory    = 512
      essential = true
      command   = var.command
      portMappings = [
        {
          containerPort = var.flask_app_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = aws_cloudwatch_log_group.ecs_task_log_group.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = var.service_name
        }
      }
    },
  ])
}

resource "aws_ecs_service" "test-deployment" {
  name            = "${var.service_name}-${terraform.workspace}"
  cluster         = module.ecs-cluster.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.test-deployment2.arn
  desired_count   = var.desired_count
  network_configuration {
    subnets         = module.ecs-cluster.private_subnets
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.platform_app_tg.arn
    container_name   = var.service_name
    container_port   = var.flask_app_port
  }

  lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }
}