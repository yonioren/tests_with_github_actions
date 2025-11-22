output "instance_id" {
  value = aws_instance.vm.id
}

output "private_ip" {
  value = aws_instance.vm.private_ip
}

output "public_ip" {
  value = aws_instance.vm.public_ip
}

output "name" {
  value = aws_instance.vm.tags.Name
}

output "instance_data" {
  value = {
    name = aws_instance.vm.tags.Name
    ip   = aws_instance.vm.private_ip
  }
}