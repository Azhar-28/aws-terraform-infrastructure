output "alb_dns_name" {
    value = aws_lb.app.dns_name
  
}

output "alb_security_group_id" {
    value = var.security_group_id
  
}

output "target_group_arn" {
    value = aws_lb_target_group.app.arn
  
}