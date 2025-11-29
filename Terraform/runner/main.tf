module "keypair" {
  source = "../modules/keypair"

  key_name = var.key_name
  private_key = "${path.module}/${var.private_key}"
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

module "sg_runner" {
  source = "../modules/security_group"

  name = "runner-sg"
  vpc_id = module.network.vpc_id

  ingress_rules_by_cidr = [
    {
      description = "SSH"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
    }
  ]

  egress_rules = [
    {
      description = "All outbound"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "runner_instance" {
  source = "../modules/compute"

  ami_id = var.ubuntu_ami
  instance_type = var.instance_type
  subnet_id = module.network.public_subnet_ids[0]
  key_name = module.keypair.key_name
  security_group_ids = [module.sg_runner.security_group_id]
  user_data = templatefile("${path.module}/userdata-runner.tpl", {})
  hostname = "runner"
}