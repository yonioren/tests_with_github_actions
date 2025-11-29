module "keypair" {
  source = "../modules/keypair"

  key_name = var.key_name
  private_key = abspath("${path.cwd}/${var.private_key}")
}

module "network" {
  source = "../modules/network"

  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

data "http" "my_ip" {
  url = "https://api.ipify.org/?format=text"
}

# ALB security group (allow HTTP from internet)
module "alb_sg" {
  source    = "../modules/security_group"

  name        = "k8s-alb-sg"
  vpc_id      = module.network.vpc_id
  ingress_rules_by_cidr = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

module "master_sg" {
  source    = "../modules/security_group"

  name   = "k8s-master-sg"
  vpc_id = module.network.vpc_id
  ingress_rules_by_cidr = [
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"] }
  ]
}

module "workers_sg" {
  source    = "../modules/security_group"

  name   = "k8s-workers-sg"
  vpc_id = module.network.vpc_id
  ingress_rules_by_sg = [
    { from_port = var.service_port, to_port = var.service_port, protocol = "tcp", source_security_group_id=module.alb_sg.security_group_id }
  ]
}

module k8s_cluster_sg {
  source = "../modules/security_group"

  name = "k8s-inter-cluster-sg"
  vpc_id = module.network.vpc_id
  ingress_rules_by_self = [
    { from_port = 0, to_port = 0, protocol = "-1"}
  ]
}

module "master" {
  source    = "../modules/compute"

  ami_id             = var.ubuntu_ami
  instance_type      = var.instance_type_master
  subnet_id          = module.network.public_subnet_ids[0]
  key_name           = var.key_name
  security_group_ids = [module.master_sg.security_group_id, module.k8s_cluster_sg.security_group_id]
  user_data          = templatefile("${path.module}/userdata-master.tpl", {hostname="m1",
                                                                            workers=module.workers[*].instance_data,
                                                                            private_key_location_on_server=var.private_key_location_on_server})
  hostname           = "m1"
}

resource "terraform_data" "copy_key" {
  depends_on = [ module.master ]

  provisioner "file" {
    source      = module.keypair.private_key_path
    destination = var.private_key_location_on_server
    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file(module.keypair.private_key_path)
        host        = module.master.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod 0400 ${var.private_key_location_on_server}",
      "chown ubuntu:ubuntu ${var.private_key_location_on_server}"
    ]
    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file(module.keypair.private_key_path)
        host        = module.master.public_ip
    }
  }
}

module "workers" {
  count = 2
  source    = "../modules/compute"

  ami_id             = var.ubuntu_ami
  instance_type      = var.instance_type_worker
  subnet_id          = module.network.private_subnet_ids[count.index]
  key_name           = var.key_name
  security_group_ids = [module.workers_sg.security_group_id, module.k8s_cluster_sg.security_group_id]
  user_data          = templatefile("${path.module}/userdata-worker.tpl", {hostname="w${count.index + 1}"})
  hostname           = "w${count.index + 1}"
}

module "alb" {
  source    = "../modules/alb"

  name              = "k8s-check-alb"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  instance_ids      = module.workers[*].instance_id
  security_group_id = module.alb_sg.security_group_id
  target_port       = var.service_port
}
