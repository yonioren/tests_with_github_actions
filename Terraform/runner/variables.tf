variable "aws_region" { default = "us-east-1" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }

variable "key_name" { default = "runner-key" }
variable "private_key" { default = "k.pem" }

variable "instance_type" { default = "t3.micro" }
variable "ubuntu_ami" {
  description = "Ubuntu Server 24.04 LTS AMI ID"
  default     = "ami-0e001c9271cf7f3b9"
}