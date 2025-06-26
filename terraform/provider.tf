terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "remote" {
    organization = "test"

    workspaces {
      name = "test" # Changer dynamiquement dans TFC pour test/prod
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
