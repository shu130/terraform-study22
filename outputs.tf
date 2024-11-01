# ./outputs.tf

#------------------------
# VPC
output "vpc_info" {
  value = {
    vpc_id              = aws_vpc.vpc03.id
    public_subnets_ids  = aws_subnet.public_subnets[*].id
    private_subnets_ids = aws_subnet.private_subnets[*].id
  }
}

#------------------------
# Security Group
output "security_group_info" {
  value = {
    alb_sg = {
      id          = aws_security_group.alb_sg.id
      name        = aws_security_group.alb_sg.name
      description = aws_security_group.alb_sg.description
    }
    asg_sg = {
      id          = aws_security_group.asg_sg.id
      name        = aws_security_group.asg_sg.name
      description = aws_security_group.asg_sg.description
    }
    rds_sg = {
      id          = aws_security_group.rds_sg.id
      name        = aws_security_group.rds_sg.name
      description = aws_security_group.rds_sg.description
    }
  }
}


#------------------------
# ALB
output "alb_info" {
  value = {
    dns_name          = aws_lb.my_alb.dns_name
    alb_arn           = aws_lb.my_alb.arn
    target_group_arn  = aws_lb_target_group.my_target_group.arn
    listener_arn      = aws_lb_listener.my_listener.arn
    security_group_id = aws_security_group.alb_sg.id
  }
}

#------------------------
# Auto ScalingGroup
output "asg_info" {
  value = {
    name               = aws_autoscaling_group.ec2_asg.name
    arn                = aws_autoscaling_group.ec2_asg.arn
    desired_capacity   = aws_autoscaling_group.ec2_asg.desired_capacity
    max_size           = aws_autoscaling_group.ec2_asg.max_size
    min_size           = aws_autoscaling_group.ec2_asg.min_size
  }
}

#------------------------
# Launch Template
output "launch_template_info" {
  value = {
    id      = aws_launch_template.ec2_launch_template.id
    version = aws_launch_template.ec2_launch_template.latest_version
  }
}

#------------------------
# Target Group
output "target_group_arn" {
  value       = aws_lb_target_group.my_target_group.arn
}


#------------------------
# RDS Instance
output "rds_info" {
  value = {
    db_instance_identifier  = aws_db_instance.rds_instance.id
    db_instance_endpoint    = aws_db_instance.rds_instance.endpoint
    db_instance_port        = aws_db_instance.rds_instance.port
    db_name                 = aws_db_instance.rds_instance.db_name
    multi_az                = aws_db_instance.rds_instance.multi_az
    # Primary AZ:
    availability_zones      = aws_db_instance.rds_instance.availability_zone
  }
}
