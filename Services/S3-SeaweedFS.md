# Stockage S3 - SeaweedFS
## Structure du Projet
```text
.
├── .env                     # Secrets à personnaliser (MySQL)
├── docker-compose.yml       # Orchestrateur
└── seaweedfs/
    └── s3.json
```
## 1. Configuration Environnement (.env)
```text
# === PROJET ===
PROJECT_NAME=demo_s3
S3_DOMAIN=s3.localhost
# === SEAWEEDFS S3 ===
# Identifiants S3 (Admin)
S3_ACCESS_KEY=admin
S3_SECRET_KEY=admin_password_change_me
S3_BUCKET=projet-media
S3_REGION=us-east-1
```
## 2. Configuration S3 (seaweedfs/s3.json)
```json
{
  "identities": [
    {
      "name": "admin",
      "credentials": [
        {
          "accessKey": "admin",
          "secretKey": "admin_password_change_me"
        }
      ],
      "actions": [
        "Read",
        "Write",
        "List",
        "Tagging",
        "Admin"
      ]
    }
  ]
}
```
## 3. Déploiement (docker-compose.yml)
```yaml
  seaweedfs:
    image: chrislusf/seaweedfs:4.12 # Vérifier la dernière version stable
    container_name: ${PROJECT_NAME}_seaweedfs
    restart: unless-stopped
    # Mode "server" = Master + Volume + Filer + S3 en un seul processus
    command: "server -s3 -s3.port=8333 -dir=/data -s3.config=/etc/seaweedfs/s3.json"
    volumes:
      - seaweedfs_data:/data
      - ./seaweedfs/s3.json:/etc/seaweedfs/s3.json:ro
    networks:
      - web
      - internal
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=${PROJECT_NAME}_web"
      # API S3 (Port 8333)
      - "traefik.http.routers.s3.rule=Host(`${S3_DOMAIN}`)"
      - "traefik.http.routers.s3.entrypoints=websecure"
      - "traefik.http.routers.s3.tls.certresolver=letsencrypt"
      - "traefik.http.services.s3.loadbalancer.server.port=8333"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8333/"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  seaweedfs_data:
    name: ${PROJECT_NAME}_seaweedfs_data
```

## 2. Configuration S3 (seaweedfs/s3.json)
```json
{
  "identities": [
    {
      "name": "admin",
      "credentials": [
        {
          "accessKey": "admin",
          "secretKey": "admin_password_change_me"
        }
      ],
      "actions": [
        "Read",
        "Write",
        "List",
        "Tagging",
        "Admin"
      ]
    }
  ]
}
```
## 4. Vérification (CLI AWS)
```bash
# Charger les variables
source .env

# Alias temporaire
alias aws-s3='docker run --rm -i --network ${PROJECT_NAME}_internal \
  -e AWS_ACCESS_KEY_ID=${S3_ACCESS_KEY} \
  -e AWS_SECRET_ACCESS_KEY=${S3_SECRET_KEY} \
  -e AWS_DEFAULT_REGION=${S3_REGION} \
  amazon/aws-cli --endpoint-url http://seaweedfs:8333 s3'

# Utilisation
aws-s3 ls                          # Lister les buckets (vide au début)
aws-s3 mb s3://${S3_BUCKET}        # Créer le bucket défini dans le .env
echo "Hello World" > test.txt      # Créer un fichier dummy
aws-s3 cp test.txt s3://${S3_BUCKET}/hello.txt # Upload
aws-s3 ls s3://${S3_BUCKET}/       # Vérifier l'upload
```

