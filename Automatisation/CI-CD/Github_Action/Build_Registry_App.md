# CI/CD : Build & Push Docker vers GHCR (GitHub Packages)
###  Structure des fichiers
```text
mon_app/
├── .github/
│    └── workflows
│        └── build-push.yml
├── Dockerfile
└── index.html   
```
## Workflow dans .github/workflows/build-push.yml
```text
Ce workflow se déclenche sur chaque push vers main. Il fait :
- 1 : Build de l'image Docker.
- 2 : Test de l'image (vérifier qu'elle démarre, qu'Apache répond).
- 3 : Tag avec plusieurs versions (latest, SHA du commit, n° version).
- 4 : Push vers GitHub Container Registry (GHCR).
```
```yaml
name: Build and Push to GHCR

on:
  push:
    branches: [ main ]
  workflow_dispatch:

env:
  REGISTRY: ghcr.io

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Normalisation du nom de l'image (Minuscules)
        run: |
          echo "IMAGE_NAME=$(echo ${{ github.repository }} | tr '[:upper:]' '[:lower:]')" >> $GITHUB_ENV
      
      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata (tags, labels)
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=raw,value=latest,enable={{is_default_branch}}
            type=sha,prefix=,format=long

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Test image
        run: |
          docker run -d --name test-container -p 8080:80 ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
          sleep 5
          curl -f http://localhost:8080 || exit 1
          docker stop test-container
```
### Exemple (serveur web)
#### Créer un Dockerfile
```Dockerfile
# Image légère (Alpine Linux)
FROM httpd:2.4-alpine

# Métadonnées (Bonne pratique)
LABEL maintainer="Ton Nom <ton@email.com>"
LABEL version="1.0"
LABEL description="Serveur Web Apache basique"

# Copie des sources
COPY index.html /usr/local/apache2/htdocs/

# Santé du conteneur (Healthcheck)
HEALTHCHECK --interval=30s --timeout=5s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1

EXPOSE 80
```
#### Creer un index.html
```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apache sur Docker</title>
    <style>
        body { font-family: system-ui, -apple-system, sans-serif; background: #f0f2f5; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); text-align: center; max-width: 400px; }
        h1 { color: #2563eb; margin-bottom: 0.5rem; }
        .badge { background: #dbeafe; color: #1e40af; padding: 4px 12px; border-radius: 99px; font-size: 0.875rem; font-weight: 500; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🚀 It Works!</h1>
        <p>Container ID: <script>document.write(window.location.hostname)</script></p>
        <span class="badge">GHCR + Actions</span>
    </div>
</body>
</html>
```
#### Build local racine du projet
```bash
## Construire l'image Docker
docker build -t siteweb .
## Vérifier que l'image a bien été créée
docker images
## Lancer le container en détaché sur le port 8080 et log /var/log/apache2 dans log
docker run -d -p 8080:80 -v ~/siteweb/log:/var/log/apache2 siteweb
```