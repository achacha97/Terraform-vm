#!/bin/bash
set -e  # Arrête le script à la première erreur

# Mise à jour et installation
sudo apt update -y
sudo apt install -y python3

# Création du répertoire app
mkdir -p /home/ubuntu/app

# Configuration de l'environnement
echo "ENVIRONMENT_NAME=${environment}" | sudo tee /home/ubuntu/app/.env > /dev/null

# Correction des permissions
sudo chown ubuntu:ubuntu /home/ubuntu/app/.env
sudo chmod 644 /home/ubuntu/app/.env

# Vérification
echo "Configuration réussie :"
cat /home/ubuntu/app/.env
