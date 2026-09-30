output "vpc_id" {
  value = module.network.vpc_id

}

output "public_subnet_id" {
  value = module.network.public_subnet_id

}

output "private_subnet_id" {
  value = module.network.private_subnet_id

}

output "internet_gateway_id" {
  value = module.network.internet_gateway_id

}

output "alb_dns_name" {
  value = module.alb.alb_dns_name

}

output "alb_security_group_id" {
  value = module.alb.alb_security_group_id

}