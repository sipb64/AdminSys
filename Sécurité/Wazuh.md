# Wazuh SIEM/XDR - Installation All-in-One & Déploiement Agent
```
Déploiement d'un serveur Wazuh (Manager + Indexer + Dashboard) sur un nœud unique pour 1 à 25 agents.

Recommandations doc officielle 
Système : Ubuntu 24.04 LTS
Ressources : 4 vCPU, 8GiB ram, 50go SSD (pour 90 jours de données)
```
## Préparation du Serveur
### Mise à jour système
```bash
apt update && apt full-upgrade -y
apt install -y curl apt-transport-https lsb-release gnupg ufw
```
### Création utilisateur d'admin (optionnel si déjà fait)
```bash
adduser wazuh_admin && usermod -aG sudo wazuh_admin
```
### Configuration Firewall (UFW), sécurisation des ports critiques avant l'installation.
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow 443/tcp comment "Wazuh Dashboard"
sudo ufw allow 1514/tcp comment "Wazuh Agent Events"
sudo ufw allow 1515/tcp comment "Wazuh Agent Enrollment"
sudo ufw allow 55000/tcp comment "Wazuh API"
sudo ufw enable
```
## Installation Automatisée (Assistant)
### Téléchargement de l'assistant (Verifier dernière version stable 4.x)
```bash
curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh && sudo bash ./wazuh-install.sh -a
```
### À la fin de l'installation, le script affiche le mot de passe admin. Sauvegardez-le immédiatement, il n'est affiché qu'une fois.
```bash
User: admin
Password: XXXXXXXXXXXX
```
## Post-Installation & Vérifications
### Vérification des services Wazuh met quelques minutes à démarrer (surtout l'Indexer)
```bash
systemctl status wazuh-manager
systemctl status wazuh-dashboard
systemctl status wazuh-indexer
```
### Accès Web 
```
URL : https://IP_DU_SERVEUR

Login : admin / VOTRE_MOT_DE_PASSE
```
## Déploiement d'un Agent (Exemple Linux)
### Installation via le repo Wazuh
```bash
# Ajouter la clé GPG
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg

# Ajouter le dépôt
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.14/apt/ stable main" | tee /etc/apt/sources.list.d/wazuh.list

# Installer l'agent
apt update && apt install wazuh-agent
```
### Enrôlement automatique, configurer l'adresse du Manager dans la config de l'agent.
```bash
# Configurer l'IP du Manager
# WAZUH_MANAGER = IP ou FQDN du serveur Wazuh
sed -i "s/MANAGER_IP/192.168.xx.100/" /var/ossec/etc/ossec.conf

# Activer et démarrer
systemctl daemon-reload
systemctl enable --now wazuh-agent
```
### Vérification (Côté Serveur), lister les agents connectés
```bash
/var/ossec/bin/agent_control -l
```