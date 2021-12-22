# Application Load Balancer attached to the public subnets
resource "aws_lb" "alb" {
  name               = "${var.ecs_cluster_name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [ aws_security_group.alb.id ]
  subnets            = values(aws_subnet.public).*.id
}

# Target group attached to the ALB.
resource "aws_alb_target_group" "alb_ecs_http" {
  name        = "${var.ecs_cluster_name}-client-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

# Listener (redirects traffic from the load balancer to the target group)
# Tells the load balancer to forward incoming traffic on port 80 to wherever the load balancer is attached (the ECS service).
resource "aws_alb_listener" "alb_ecs_http" {
  load_balancer_arn = aws_lb.alb.id
  port              = 80
  protocol          = "HTTP"
  depends_on        = [ aws_alb_target_group.alb_ecs_http ]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_ecs_http.arn
  }
}
