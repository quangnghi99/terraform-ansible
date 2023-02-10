provider "aws" {
  region  = "us-west-2"
}

variable "ansible_node_count" {
  type = number
  default = 2
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "private_key" {
  filename        = "${path.module}/ansible.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "ansible"
  public_key = tls_private_key.key.public_key_openssh
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

output "ansible-engine" {
  value = aws_instance.ansible-engine.public_ip
}

output "ansible-node-1" {
  value = aws_instance.ansible-nodes[0].public_ip
}

output "ansible-node-2" {
  value = aws_instance.ansible-nodes[1].public_ip
}