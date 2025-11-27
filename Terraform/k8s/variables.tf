
variable "aws_region" { default = "us-east-1" }
variable "vpc_cidr" { default = "10.1.0.0/16" }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "instance_type_master" { default = "t3.medium" }
variable "instance_type_worker" { default = "t3.medium" }

variable "key_name" { default = "k8s-key" }
variable "private_key" { default = "k.pem" }
variable "ubuntu_ami" {
  description = "Ubuntu Server 24.04 LTS AMI ID"
  default     = "ami-0e001c9271cf7f3b9"
}

variable "service_port" {
  type = number
  default = 80
}

variable "private_key_location_on_server" { default = "/home/ubuntu/k.pem" }
