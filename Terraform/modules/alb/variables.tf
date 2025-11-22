variable "name" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "instance_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "target_port" {
  type = number
  default = 80
}