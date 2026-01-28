# Nginx Reverse Proxy & Load Balancer (DEBIAN 12 LXC) 
## Installation
```bash
apt update && apt full-upgrade -y && apt install nginx -y
systemctl enable --now nginx
```

## Configuration Reverse Proxy SSL /etc/nginx/sites-available/app.exemple.com.conf
```nginx
# Redirection HTTP -> HTTPS
server {
    listen 80;
    server_name app.exemple.com;
    return 301 https://$host$request_uri;
}

# Configuration HTTPS
server {
    listen 443 ssl http2; # HTTP/2 pour la perf
    server_name app.exemple.com;

    # Certificats (Chemins standards Debian)
    ssl_certificate     /etc/ssl/certs/app-bundle.crt;
    ssl_certificate_key /etc/ssl/private/app.key.pem;

    # Logs dédiés
    access_log /var/log/nginx/app-access.log;
    error_log  /var/log/nginx/app-error.log;

    location / {
        proxy_pass http://IP_INTERNE_SERVICE:PORT;
        
        # Headers essentiels pour que l'app backend connaisse le client réel
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Support WebSocket (si besoin)
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

## Load Balancing (Répartition de charge) /etc/nginx/sites-available/cluster.conf
```nginx
# Définition du groupe de serveurs
upstream backend_cluster {
    # Algorithme (Décommenter un choix)
    # ip_hash;      # Session Sticky (Même IP client -> Même serveur)
    # least_conn;   # Vers le serveur le moins chargé
    
    # Liste des nœuds
    server 192.168.0.91:80 weight=3; # Poids x3 (reçoit plus de trafic)
    server 192.168.0.92:80;
    server 192.168.0.93:80 down;     # Marqué hors-service (maintenance)
}

server {
    listen 443 ssl http2;
    server_name cluster.exemple.com;

    ssl_certificate     /etc/ssl/certs/wildcard-bundle.crt;
    ssl_certificate_key /etc/ssl/private/wildcard.key;

    location / {
        proxy_pass http://backend_cluster;
        
        # Headers Proxy Standards
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
## Activation et test
### Créer le lien symbolique
```bash
ln -s /etc/nginx/sites-available/app.exemple.com.conf /etc/nginx/sites-enabled/
```
### Tester la syntaxe (Important)
```bash
nginx -t
```
### Recharger pour ne pas couper les connexions
```bash
systemctl reload nginx
```
