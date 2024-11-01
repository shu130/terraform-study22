# ./rds.tf

# RDSサブネットグループ
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.rds_name}-subnet-group"
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "${var.rds_name}-subnet-group"
  }
}

# RDSインスタンス：マルチAZ
resource "aws_db_instance" "rds_instance" {
  identifier             = "${var.rds_name}-db-instance"
  allocated_storage      = var.rds_allocated_storage
  instance_class         = var.rds_instance_class
  engine                 = "mysql"
  engine_version         = var.rds_engine_version
  username               = var.rds_username
  password               = var.rds_password
  db_name                = var.rds_db_name
  parameter_group_name   = aws_db_parameter_group.rds_parameter_group.id
  multi_az               = var.rds_multi_az
  storage_type           = "gp2"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  backup_retention_period = 0

  tags = {
    Name = "${var.rds_name}-db-instance"
  }
}

# RDSパラメータグループ
resource "aws_db_parameter_group" "rds_parameter_group" {
  name   = "${var.rds_name}-param-group"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "max_connections"
    value = "150"
  }

  tags = {
    Name = "${var.rds_name}-param-group"
  }
}
