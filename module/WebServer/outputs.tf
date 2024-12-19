# This is outputs file for the WebServer module 

output "ASG_ARN" {
  value = aws_autoscaling_group.ProdASG.arn
}

output "ALB_ARN" {
  value = aws_lb.ProdLB.arn
}

output "ASG_Name" {
  value = aws_autoscaling_group.ProdASG.name
}