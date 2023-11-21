
resource "aws_lb" "my_alb" {
  name               = "${var.service_name}-alb-${terraform.workspace}"
  internal           = false
  load_balancer_type = "application"
  subnets            =  module.ecs-cluster.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
  idle_timeout       = 4000
}

resource "aws_security_group" "alb_sg" {
  name   = "${var.service_name}-alb-sg-${terraform.workspace}"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.platform_app_tg.arn
  }
}

resource "aws_lb_target_group" "platform_app_tg" {
  name        = "${var.service_name}-tg-${terraform.workspace}"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}