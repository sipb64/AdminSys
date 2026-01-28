# Clé de deploiement Github Action

## Passer en tant qu'utilisateur deploy
```bash
sudo su - deploy
```

## Générer une clé SSH sur le VPS
```bash
ssh-keygen -t ed25519 -C "vm-mon_projet" -f ~/.ssh/github_mon_projet -N ""
```

## Autoriser la clé publique pour la connexion
```bash
cat ~/.ssh/github_mon_projet.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## Afficher la clé privée à copier dans GitHub Secrets
```bash
cat ~/.ssh/github_mon_projet
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

## Cloner le dépôt
```bash
git clone git@github.com:ethiksys/mon_projet.git /opt/mon_projet
```

## Secrets variables Action
```text
VPS_IP = IP du VPS

VPS_USER = utilisateur de déploiement du VPS

VPS_SSHPRIVE = clé privé de l'utilisateur du de déploiement du VPS
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
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Copie des fichiers via SCP
        uses: appleboy/scp-action@master
        with:
          host: ${{ secrets.VPS_IP }} # ip publique de l'hote
          username: ${{ secrets.VPS_USER }} ## user reservé à l'app
          key: ${{ secrets.VPS_SSHPRIVE }} ## Clé id_rsa avec id_rsa.pub dans autorised_keys sur hote
          source: "."
          target: "/home/${{ secrets.VPS_USER }}/" # Dossier cible sur le VPS
          strip_components: 0

      - name: Execute Deploy Script
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.VPS_IP }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSHPRIVE }}
          script: |
            # cd ~/app
            chmod +x scripts/deploy.sh
            ./scripts/deploy.sh
```
## Gestion des variables

