resource "aws_lb" "this" {
  name = var.name
  load_balancer_type = "application"
  subnets = var.public_subnet_ids
  security_groups = [var.security_group_id]
}

resource "aws_lb_target_group" "tg" {
  name = "tg-${var.name}"
  port = var.target_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "targets" {
  count = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = var.instance_ids[count.index]
  port = var.target_port
}