# This will create a key with RSA algorithm with 4096 rsa bits
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# This resource will create a key pair using above private key
resource "aws_key_pair" "ssh" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.ssh.public_key_openssh
  tags       = var.config.tags

  depends_on = [tls_private_key.ssh]
}

# This resource will save the private key at our specified path.
resource "local_file" "save_key_file" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${var.ssh_key_base_path}/${var.ssh_key_name}.pem"
  file_permission = "400" # Grant only read permission to owner

  provisioner "local-exec" {
    when = destroy
    command = "rm -rf $(dirname ${self.filename})"
  }
}
