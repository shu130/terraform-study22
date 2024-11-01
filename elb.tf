# ./elb.tf

# ALB
resource "aws_lb" "my_alb" {
  name               = "${var.ec2_instance_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_subnets[0].id,
    aws_subnet.public_subnets[1].id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "${var.ec2_instance_name}-alb"
  }
}

# ALBのターゲットグループ
resource "aws_lb_target_group" "my_target_group" {
  name     = "${var.ec2_instance_name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc03.id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "${var.ec2_instance_name}-target-group"
  }
}

# ALBのリスナー
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}
