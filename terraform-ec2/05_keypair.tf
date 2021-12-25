# This will create a key with RSA algorithm with 4096 rsa bits
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# This resource will create a key pair using above private key
resource "aws_key_pair" "key_pair" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.private_key.public_key_openssh
  tags       = var.tags

  depends_on = [tls_private_key.private_key]
}

# This resource will save the private key at our specified path.
resource "local_file" "save_key_file" {
  content         = tls_private_key.private_key.private_key_pem
  filename        = "${var.ssh_key_base_path}/${var.ssh_key_name}.pem"
  file_permission = "400"
}
