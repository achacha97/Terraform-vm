provider "aws" {
  region = "us.east.1"
}

# Création du VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "ECF-VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ECF-IGW"
  }
}

# Table de routage principale
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "ECF-Public-RT"
  }
}

# Subnet public
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "ECF-Public-Subnet"
  }
}

# Association table de routage et subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group permettant SSH, HTTP, HTTPS
resource "aws_security_group" "web" {
  name        = "ecf-web-sg"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ECF-Web-SG"
  }
}

# Elastic IP
resource "aws_eip" "web" {
  vpc = true
  tags = {
    Name = "ECF-Web-EIP"
  }
}

# Network Interface
resource "aws_network_interface" "web" {
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.web.id]
  tags = {
    Name = "ECF-Web-NIC"
  }
}

# Association EIP et Network Interface
resource "aws_eip_association" "web" {
  network_interface_id = aws_network_interface.web.id
  allocation_id        = aws_eip.web.id
}

# Key Pair (à remplacer par votre clé existante ou générer une nouvelle)
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")  # Modifier selon votre chemin
}

# Instance EC2 avec Debian Bullseye
resource "aws_instance" "web" {
  ami           = "ami-0779caf41f9ba54f0"  # Debian 12 Bullseye
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name

  network_interface {
    network_interface_id = aws_network_interface.web.id
    device_index         = 0
  }

  user_data = file("user_data.sh")

  tags = {
    Name = "ECF-Web-Server"
  }
}
