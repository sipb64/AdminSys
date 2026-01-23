# Installation Docker et Docker compose sur Ubuntu 24.04
## Préparation du Serveur
### Mise à jour Système
```bash
sudo apt update && sudo apt upgrade -y
```
### Supprimer les paquets conflictuels
```bash
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```
## Installation Docker officiel 
### Ajout de la clé GPG officielle de Docker
```bash
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```
### Ajout du dépot officiel dans les sources Apt
```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
### Installation des paquets Docker
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
### Mettre l'utilisateur courant dans le groupe docker
```bash
sudo usermod -aG docker $USER
newgrp docker
```
## Vérification
### Vérifier la version
```bash
docker compose version
```
### Lancer un conteneur de test
```bash
docker run --rm hello-world
```