# Zabbix LTS (Server & Agent2)
```
Version : 7.0 LTS (Version LTS actuelle)
Architecture : Serveur, Front, Zabbix Agent 2 (Go)
OS : Ubuntu 24.04 LTS
DataBase : Postgresql
WebServer : Nginx
```
## Préparation du Serveur
### Mise à jour système
```bash
sudo apt update && sudo apt upgrade
```
### Configuration Locales (Requis pour Zabbix Frontend)
```bash 
sudo locale-gen fr_FR.UTF-8
```
## Installation Zabbix Server (Repository)
```bash
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb
sudo dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb
sudo apt update
```
## Installation des Paquets (server, frontend, agent)
```bash
sudo apt install zabbix-server-pgsql zabbix-frontend-php php8.3-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent2
 
# Plugins Agent 2
sudo apt install zabbix-agent2-plugin-mongodb zabbix-agent2-plugin-mssql zabbix-agent2-plugin-postgresql
```
## Configuration Base de Données (PostgreSQL)
### Création de l'utilisateur Zabbix (Entrez un mot de passe fort ici)
```bash
sudo -u postgres createuser --pwprompt zabbix
```
### Création de la base (UTF8 obligatoire)
```bash
sudo -u postgres createdb -O zabbix -E UTF8 --template=template0 zabbix
```
### Import du schéma initial
```bash
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
```
## Configuration Zabbix Server dans /etc/zabbix/zabbix_server.conf
```bash
DBPassword=MOT_DE_PASSE_DB
```
## Configuration Frontend (/etc/zabbix/nginx.conf)
```nginx
listen 8080;
server_name zabbix.mon-domaine.lan;
```
## Redémarrer et activer au boot
```bash
sudo systemctl restart zabbix-server zabbix-agent2 nginx php8.3-fpm
sudo systemctl enable zabbix-server zabbix-agent2 nginx php8.3-fpm
```
**Accès Web : http://IP_SERVEUR:8080 (Login par défaut : Admin / zabbix)**

## Déploiement Zabbix Agent 2 (Linux)
### Monitorer un client (ex: Debian 12)
```bash
wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.0+debian12_all.deb
sudo dpkg -i zabbix-release_latest_7.0+debian12_all.deb
sudo apt update
```
### Configuration Agent dans /etc/zabbix/zabbix_agent2.conf
```conf
# IP du serveur Zabbix (pour les requêtes passives)
Server=IP.DU.SRV.ZAB

# IP du serveur Zabbix (pour les checks actifs / autoregistration)
ServerActive=IP.DU.SRV.ZAB

# Nom d'hôte (Doit correspondre EXACTEMENT au nom dans l'interface Web Zabbix)
Hostname=ServeurLinux
# Astuce : 
# HostnameItem=system.hostname pour l'auto-découverte
# RefreshActiveChecks=5 (Pour accélérer les tests en dev)
```
### Activation de l'agent
```bash
sudo systemctl enable zabbix-agent2
sudo systemctl start zabbix-agent2
```
## Astuces Monitoring & Debug
### Stress Test (CPU/RAM) pour valider les déclencheurs (triggers)
```bash
# CPU : Utilise tous les coeurs pendant 10 min
stress --cpu $(nproc) --timeout 600s

# RAM : Remplit X Go de RAM pendant Y secondes
stress-ng --vm 1 --vm-bytes 4G --timeout 60s
```
### Surveillance des Processus & Réseau (Items clés)
```
Processus : proc.num[apache2] (Compte le nombre de processus apache).

Port TCP : net.tcp.service[http] (Vérifie si le port 80 répond).

Performance : net.tcp.service.perf[ssh] (Temps de réponse en secondes).
```
### Remonter les logs Système (Agent Actif requis)
```
Item Type : Zabbix agent (active)

Key : log[/var/log/syslog]

Type of information : Log

Permissions : L'utilisateur zabbix doit avoir les droits de lecture sur le fichier log (usermod -aG adm zabbix).
```