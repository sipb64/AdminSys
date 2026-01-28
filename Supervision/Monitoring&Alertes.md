# Monitoring et alertes - Configuration Complète (Docker, Grafana, Prometheus, cAdvisor, node_exporter, alertmanager)
###  Structure des fichiers
```text
mon_projet_infra/
├── docker-compose.yml
└── monitoring
    ├── grafana
    │   ├── dashboards       <-- Fichiers JSON des tableaux de bord ici
    │   |── datasources
    │   |    └──datasources.yml
    │   └── provisioning     <-- Fichiers de config de provision
    │       └── dashboards.yml
    ├── alertmanager
    │   └── config.yml       <-- Config des notifications (Email/Slack...)
    └── prometheus
        │── alert_rules.yml  <-- Règles de déclenchement (CPU, Disk, Down...)
        └── prometheus.yml
```
## 1. Exemple de déploiement Docker Compose
```yaml
  # ==============================================
  # MONITORING - PROMETHEUS (Collecte)
  # ==============================================
  prometheus:
    image: prom/prometheus:latest
    container_name: ${PROJECT_NAME}_prometheus
    restart: unless-stopped
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=15d'
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    networks:
      - internal
    # labels:
    #   - "traefik.enable=true"
    #   - "traefik.http.routers.prometheus.rule=Host(`prometheus.${DOMAIN}`)"
    #   - "traefik.http.routers.prometheus.entrypoints=websecure"
    #   - "traefik.http.routers.prometheus.tls=true"
    #   - "traefik.http.routers.prometheus.tls.certresolver=letsencrypt"
    #   - "traefik.http.services.prometheus.loadbalancer.server.port=9090"
   
    # Ne pas exposé publiquement, uniquement pour Grafana

  # ==============================================
  # MONITORING - GRAFANA (Visualisation)
  # ==============================================
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

  # ==============================================
  # MONITORING - cAdvisor (Métriques Containers)
  # ==============================================
  cadvisor:
    # image: gcr.io/cadvisor/cadvisor:v0.52.1
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: ${PROJECT_NAME}_cadvisor
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    # Seulement pour test
    # ports:
    #   - "8081:8080"
    networks:
      internal: null
    restart: unless-stopped


  # ==============================================
  # MONITORING - node_exporter (Métriques Serveur)
  # ==============================================
  node_exporter:
    image: prom/node-exporter:latest
    container_name: ${PROJECT_NAME}_node_exporter
    pid: host 
    command:
      - '--path.rootfs=/host'
    volumes:
      - /:/host:ro,rslave
    # Seulement pour test
    # ports:
    #   - "9100:9100"
    networks:
      internal: null
    restart: unless-stopped

  # ==============================================
  # MONITORING - Alertmanager (Alertes Serveur)
  # ==============================================
  alertmanager:
    image: prom/alertmanager:latest
    container_name: ${PROJECT_NAME}_alertmanager
    restart: unless-stopped
    command:
      - '--config.file=/etc/alertmanager/config.yml'
      - '--storage.path=/alertmanager'
    volumes:
      - ./monitoring/alertmanager/config.yml:/etc/alertmanager/config.yml:ro
      - alertmanager_data:/alertmanager
    networks:
      - internal
    #   - web # Nécessaire si tu veux accéder à l'UI via Traefik
    # labels:
    #   - "traefik.enable=true"
    #   - "traefik.docker.network=${PROJECT_NAME}_web"
    #   - "traefik.http.routers.alertmanager.rule=Host(`alertes.${DOMAIN}`)"
    #   - "traefik.http.routers.alertmanager.entrypoints=websecure"
    #   - "traefik.http.routers.alertmanager.tls.certresolver=letsencrypt"
    #   - "traefik.http.services.alertmanager.loadbalancer.server.port=9093"

# ==============================================
# NETWORKS
# ==============================================
networks:
  web:
    name: ${PROJECT_NAME}_web
    driver: bridge
  internal:
    name: ${PROJECT_NAME}_internal
    driver: bridge
    internal: true

# ==============================================
# VOLUMES PERSISTANTS
# ==============================================
volumes:
  prometheus_data:
    name: ${PROJECT_NAME}_prometheus_data
  grafana_data:
    name: ${PROJECT_NAME}_grafana_data
  alertmanager_data:
    name: ${PROJECT_NAME}_alertemanager_data
```
## 2. Personnalisation de la configuration de Prometheus
### Configuration prometheus.yml (/monitoring/prometheus.yml)
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

# 1. Configuration de l'Alerting
alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager:9093'] # Nom du service Docker

# 2. Chargement des règles
rule_files:
  - "/etc/prometheus/alert_rules.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['node_exporter:9100']
```
## 3. Personnalisation de la configuration de Grafana 
### Configuration des sources dans datasources.yml (/monitoring/grafana/datasources/datasources.yml)
```yaml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false
```

### Configuration des sources de provision dans dashboards.yml (/monitoring/grafana/provisioning/dashboards.yml)
```yaml
apiVersion: 1
providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /etc/grafana/provisioning/dashboards
```

### Proposition de dashboard à placer dans le dossier (/monitoring/grafana/dashboard)
- 193 - [Docker monitoring](https://grafana.com/grafana/dashboards/193-docker-monitoring/) (à importer manuellement si la source ne se charge pas coreectement)
- 1860 - [Node Exporter Full](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)

## 4. Gestion des alertes via alert manager
### Configuration d'Alertmanager (monitoring/alertmanager/config.yml)
```yaml
global:
  resolve_timeout: 5m
  # Config SMTP globale (à adapter)
  smtp_smarthost: 'smtp.ton-provider.com:587'
  smtp_from: 'alertmanager@ton-domaine.com'
  smtp_auth_username: 'ton-user'
  smtp_auth_password: 'ton-password'
  smtp_require_tls: true

route:
  group_by: ['alertname', 'job']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  receiver: 'email-admin' # Destinataire par défaut

receivers:
  - name: 'email-admin'
    email_configs:
      - to: 'ton-email@k-u.fr'
        send_resolved: true # Envoie un mail quand c'est résolu
        headers:
          Subject: "🔥 Alerte Infra: {{ .CommonAnnotations.summary }}"

  # Exemple pour plus tard (Slack/Discord/Telegram)
  # - name: 'slack-notifications'
  #   slack_configs:
  #     - api_url: 'https://hooks.slack.com/services/...'
  #       channel: '#monitoring'
```
### Création des Règles d'Alerte (monitoring/prometheus/alert_rules.yml)
```yaml
groups:
  - name: general_rules
    rules:
      # 1. Instance Down : Si un job (node_exporter, cadvisor) ne répond plus
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "L'instance {{ $labels.instance }} est down"
          description: "Le job {{ $labels.job }} ne répond plus depuis 1 minute."

      # 2. Host High CPU : CPU > 80% pendant 5 min
      - alert: HostHighCpuLoad
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[2m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Charge CPU élevée sur {{ $labels.instance }}"

      # 3. Host Low Disk Space : Moins de 10% d'espace libre
      - alert: HostOutOfDiskSpace
        expr: (node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes < 10 and ON (instance, device, mountpoint) node_filesystem_readonly == 0
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "Espace disque faible sur {{ $labels.instance }}"
          description: "Il reste moins de 10% sur {{ $labels.mountpoint }}."
```



