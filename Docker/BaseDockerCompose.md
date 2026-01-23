# Installation 
## Créer le répertoire qui contiendra les binaires
sudo mkdir -p /usr/local/lib/docker/cli-plugins/

## Télécharger les binaires
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/lib/docker/cli-plugins/docker-compose

# Rendre Docker Compose exécutable
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Verifier version
docker compose version

# Créer un réseau entre les deux conteneurs
docker network create ecommerce

## Exécuter le conteneur de serveur web Apache2
docker run -p 80:80 --name webserver --net ecommerce web

## Exécuter le conteneur de serveur de base de données MySQL
docker run --name database --net ecommerce web

# Contruction de l'arborescence
```sh
./repertoire
    |── docker-compose.yml 
    └── web/
        └── Dockerfile
```

# Exemple de docker compose
```sh
version: '3.3'
services:
  web:
    build: ./web
    networks:
      - ecommerce
    ports:
      - '80:80'
  database:
    image: mysql:latest
    networks:
      - ecommerce
    environment:
      - MYSQL_DATABASE=ecommerce
      - MYSQL_USERNAME=root
      - MYSQL_ROOT_PASSWORD=helloword
    
networks:
  ecommerce:
```