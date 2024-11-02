# ./autoscaling.tf

# EC2のローンチテンプレート
resource "aws_launch_template" "ec2_launch_template" {
  name_prefix   = "${var.ec2_instance_name}-lt-"
  image_id      = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_key_pair
  user_data     = base64encode(templatefile("${path.module}/scripts/wordpress_user_data.sh", {
    rds_db_name  = var.rds_db_name,
    rds_username = var.rds_username,
    rds_password = var.rds_password,
    rds_endpoint = aws_db_instance.rds_instance.endpoint
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.asg_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.ec2_instance_name}"
    }
  }
}

# オートスケーリンググループ
resource "aws_autoscaling_group" "ec2_asg" {
  desired_capacity = 1
  max_size         = 4
  min_size         = 1
  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id]
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.my_target_group.arn]

  tag {
    key   = "Name"
    value = "${var.ec2_instance_name}"
    propagate_at_launch = true
  }
}

# オートスケーリングポリシー
resource "aws_autoscaling_policy" "scale_policy" {
  for_each = {
    scale_out = {
      name = "${var.ec2_instance_name}-scale-out-policy"
      scaling_adjustment = 1
    }
    scale_in = {
      name = "${var.ec2_instance_name}-scale-in-policy"
      scaling_adjustment = -1
    }
  }

  name                   = each.value.name
  scaling_adjustment     = each.value.scaling_adjustment
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
}
