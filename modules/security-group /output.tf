output "sg_id" {
  value = aws_security_group.security_group.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_security_group.id
}
