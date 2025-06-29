variable "environment" {
  description = "Environment name (test/prod)"
  type        = string
}

variable "private_key_path" {
  description = "Path to your SSH private key"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

