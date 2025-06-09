# variables.tf
variable "ssh_user" {
  description = "Utilisateur SSH"
  type        = string
}

variable "ssh_host" {
  description = "IP ou hostname du serveur"
  type        = string
}

variable "private_key" {
  description = "Clé privée SSH"
  type        = string
  sensitive   = true
}

variable "nginx_port" {
  description = "Port Nginx"
  type        = number
  default     = 6666
}
