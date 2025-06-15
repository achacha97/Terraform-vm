storage "file" {
  path = "/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1 # Désactive TLS pour le dev (à éviter en prod)
}

ui = true  # Active l'interface web
