variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "ID de l'AMI Linux"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 (us-east-1)
}

variable "instance_type" {
  description = "Type d'instance"
  type        = string
  default     = "t2.micro"
}
