terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.1.0"
}

# Application Load Balancer attached to the public subnets
resource "aws_lb" "alb" {
  name                             = "${var.config.app_name}-alb-${var.config.environment}"
  load_balancer_type               = "application"
  internal                         = false
  subnets                          = var.public_subnet_ids
  security_groups                  = [var.alb_sg_id]
  tags                             = var.config.tags
  enable_cross_zone_load_balancing = true
}

# Target group connected to the listener, it contains target IP addresses accross which incoming traffic is distributed
resource "aws_alb_target_group" "ecs_http" {
  name       = "${var.config.app_name}-http-tg-${var.config.environment}"
  port       = var.config.port_num
  protocol   = "HTTP"
  vpc_id     = var.vpc_id
  tags       = var.config.tags
  depends_on = [aws_lb.alb]

  health_check {
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200,301,302"
  }
}

# Listener (redirects traffic from the load balancer to the target group)
# Tells the load balancer to forward incoming traffic on port 443 to wherever the load balancer is attached (the ECS service).
resource "aws_alb_listener" "ecs_https" {
  load_balancer_arn = aws_lb.alb.id
  port              = "443"
  protocol          = "HTTPS"
  tags              = var.config.tags
  depends_on        = [aws_alb_target_group.ecs_http]
  certificate_arn   = aws_acm_certificate.ssl_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_http.arn
  }
}

# Tells the load balancer to redirect incoming traffic on HTTP port to port 443 (HTTPS).
resource "aws_alb_listener" "ecs_http" {
  load_balancer_arn = aws_lb.alb.id
  port              = var.config.port_num
  protocol          = "HTTP"
  tags              = var.config.tags
  depends_on        = [aws_alb_target_group.ecs_http]

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
