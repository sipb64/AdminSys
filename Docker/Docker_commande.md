# Docker & Docker Compose - Commande de base
## Registre (Docker Hub) connexion pour pousser/tirer des images privées.
```bash
docker login
```
## Gestion des Conteneurs

| Action | Commande |
| :-- | :-- |
| Lister (Actifs) | `docker ps` |
| Lister (Tous) | `docker ps -a` |
| Démarrer | `docker start <ID>` |
| Arrêter | `docker stop <ID>` |
| Supprimer | `docker rm <ID>` |
| Shell Interactif (Nouveau) | `docker run -it --rm <image> /bin/bash` |
| Shell Interactif (Existant) | `docker exec -it <ID> /bin/bash` |
| Nettoyage (Arrêtés) | `docker container prune` |

## Gestion des Images

| Action | Commande |
| :-- | :-- |
| Lister | `docker images` |
| Télécharger | `docker pull <image>` |
| Supprimer | `docker rmi <image_id>` |
| Nettoyage (Obsolètes) | `docker image prune` |

## Gestion des Volumes (Persistance)

| Action | Commande |
| :-- | :-- |
| Lister | `docker volume ls` |
| Créer | `docker volume create <nom>` |
| Supprimer | `docker volume rm <nom>` |
| Nettoyer (Inutilisés) | `docker volume prune` |

## Gestion des Réseaux

| Action | Commande |
| :-- | :-- |
| Lister | `docker network ls` |
| Créer  | `docker network create <nom>` |
| Connecter à chaud | `docker network connect <nom> <ID>` |
| Déconnecter | `docker network disconnect <nom> <ID>` |
| Supprimer | `docker network rm <nom>` |
| Créer un bridge personnalisé | `docker network create --driver bridge <nom>` |
| Créer un réseau overlay (Swarm) | `docker network create --driver overlay <nom> <ID>` |
| Inspecter (IP, DNS) | `docker network inspect <nom>` |

## Docker Compose

| Action | Commande |
| :-- | :-- |
| Démarrer (Détaché) | `docker compose up -d` |
| Arrêter \& Supprimer | `docker compose down` |
| Voir les logs (Suivi) | `docker compose logs -f` |
| Lister les services | `docker compose ps` |

## Monitoring & Debug

| Action | Commande |
| :-- | :-- |
| Logs en direct | `docker logs -f <ID>` |
| Ressources (CPU/RAM) | `docker stats` |
| Inspecter la config JSON (IP, Mounts...) | `docker inspect <ID>` |
| Supprime tout ce qui n'est pas utilisé| `docker system prune -a --volumes` |
```bash
# Grand nettoyage (Attention : supprime tout ce qui n'est pas utilisé)
docker system prune -a --volumes
```

## Lab Express : Serveur Web Apache pour tester le port forwarding et la modification à chaud

### Lancement
```bash
# Port hôte 8080 -> Port conteneur 80
docker run -d -p 8080:80 --name mon-apache httpd:alpine
```
> - -d : détachez le conteneur du processus principal de la console
> - -p 8080:80 : transfère le trafic du port 8080 vers le port 80 du conteneur
> - --name : attribuez un nom personnalisé
> - httpd : image à utiliser (docker la pull si nécessaire)
> - Vérification -> `http://IP:8080`

### Modification du contenu (Live)
```bash
# Entrer dans le conteneur
docker exec -it mon-apache sh

# (Dans le conteneur) Modifier l'index
echo "<h1>Site modifié à chaud !</h1>" > /usr/local/apache2/htdocs/index.html
exit
```

> - Rafraîchir la page.

### Nettoyage
```bash
docker stop mon-apache && docker rm mon-apache
```


