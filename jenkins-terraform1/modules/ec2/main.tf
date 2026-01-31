variable "subnet_id" {}
variable "sg_id" {}
variable "key_name" {}
variable "github_repo" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_eip" "this" {
  domain = "vpc"
}

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true

  # 🔥 Important — bigger disk for Docker/Jenkins
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = replace(file("${path.module}/userdata.sh"), "REPO_PLACEHOLDER", var.github_repo)

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_eip_association" "assoc" {
  instance_id   = aws_instance.jenkins.id
  allocation_id = aws_eip.this.id
}

output "instance_id" {
  value = aws_instance.jenkins.id
}

output "eip" {
  value = aws_eip.this.public_ip
}
