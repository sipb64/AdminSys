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

