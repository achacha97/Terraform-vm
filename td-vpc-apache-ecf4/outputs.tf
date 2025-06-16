output "public_ip" {
  description = "Adresse IP publique de l'instance"
  value       = aws_eip.web.public_ip
}
