variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "i-0bdeab1fc7e3c755e"
  type        = string
  default     = "ami-02457590d33d576c3"  # Amazon Linux 2 (us-east-1)
}

variable "instance_type" {
  description = "Type d'instance"
  type        = string
  default     = "t2.micro"
}
