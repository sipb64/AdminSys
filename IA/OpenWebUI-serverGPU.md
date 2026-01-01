# Ubuntu 24.04 - Ollama - OpenWebUI

## Installation docker et docker compose sur ubuntu 24.04

### Supprimer les paquets conflictuels
```
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```
### Ajouter les clés GPG officielles Docker
```
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```
### Ajouter le dépot officiel dans les sources APT
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
### Installer les paquets Docker 
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
### Ajouter l'utilisateur courant dans le groupe docker
```
sudo usermod -aG docker $USER
```
### Installation de dépendance nvidia
````
sudo ubuntu-drivers install
sudo apt update
sudo apt install -y wget

sudo wget -qO /etc/apt/keyrings/nvidia-container-toolkit.asc \
  https://nvidia.github.io/libnvidia-container/gpgkey

echo "deb [signed-by=/etc/apt/keyrings/nvidia-container-toolkit.asc] https://nvidia.github.io/libnvidia-container/stable/deb/amd64 /" | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update
sudo apt install -y nvidia-container-toolkit

````
### Configuration docker pour le runtime Nvidia
````
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
````
## Compose ollama + openwebui
````
services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    restart: unless-stopped
    ports:
      - "11434:11434"
    volumes:
      - ollama:/root/.ollama
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]

  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    restart: unless-stopped
    ports:
      - "3000:8080"
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
    volumes:
      - open-webui:/app/backend/data
    depends_on:
      - ollama

volumes:
  ollama:
  open-webui:
````

## Sauvegarde et restauration des données openwebui
### Sauvegarder les données openwebui
```
docker run --rm -v open-webui:/data -v "$PWD:/backup" alpine   tar czf /backup/openwebui-backup-$(date +%Y%m%d_%H%M%S).tar.gz /data
```
### Repartir d'un volume vide
```
docker volume rm open-webui
docker volume create open-webui
```
### Restaurer l’archive dans le volume 
```
docker run --rm -v open-webui:/data -v "$PWD:/backup" alpine \
  sh -c 'tar xzf /backup/openwebui-backup-YYYYmmdd_HHMMSS.tar.gz -C /'
```