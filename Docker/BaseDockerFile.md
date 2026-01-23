# Créer et se placer dans un dossier de travail (nom du projet)
mkdir projet_docker_file
cd projet_docker_file

# Créer et éditer un fichier Dockerfile
nano Dockerfile 

# Ajouter le contenu suivant dans le fichier Dockerfile
## Utiliser une image de base minimale (ex :Alpine Linux)
FROM alpine:latest
 
## Exécuter un script affichant un message
CMD ["echo", "BIEN JOUÉ ! VOUS AVEZ CRÉÉ VOTRE PREMIERE IMAGE À L'AIDE D'UN DOCKER FILE"]

# Déploiement (bien être dans le répertoire)
## Construire l'image Docker
docker build -t projet_docker_file .
## Vérifier que l'image a bien été créée
docker images 
## Exécuter le conteneur
docker run projet_docker_file

# Template Dockerfile
```sh
# Utiliser une version récente de Debian
FROM 


# Installer Apache et nettoyer les fichiers inutiles
RUN 


# Copier le fichier index.html dans le dossier web d’Apache
COPY 


# Exposer le port 80 (par défaut pour Apache)
EXPOSE 


# Définir un volume pour récupérer les logs Apache
VOLUME 


# Lancer Apache au premier plan (important pour Docker)
CMD
```