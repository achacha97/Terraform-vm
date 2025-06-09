# main.tf
resource "null_resource" "ssh_target" {
  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = "10.0.2.15"
    agent = true  
  }
  # ... vos provisioners ...

  # 1. Installer Nginx
provisioner "remote-exec" {
  inline = [
    "sudo dpkg --configure -a", 
    "sudo apt-get update || true",
    "sudo apt-get install -y nginx"
  ]
}  
  # 2. Copier le fichier index.html
  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }

  # 3. Configuration et démarrage de Nginx
      provisioner "remote-exec" {
      inline = [
    # Préparation des fichiers
     "sudo mv /tmp/index.html /var/www/html/index.html",
     "sudo chown www-data:www-data /var/www/html/index.html",
   # Vérification de la configuration actuelle
     "echo '=== Configuration Nginx actuelle ==='",
     "sudo grep 'listen' /etc/nginx/sites-enabled/default || true",
   # Correction du port
     "sudo sed -i 's/listen .*/listen 6666 default_server;/g' /etc/nginx/sites-enabled/default",
   # Vérification syntaxique
     "sudo nginx -t",
    # Redémarrage forcé
     "sudo systemctl restart nginx",
    # Vérification du statut
     "sudo systemctl status nginx --no-pager || true",
    # Vérification de l'écoute du port
     "sudo netstat -tulnp | grep 6666 || sudo ss -tulnp | grep 6666 || echo 'Aucun service sur 6666'",
    #Gestion PARE FEU
      "sudo ufw allow 6666/tcp || true",
      "sudo systemctl restart nginx"
    ]
  }

  # 4. Tester la connexion
  provisioner "local-exec" {
  command = <<EOT
    # Vérifie si curl est installé, sinon l'installe
    if ! command -v curl &> /dev/null
    then
      echo "curl n'est pas installé, installation en cours..."
      sudo apt-get update && sudo apt-get install -y curl
    fi

    # Essayer de se connecter à Nginx sur le port donné
    echo "Essai de connexion à http://${var.ssh_host}:${var.nginx_port}"
    curl --max-time 10 http://${var.ssh_host}:${var.nginx_port} || { echo "Échec de la connexion à Nginx"; exit 1; }
  EOT
}
}
