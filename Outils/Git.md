# Git - Outils & Initialisation Projet
## 1. Raccourcis VS Code (Windows/Linux)

| Action          | Raccourci        | Correction/Note                       |
| --------------- | ---------------- | ------------------------------------- |
| Commenter       | Ctrl + /         | Commenter un bloc de code             |
| Terminal        | Ctrl + ù         | Ouvrir fermer terminal (Ctrl + ` sur clavier US)        |
| Explorer        | Ctrl + Shift + E | Ctrl+B toggle juste la barre latérale |
| Split View      | Ctrl + *         | Ctrl+* n'est pas standard             |
| Word Wrap       | Alt + Z          | (Retour ligne automatique)            |
| Dupliquer ligne | Shift + Alt + ↓  | Maj+Flèche fait une sélection         |
| Multi-selection | Shift + ↓        | Sélectionne la ligne puis la suivante |
| Multi-curseur   | Ctrl + D         | Sélectionne l'occurrence suivante     |
| Palette Cmd     | Ctrl + Shift + P | Afficher la recherde de commande      |
| Aperçu MD       | Ctrl + Shift + V | Afficher l'aperçu du fichier          |


### Astuce Markdown
#### Ajout d'images centrer et redimensionner
```xml
<p align="center">
    <img src="./image.png" alt="Description" style="width: 800px;" />
</p>
```
## 2. Workflow Git Essentiel
### Configuration initiale de l'identité
```bash
git config --global user.name "Nom"
git config --global user.email "email@exemple.com"
# Recommandé : branche principale nommée 'main'
git config --global init.defaultBranch main
```
### Cycle de vie d'une modification
```bash
# 1. Récupérer les dernières modifs du serveur
git pull origin main

# 2. Créer une branche de travail
git checkout -b feature/nouvelle-modif

# 3. Ajouter les fichiers modifiés
git add . # Ajoute tout
git add nomfichier

# 4. Sauvegarder (Commit)
git commit -m "feat: ajout du monitoring"

# 5. Envoyer sur GitHub/GitLab
git push origin feature/nouvelle-modif
```
## Fusionner la branche “modifications” à la branche principale 

git checkout main

git merge modifications
### Nettoyage (Après fusion)
```bash
# Revenir sur main
git checkout main
git pull origin main

# Supprimer la branche devenue inutile
git branch -d feature/nouvelle-modif
```
## 3. Initialisation Projet Infra
### Création de la structure du dépot Git
#### Initialiser Git depuis l'interieur du dossier du projet
```bash
git init
```
#### Cloner un projet
```bash
git clone git@github.com:usergithub/mon_projet-infra.git
cd mon_projet-infra
```
#### Structure de Dossiers Optimisée
```bash
# Création de l'arborescence
mkdir -p traefik/dynamic
mkdir -p monitoring/{grafana,prometheus,alertmanager}
mkdir -p monitoring/grafana/{dashboards,datasources,provisioning}
mkdir -p backups scripts .github/workflows

# Création des fichiers vides
touch docker-compose.prod.yml .env.example .gitignore README.md
touch traefik/{traefik.yml,acme.json} && chmod 600 traefik/acme.json
touch traefik/dynamic/dynamic.yml
touch monitoring/prometheus/prometheus.yml
touch monitoring/grafana/datasources/datasources.yml
touch monitoring/grafana/dashboards/dashboards.yml
touch scripts/{deploy.sh,healthcheck.sh} && chmod +x scripts/*.sh
```

### Gestion du .gitignore
```text
# Fichiers d'environnement (contiennent les secrets)
.env
.env.*
!.env.example  # Conserver l'exemple

# Données Docker volumes (générées localement) et Logs
*.log
/data/
/volumes/
/backups/
/traefik/acme.json  # ! Contient les clés privées SSL !

# IDE et Système
.vscode/
.idea/
.DS_Store
Thumbs.db
```
## 4. Générer des secrets (OpenSSL)
```bash
# Générer un mot de passe fort (32 chars, alphanumérique)
openssl rand -base64 24

# Générer une clé hexadécimale (souvent pour les tokens JWT)
openssl rand -hex 32
```
### Exemple de .env.example
```text
# Projet
PROJECT_NAME=mon-infra
DOMAIN=localhost

# Traefik
ACME_EMAIL=admin@example.com

# Passwords (Générés avec openssl)
GRAFANA_ADMIN_PASSWORD=change_me
POSTGRES_PASSWORD=change_me
```
