# ALB Security Group (Traffic Internet -> ALB)
resource "aws_security_group" "alb" {
  name        = "load_balancer_security_group"
  description = "Controls access to the ALB."
  vpc_id      = aws_vpc.vpc.id
  tags        = var.tags

  ingress {
    description = "Allows HTTP inbound traffic from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}

# ECS Security group (traffic ALB -> ECS, ssh -> ECS)
resource "aws_security_group" "ecs" {
  name        = "ecs_security_group"
  description = "Allows inbound access from the ALB only"
  vpc_id      = aws_vpc.vpc.id
  tags        = var.tags
  ingress {
    description     = "Allow all inbound traffic from the load balancer"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description = "Allow SSH connections from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}