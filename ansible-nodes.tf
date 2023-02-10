## ================================ Ansible Node Instances ================================
resource "aws_instance" "ansible-nodes" {
  count           = var.ansible_node_count

  ami             = data.aws_ami.ami.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ansible_access.id]
  user_data       = file("user-data-ansible-nodes.sh")
  tags = {
    Name = "ansible-node-${count.index + 1}"
  }
}