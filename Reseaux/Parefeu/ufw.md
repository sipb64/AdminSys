# UFW - Configuration Pare-feu (Commandes de bases)

## 1. Installation & Sécurité par défaut
### **Toujours configurer ces règles AVANT d'activer le pare-feu pour ne pas s'enfermer dehors (SSH).**
```bash
# 1. Installation
sudo apt update && sudo apt install -y ufw

# 2. Politique par défaut (Tout bloquer en entrée, tout autoriser en sortie)
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 3. Autoriser SSH (Critique !)
# Si port standard (22)
sudo ufw allow ssh
# Si port personnalisé (ex: 6464)
sudo ufw allow 6464/tcp comment 'SSH Custom Port'

# 4. Activation
sudo ufw enable
```

## 2. Gestion des Services Standards

```bash
# Web (HTTP/HTTPS)
sudo ufw allow 80/tcp  comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Ou via le nom de l'application (si détectée)
sudo ufw app list
sudo ufw allow 'Nginx Full'
```

## 3. Règles Avancées (Whitelisting IP/Subnet)

```bash
# Autoriser une IP spécifique (ex: Bureau Admin)
sudo ufw allow from 203.0.113.4 to any port 22

# Autoriser un sous-réseau entier (ex: VPN ou LAN)
sudo ufw allow from 192.168.5.0/24 comment 'VPN Subnet'

# Autoriser un port spécifique pour un réseau spécifique (ex: PostgreSQL interne)
sudo ufw allow from 10.0.0.0/24 to any port 5432
```

## 4. Maintenance & Debug

```bash
# Vérifier le statut et les règles actives (avec numéros)
sudo ufw status numbered

# Supprimer une règle par son numéro (ex: règle n°4)
sudo ufw delete 4

# Supprimer une règle par sa définition
sudo ufw delete allow 80/tcp

# Désactiver le pare-feu (Urgence)
sudo ufw disable

# Réinitialiser toutes les règles (Factory Reset)
sudo ufw reset
```

## 5. Logs (Audit)
```bash
# Activer les logs (écrit dans /var/log/ufw.log)
sudo ufw logging on

# Niveau de log (low, medium, high)
sudo ufw logging medium
```
