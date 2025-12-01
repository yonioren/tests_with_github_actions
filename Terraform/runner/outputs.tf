output "private_key_path" {
  value = var.private_key
}

output "instance_id" {
  value = module.runner_instance.instance_id
}

output "runner_public_ip" {
  value = module.runner_instance.public_ip
}