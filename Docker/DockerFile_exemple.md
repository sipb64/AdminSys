# Dockerfile - Création d'Images Personnalisées

## Exemple "Hello World" (Minimaliste)
```bash
# Image de base ultra-légère (5 Mo)
FROM alpine:latest

# Commande exécutée au lancement du conteneur
CMD ["echo", "Image construite."]
```
### Build & Run
```bash
# Construire l'image (le point . désigne le dossier courant)
docker build -t mon-hello-world .

# Lancer (affiche le message et s'arrête)
docker run --rm mon-hello-world
```
## Exemple Réel : Serveur Web Apache (Debian)
```text
# Image de base (Utiliser la version majeure !)
FROM debian:12-slim

# Metadonnées
LABEL maintainer="mon-email@exemple.com"
LABEL description="Serveur Apache personnalisé sur Debian 12"

# Installation des paquets
RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configuration / Fichiers
COPY ./index.html /var/www/html/index.html

# Exposition Réseau
EXPOSE 80

# Persistance
VOLUME ["/var/log/apache2"]

# Démarrage (-D FOREGROUND important : Docker tue le conteneur s'il passe en background)
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```
