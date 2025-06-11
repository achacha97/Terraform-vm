variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "ID de l'AMI Linux"
  type        = string
  default     = "ami-02457590d33d576c3"  # Amazon Linux 2 (us-east-1)
}

variable "instance_type" {
  description = "Type d'instance"
  type        = string
  default     = "t2.micro"
}
# Variable optionnelle pour le token Vault (meilleure pratique)
variable "vault_token" {
  description = "Token d'accès à Vault"
  type        = string
  sensitive   = true
  default     = "" # Préférez le passer via variable d'environnement
}
