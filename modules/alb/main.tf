resource "aws_lb_target_group" "app" {
    name = "lab15-app-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
      path = "/"
      protocol = "HTTP"
      port = 80
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 5
      interval = 30
    }

    tags = {
      Name = "lab15-app-tg"
    }
  
}

resource "aws_lb_target_group_attachment" "app" {
    target_group_arn = aws_lb_target_group.app.arn
    target_id = var.traget_instance_id
    port = 80
  
}

resource "aws_lb" "app" {
    name = "lab15-app-alb"
    internal = false
    load_balancer_type = "application"

    security_groups = [ 
        var.security_group_id
     ]

     subnets = [ 
        var.public_subnet_a_id,
        var.public_subnet_b_id
      ]


      tags = {
        Name = "lab15-app-alb"
      }
  
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.app.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.app.arn
    }
  
}