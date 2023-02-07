output "sg" {
  value = aws_security_group.allow_all.id
}

output "subnet" {
  value = aws_subnet.private.id
}