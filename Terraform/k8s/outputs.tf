output "master_instance_id" {
  value = module.master.instance_id
}

output "master_public_ip" {
  value = module.master.public_ip
}

output "master_private_ip" {
  value = module.master.private_ip
}

output "workers_instance_ids" {
  value = module.workers[*].instance_id
}

output "workers_private_ips" {
  value = module.workers[*].private_ip
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
