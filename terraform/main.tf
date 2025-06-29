resource "aws_instance" "app_server" {
  ami           = "ami-020cba7c55df1f615"  # Ubuntu 22.04 LTS
  instance_type = var.instance_type
  key_name      = aws_key_pair.terraform_key.key_name

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name        = "AppServer-${var.environment}"
    Environment = var.environment
  }

  # Utilisation d'un script externe plus fiable
  provisioner "remote-exec" {
    script = "${path.module}/setup_env.sh"
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/home/ubuntu/.ssh/id_rsa_prod")
      host        = self.public_ip
      timeout     = "5m"
    }
  }
}

resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow_ssh_${var.environment}"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key-${var.environment}"
  public_key = file("/home/ubuntu/.ssh/id_rsa_prod.pub")
}
