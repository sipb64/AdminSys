# CI/CD : Déploiement Automatisé avec GitHub Actions

## 1. Préparation du serveur (Utilisateur deploy)
```bash
# Se connecter en user deploy
sudo su - deploy

# 1. Générer la paire de clés (sans passphrase !)
ssh-keygen -t ed25519 -C "github-action-deploy" -f ~/.ssh/github_action -N ""

# 2. Autoriser cette clé à se connecter au VPS
cat ~/.ssh/github_action.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
cat >> ~/.ssh/config << EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_action
EOF
# 3. Afficher la clé privée (COPIER TOUT -----BEGIN à -----END)
cat ~/.ssh/github_action
```
## 2. Configuration GitHub (Secrets)
### Dans le dépôt GitHub : Settings > Secrets and variables > Actions > New repository secret.
| Nom du Secret | Valeur                                                     |
| ------------- | ---------------------------------------------------------- |
| VPS_IP        | IP du serveur (ex: 123.45.67.89)                           |
| VPS_USER      | deploy                                                     |
| VPS_SSH_KEY   | Coller contenu de la clé PRIVÉE                            |
| VPS_PORT      | 6464 (Si le port SSH à été changé)                         |

## 3. Pipeline (.github/workflows/deploy.yml)
```yaml
name: Déploiement en production

on:
  push:
    branches: [ "main" ]
  workflow_dispatch: 

env:
  TARGET_DIR: "/home/${{ secrets.VPS_USER }}/app" # Définition du dossier cible

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:

      - name: 1. Récupération du code
        uses: actions/checkout@v4

      - name: 2. Transfert des fichiers (SCP)
        uses: appleboy/scp-action@master
        with:
          host: ${{ secrets.VPS_IP }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          port: ${{ secrets.VPS_PORT || 22 }} # Pour gerer le port SSH custom
          source: "." # Copie tout le repo
          target: ${{ env.TARGET_DIR }}
          # Exclure le dossier .git et .github pour ne pas polluer le serveur
          rm: true # Nettoie le dossier cible avant copie (attention aux fichiers persistants non-volumes !)
          strip_components: 0
          overwrite: true

      - name: 3. Configuration et Lancement du déploiement
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.VPS_IP }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          port: ${{ secrets.VPS_PORT || 22 }}
          # Injection des secrets ENV directement pour reconstruire le .env
          #script_stop_on_error: true
          #: GRAFANA_PWD,TRAEFIK_EMAIL # Liste des variables à passer du secret GitHub vers le script
          script: |
            cd ${{ env.TARGET_DIR }}
            
            # --- A. Génération du fichier .env sécurisé ---
            echo "Génération du fichier .env..."
            cat > .env <<EOF
            # Infrastructure
            DOMAIN=${{ secrets.DOMAIN }}
            FRONTEND_DOMAIN=${{ secrets.FRONTEND_DOMAIN }}
            TRAEFIK_DASHBOARD_USER=${{ secrets.TRAEFIK_USER }}
            TRAEFIK_DASHBOARD_PASSWORD=${{ secrets.TRAEFIK_PASSWORD }}
            LETSENCRYPT_EMAIL=${{ secrets.LETSENCRYPT_EMAIL }}

            # Base de données
            POSTGRES_USER=${{ secrets.POSTGRES_USER }}
            POSTGRES_PASSWORD=${{ secrets.POSTGRES_PASSWORD }}
            POSTGRES_DB=${{ secrets.POSTGRES_DB }}
            
            # Cache & Search
            REDIS_PASSWORD=${{ secrets.REDIS_PASSWORD }}
            TYPESENSE_API_KEY=${{ secrets.TYPESENSE_API_KEY }}

            # App (Backend/Frontend)
            JWT_SECRET=${{ secrets.JWT_SECRET }}
            NODE_ENV=production
            EOF
            
            # Sécurisation du fichier .env
            chmod 600 .env

            # --- B. Lancement du déploiement ---
            echo "Lancement du script de déploiement..."
            chmod +x scripts/deploy.sh
            ./scripts/deploy.sh
```
## Copier cette clé publique et l'ajouter comme Deploy Key dans le dépôt GitHub (Settings > Deploy keys > Add deploy key).Puis :
```bash
cat >> ~/.ssh/config << EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_mon_projet
EOF
```
## 4. Script de Déploiement (scripts/deploy.sh)
```sh
#!/bin/bash
# scripts/deploy.sh

# Arrêt sur erreur
set -e

echo "Démarrage du déploiement..."

# 1. Pull des dernières images
echo "Téléchargement des images..."
docker compose -f docker-compose.yml pull

# 2. Update des conteneurs (recreation uniquement si changés)
echo "Mise à jour des services..."
docker compose -f docker-compose.yml up -d --remove-orphans

# 3. Nettoyage des images inutilisées
echo "Nettoyage..."
docker image prune -f

echo "Déploiement terminé avec succès !"
```
