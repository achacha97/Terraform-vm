resource "aws_instance" "app_server" {
  ami           = "ami-020cba7c55df1f615" # Ubuntu 22.04 LTS (exemple)
  instance_type = "t2.micro"

  tags = {
    Name = "AppServer-${var.environment}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y && sudo apt install -y python3",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}
