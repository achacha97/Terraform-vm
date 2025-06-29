terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ECF5-TEST"
    workspaces {
      name = "nodejs-app-prod"
    }
  }
}

provider "aws" {
  region = var.region
  
  # Option 1: Utilisation des variables d'environnement (recommandé)
  # Option 2: Décommentez pour utiliser un rôle IAM
  # assume_role {
  #   role_arn = "arn:aws:iam::123456789012:role/TerraformAccessRole"
  # }
  
  default_tags {
    tags = {
      Environment = var.environment
      Terraform   = "true"
    }
  }
}
