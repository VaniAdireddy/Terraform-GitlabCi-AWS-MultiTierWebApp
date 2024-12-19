# This WebServer Module creates EC2 using Launch Templates and deploys application, includes ASG and ALB 

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Module = "WebServer"
      Name   = var.tag_value
    }
  }
}

# Fetch the latest AMI
data "aws_ami" "LatestAMI" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["a*-ami-202*-x86_64"]
  }
}

# Launch Template for EC2 instance configuration
resource "aws_launch_template" "LT_main" {
  instance_type          = "t2.micro"
  image_id               = data.aws_ami.LatestAMI.image_id
  vpc_security_group_ids = [var.ec2sg]
  
  # Pass database parameters to EC2 instances via user data script
  user_data = base64encode(templatefile("${path.module}/deploy_app.sh", {
    DB_HOST           = trimsuffix("${var.DB_HOST}", ":3306")
    DB_USER           = var.DB_USER
    DB_PASSWORD_PARAM = var.DB_PASSWORD_PARAM
    DB_PORT           = var.DB_PORT
    DB_NAME           = var.DB_NAME
  }))
  depends_on = [var.DB_HOST]
}

# Auto Scaling Group (ASG) configuration
resource "aws_autoscaling_group" "ProdASG" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [var.publicsub1, var.publicsub2]

  # Launch template used for the ASG
  launch_template {
    id      = aws_launch_template.LT_main.id
    version = "$Latest"
  }

  # Automatically register EC2 instances with the target group
  target_group_arns = [aws_lb_target_group.ProdTG.arn]  # Register with the target group

  # Remove circular dependency by not requiring target group to be created first
  depends_on = [aws_launch_template.LT_main]
}

# ALB Target Group Configuration
resource "aws_lb_target_group" "ProdTG" {
  name       = "Prod-Target-80"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = var.vpc_id_main
  
  health_check {
    path                = "/testdatabase.php"  # Health check path, you can change this if needed
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # Remove circular dependency
}

# Application Load Balancer (ALB) configuration
resource "aws_lb" "ProdLB" {
  name               = "ProdLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.albsg]
  subnets            = [var.publicsub1, var.publicsub2]
}

# ALB Listener Configuration (HTTP on port 80)
resource "aws_lb_listener" "FrontEnd" {
  load_balancer_arn = aws_lb.ProdLB.arn
  port              = "80"
  protocol          = "HTTP"
  
  # Default action: forward to the target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ProdTG.arn
  }
}

