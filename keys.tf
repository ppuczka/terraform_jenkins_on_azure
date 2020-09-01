resource "tls_private_key" "jenkins_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
