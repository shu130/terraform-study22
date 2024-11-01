# ./autoscaling.tf

# Auto Scaling Group with User Data for CloudWatch Agent and awslogs
resource "aws_launch_template" "web_server" {
  name_prefix   = "${var.ec2_instance_name}-lt-"
  image_id      = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_key_pair

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.asg_sg.id]
  }

  user_data = base64encode(templatefile("${path.module}/scripts/cloudwatch_user_data.sh", {
    access_log_group = aws_cloudwatch_log_group.apache_access_log.name,
    error_log_group  = aws_cloudwatch_log_group.apache_error_log.name
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.ec2_instance_name}"
    }
  }  
}

resource "aws_autoscaling_group" "web_server_asg" {
  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }
  min_size         = 2
  desired_capacity = 2
  max_size         = 4
  vpc_zone_identifier = aws_subnet.public_subnets[*].id

  tag {
    key   = "Name"
    value = var.ec2_instance_name
    propagate_at_launch = true
  }
}