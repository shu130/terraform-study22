# ./cloudwatch.tf

# CloudWatchアラームでCPU使用率に基づいてスケールインとスケールアウト
resource "aws_cloudwatch_metric_alarm" "cpu_scale_alarm" {
  for_each = {
    scale_out = {
      alarm_name          = "${var.ec2_instance_name}-scale-out"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      threshold           = 70
      alarm_actions       = [aws_autoscaling_policy.scale_policy["scale_out"].arn]
    }
    scale_in = {
      alarm_name          = "${var.ec2_instance_name}-scale-in"
      comparison_operator = "LessThanOrEqualToThreshold"
      threshold           = 30
      alarm_actions       = [aws_autoscaling_policy.scale_policy["scale_in"].arn]
    }
  }

  alarm_name          = each.value.alarm_name
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = each.value.threshold
  alarm_actions       = each.value.alarm_actions
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_asg.name
  }
}

