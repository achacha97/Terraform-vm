terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  # Le token ne devrait pas être en dur dans le code
  # Il sera passé via variable ou environnement
}

data "vault_kv_secret_v2" "aws_creds" {
  mount = "secret"
  name  = "aws"
}

provider "aws" {
  region     = var.region
  access_key = data.vault_kv_secret_v2.aws_creds.data["api_key"]
  secret_key = data.vault_kv_secret_v2.aws_creds.data["secret_key"]
}

resource "aws_instance" "linux_vm" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  tags = {
    Name = "MyFirstTerraformVM"
  }
}
