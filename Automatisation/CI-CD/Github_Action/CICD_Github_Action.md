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

# 3. Afficher la clé privée (COPIER TOUT -----BEGIN à -----END)
cat ~/.ssh/github_action
```
## 2. Configuration GitHub (Secrets)
### Dans le dépôt GitHub : Settings > Secrets and variables > Actions > New repository secret.
| Nom du Secret | Valeur                                                     |
| ------------- | ---------------------------------------------------------- |
| VPS_IP        | IP du serveur (ex: 123.45.67.89)             |
| VPS_USER      | deploy                                                     |
| VPS_SSH_KEY   | Coller contenu de la clé PRIVÉE  |
| VPS_PORT      | 6464 (Si le port SSH à été changé)   |

## 3. Pipeline (.github/workflows/deploy.yml)
```yaml
name: Déploiement en production

on:
  push:
    branches: [ "main" ]
  workflow_dispatch: # Permet de lancer manuellement

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: 1. Récupération du code
        uses: actions/checkout@v4

      - name: 2. Copie des fichiers vers le serveur
        uses: appleboy/scp-action@master
        with:
          host: ${{ secrets.VPS_IP }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          port: ${{ secrets.VPS_PORT || 22 }} # Gère le port SSH custom
          source: "." # Copie tout le repo
          target: "/home/${{ secrets.VPS_USER }}/app" # Dossier cible propre
          strip_components: 0
          overwrite: true

      - name: 3. Exécution du Script de Déploiement
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.VPS_IP }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          port: ${{ secrets.VPS_PORT || 22 }}
          # On injecte les secrets ENV directement ici pour reconstruire le .env
          script_stop_on_error: true
          envs: GRAFANA_PWD,TRAEFIK_EMAIL # Liste des variables à passer du secret GitHub vers le script
          script: |
            cd /home/${{ secrets.VPS_USER }}/app
            
            # (Optionnel) Recréer le .env si tu stockes tes secrets de prod dans GitHub
            # echo "GRAFANA_ADMIN_PASSWORD=${{ secrets.GRAFANA_PASSWORD }}" > .env
            # echo "ACME_EMAIL=${{ secrets.ACME_EMAIL }}" >> .env
            
            # Lancer le script de déploiement
            chmod +x scripts/deploy.sh
            ./scripts/deploy.sh
```
## 4. Script de Déploiement (scripts/deploy.sh)



## Copier cette clé publique et l'ajouter comme Deploy Key dans le dépôt GitHub (Settings > Deploy keys > Add deploy key).Puis :
```bash
cat >> ~/.ssh/config << EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_mon_projet
EOF
```


## Exemple de [pipeline.yaml](/.github/workflows/deploy.yml) Github Action 
```yaml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

```

