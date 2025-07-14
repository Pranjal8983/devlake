resource "aws_lb" "this" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets

  tags = {
    Name = var.name
  }
}

# Target Groups
resource "aws_lb_target_group" "default" {
  name     = "${var.name}-tg-default"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}


resource "aws_lb_target_group_attachment" "default" {
  target_group_arn = aws_lb_target_group.default.arn
  target_id        = var.instance_ids
  port             = 4000
}
