# Création de la structure du dépot Git
## Cloner le repo 
```bash
git clone git@github.com:ethiksys/mon_projet-infra.git
cd mon_projet-infra
```
## Créer la structure de dossiers
```bash
mkdir -p traefik/dynamic
mkdir -p monitoring/grafana/dashboards
mkdir -p monitoring/grafana/datasources
mkdir -p monitoring/grafana/dashboards
mkdir -p backup
mkdir -p scripts
mkdir -p .github/workflows
```
## Créer les fichiers vides
```bash
touch docker-compose.prod.yml
touch .env.example
touch .gitignore
touch README.md
touch traefik/traefik.yml
touch traefik/dynamic/dynamic.yml
touch monitoring/prometheus.yml
touch monitoring/grafana/datasources/datasources.yml
touch monitoring/grafana/dashboards/dashboards.yml
touch backup/backup.sh
touch scripts/deploy.sh
touch scripts/healthcheck.sh
touch .github/workflows/deploy.yml
```
## Paramétrage du gitignore [gitignore](/.gitignore)
```text
# Fichiers d'environnement (contiennent les secrets)
.env
.env.local
.env.*.local

# Données Docker volumes (générées localement)
data/
volumes/

# Logs
*.log
logs/

# Fichiers de backup (trop volumineux)
backup/*.sql
backup/*.sql.gz
backup/*.dump

# Fichiers système
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Certificats SSL/TLS (générés par Traefik)
traefik/acme.json
traefik/letsencrypt/
```
## Gestion des secrets (à mettre dans Github secrets)

### Générer 3 secrets pour JWT
```bash
echo "JWT_SECRET=$(openssl rand -base64 32)"
echo "JWT_REFRESH_SECRET=$(openssl rand -base64 32)"
echo "FINGERPRINT_SECRET=$(openssl rand -base64 32)"
```

### Générer mot de passe PostgreSQL
```bash
echo "POSTGRES_PASSWORD=$(openssl rand -base64 24)"
```

### Générer mot de passe Redis
```bash
echo "REDIS_PASSWORD=$(openssl rand -base64 24)"
```

### Générer clé Typesense
```bash
echo "TYPESENSE_API_KEY=$(openssl rand -base64 32)"
```
