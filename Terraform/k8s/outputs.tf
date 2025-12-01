output "master_public_ip" {
  value = module.master.public_ip
}

output "master_private_ip" {
  value = module.master.private_ip
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "private_key_path" {
  value = module.keypair.private_key_path
}
