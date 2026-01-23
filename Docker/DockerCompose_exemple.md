# Docker Compose - Projet Exemple (LAMP)
## Structure du Projet
```bash
mon-projet/
├── docker-compose.yml       # Orchestrateur
└── web/
    ├── Dockerfile           # Construction de l'image Web custom
    └── index.html           # Code source
```
## Définition de l'Image Web (web/Dockerfile)
```
FROM httpd:2.4-alpine
COPY ./index.html /usr/local/apache2/htdocs/
```
## Fichier docker-compose.yml
```sh
services:
  # Service Frontend (construit depuis le dossier ./web)
  webapp:
    build: ./web
    container_name: mon-site-web
    restart: unless-stopped
    ports:
      - "80:80"
    networks:
      - backend-network
    depends_on:
      - database

  # Service Backend (Base de données)
  database:
    image: mysql:8.0  # Toujours fixer une version majeure !
    container_name: ma-bdd
    restart: unless-stopped
    networks:
      - backend-network
    environment:
      MYSQL_DATABASE: site
      MYSQL_ROOT_PASSWORD: motdepassefort
      MYSQL_USER: monuser
      MYSQL_PASSWORD: monpassword
    volumes:
      - db_data:/var/lib/mysql

# Réseaux (Isolation)
networks:
  backend-network:

# Volumes (Persistance)
volumes:
  db_data:

```
## Commandes de gestion
| Action                      | Commande                     |
| --------------------------- | ---------------------------- |
| Construire & Démarrer       | docker compose up -d --build |
| Voir les logs               | docker compose logs -f       |
| Arrêter & Supprimer         | docker compose down          |
| Arrêter + Supprimer Volumes | docker compose down -v       |