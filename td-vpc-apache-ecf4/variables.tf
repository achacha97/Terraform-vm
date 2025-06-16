variable "aws_region" {
  description = "Région AWS"
  default     = "us-east-1"  
}

variable "vpc_cidr" {
  description = "Bloc CIDR du VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Bloc CIDR du subnet"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nom de la clé SSH"
  default     = "ecf-key"
}
