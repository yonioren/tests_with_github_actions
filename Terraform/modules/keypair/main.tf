resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = var.key_name
  public_key = tls_private_key.generated.public_key_openssh
}

resource "local_file" "private_key" {
  filename = var.private_key
  content  = tls_private_key.generated.private_key_pem
  file_permission = "0400"
}