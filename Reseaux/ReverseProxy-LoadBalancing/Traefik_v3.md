# Traefik v3 - Configuration Complète (Docker + Let's Encrypt)

## 1. Exemple de déploiement Docker Compose avec socket proxy
```yaml
services:
  # ==============================================
  # REVERSE PROXY - TRAEFIK
  # ==============================================
  # Proxy pour sécuriser le socket Docker
  socket-proxy:
    image: tecnativa/docker-socket-proxy
    container_name: socket-proxy
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      CONTAINERS: 1 # Autorise de lister les conteneurs
    networks:
      - internal

traefik:
    image: traefik:v3
    container_name: ${PROJECT_NAME}_traefik
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    ports:
      - "80:80"     # HTTP
      - "443:443"   # HTTPS
      - "8080:8080" # Dashboard (à protéger)
    environment:
      - TZ=Europe/Paris
      - TRAEFIK_CERTIFICATESRESOLVERS_LETSENCRYPT_ACME_EMAIL=${LETSENCRYPT_EMAIL}
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    volumes:
#      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./traefik/traefik.yml:/traefik.yml:ro
      - ./traefik/dynamic:/dynamic:ro
      - traefik_certificates:/certificates
    networks:
      - web
      - internal
    labels:
      - "traefik.enable=true"
      # Dashboard
      - "traefik.http.routers.traefik.rule=Host(`traefik.${DOMAIN}`)"
      - "traefik.http.routers.traefik.entrypoints=websecure"
      - "traefik.http.routers.traefik.tls.certresolver=letsencrypt"
      - "traefik.http.routers.traefik.service=api@internal"
      - "traefik.http.routers.traefik.middlewares=traefik-auth"
      # Basic Auth pour dashboard
      - "traefik.http.middlewares.traefik-auth.basicauth.users=${TRAEFIK_DASHBOARD_USER}:${TRAEFIK_DASHBOARD_PASSWORD}"

  grafana:
    image: grafana/grafana:latest
    container_name: ${PROJECT_NAME}_grafana
    restart: unless-stopped
    environment:
      GF_SECURITY_ADMIN_USER: ${GRAFANA_ADMIN_USER}
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_ADMIN_PASSWORD}
      GF_INSTALL_PLUGINS: grafana-clock-panel
    volumes:
      - grafana_data:/var/lib/grafana
      - ./monitoring/grafana:/etc/grafana/provisioning:ro
    depends_on:
      - prometheus
    networks:
      - web
      - internal
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=${PROJECT_NAME}_web"
      - "traefik.http.routers.grafana.rule=Host(`grafana.${DOMAIN}`)"
      - "traefik.http.routers.grafana.entrypoints=websecure"
      - "traefik.http.routers.grafana.tls=true"
      - "traefik.http.routers.grafana.tls.certresolver=letsencrypt"
      - "traefik.http.services.grafana.loadbalancer.server.port=3000"
```
## 2. A personnalisation de la configuration de Traefik
### Structure des fichiers
```text
mon_projet_infra
└── traefik
    ├── dynamic
    │   └── dynamic.yml
    └── traefik.yml
```
### Modifier fichier de [configuration traefik](/traefik/traefik.yml)

#### Pour test décommenter pour utiliser le serveur de staging Let's Encrypt (génère des certificats de test) :
```yaml
caServer: "https://acme-staging-v02.api.letsencrypt.org/directory"
```
```yaml
# ==============================================
# TRAEFIK CONFIGURATION STATIQUE
# ==============================================

# API et Dashboard (Désactivé en insecure pour la prod)
api:
  dashboard: true
  insecure: false

# Points d'entrée (ports)
entryPoints:
  web:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: websecure
          scheme: https
          permanent: true
  
  websecure:
    address: ":443"
    http:
      tls:
        certResolver: letsencrypt
      # Appliquer les middlewares de sécurité par défaut sur tout le HTTPS
      middlewares:
        - security-headers@file

# Providers (découverte automatique des services)
providers:
  docker:
    endpoint: "tcp://socket-proxy:2375"
    # endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
    # network: ${PROJECT_NAME}_web
    network: web
  file:
    directory: /dynamic
    watch: true

# Certificats SSL Let's Encrypt
certificatesResolvers:
  letsencrypt:
    acme:
      email: ethiksys@ik.me  # Change avec ton vrai email
      storage: /certificates/acme.json
      # Pour tests : utilise le staging (pas de limite de rate)
      caServer: "https://acme-staging-v02.api.letsencrypt.org/directory"
      # Option 1: HTTP-01 (Port 80 requis)
      httpChallenge:
        entryPoint: web
      # Option 2: TLS-ALPN-01 (Port 443 seul suffisant)
      # tlsChallenge: {}


# Logs
log:
  level: INFO
  format: json

accessLog:
  format: json
  fields:
    defaultMode: keep
    headers:
      defaultMode: drop
```

## 3. [Configuration dynamique](/traefik/dynamic/dynamic.yml) (middlewares, headers sécurité)

```yaml
# ==============================================
# CONFIGURATION DYNAMIQUE TRAEFIK
# ==============================================

http:
  # 1. Middlewares Réutilisables
  middlewares:
    # Sécurité HSTS & Headers
    security-headers:
      headers:
        frameDeny: true
        browserXssFilter: true
        contentTypeNosniff: true
        forceSTSHeader: true
        stsIncludeSubdomains: true
        stsPreload: true
        stsSeconds: 31536000
        customFrameOptionsValue: "SAMEORIGIN"
    
    # Rate limiting (anti-DDoS basique)
    rate-limit:
      rateLimit:
        average: 100
        burst: 50
        period: 1s

    # Authentification (Basic Auth)
    # Générer avec : echo $(htpasswd -nb admin monpassword)
    # Attention aux doubles $$ pour docker-compose
    admin-auth:
      basicAuth:
        users:
          - "admin:$apr1$xyz..." # Remplacer par le hash généré

  # 2. Sécurisation du Dashboard Traefik
  routers:
    dashboard:
      rule: "Host(`traefik.mon-domaine.com`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))"
      service: api@internal
      middlewares:
        - admin-auth
        - security-headers
      tls:
        certResolver: letsencrypt
```
## 4. Générer le mot de passe
## Utiliser htpasswd et génèrer le hash pour le user "admin" avec le mot de passe et le mettre dans le .env 
```bash
sudo apt install -y apache2-utils
# (doubler les $ du hash ex: admin:$$apr1$$xyz123)
htpasswd -nb admin tonmotdepasse
```
