# ./securitygroup.tf

# ALB用
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.vpc03.id
  name   = "${var.vpc_name}-alb-sg"
  description = "Allow HTTP traffic to ALB"

  # Ingress：HTTPアクセス許可
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress：全ての通信を許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-alb-sg"
  }
}

# EC2用
resource "aws_security_group" "asg_sg" {
  vpc_id = aws_vpc.vpc03.id
  name   = "${var.vpc_name}-ec2-sg"
  description = "Allow traffic to EC2 instances from ALB"

  # Ingress：ALBからのHTTP通信のみ許可
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Ingress：SSHアクセスを全体から許可
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress (アウトバウンド) - 全ての通信を許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-ec2-sg"
  }
}

# RDS用セキュリティグループ（EC2からのMySQL通信を許可）
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.vpc03.id
  name   = "${var.vpc_name}-rds-sg"
  description = "Allow MySQL traffic to RDS from EC2 instances"

  # Ingress (インバウンド) - EC2からのMySQL通信のみ許可
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.asg_sg.id]
  }

  # Egress (アウトバウンド) - 全ての通信を許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-rds-sg"
  }
}
