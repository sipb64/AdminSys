# Sécurisation Initiale Serveur Linux (Debian/Ubuntu)

## 1. Mise à jour & Utilisateur (ex : Déploiement)
```bash
# Mise à jour système
sudo apt update && sudo apt full-upgrade -y

# Création utilisateur 'deploy' (sans mot de passe, accès clé SSH uniquement)
sudo adduser --disabled-password --gecos "" deploy

# Ajout aux groupes sudo et docker
sudo usermod -aG sudo,docker deploy

## Ajouter un utilisateur de deploiement (non root)
sudo usermod -aG docker deploy

# (Optionnel) Copier la clé SSH root vers deploy pour ne pas perdre l'accès
sudo mkdir -p /home/deploy/.ssh
sudo cp /root/.ssh/authorized_keys /home/deploy/.ssh/
sudo chown -R deploy:deploy /home/deploy/.ssh
sudo chmod 700 /home/deploy/.ssh && sudo chmod 600 /home/deploy/.ssh/authorized_keys
```

## 2. Durcissement SSH (/etc/ssh/sshd_config)
### Modification du port et désactivation de l'authentification par mot de passe.
```test
Port 6464               # Port non standard
PermitRootLogin no      # Interdire root direct
PasswordAuthentication no # Clé SSH obligatoire
PubkeyAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding no
```
### Ne pas redémarrer pas SSH tout de suite ! Configurer le pare-feu avant

## 3. Pare-feu (UFW)
```bash
# Installer si absent
sudo apt install -y ufw

# Règles par défaut
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Autoriser les services
sudo ufw allow 6464/tcp comment 'SSH Custom Port'
sudo ufw allow 80/tcp   comment 'HTTP'
sudo ufw allow 443/tcp  comment 'HTTPS'

# Activation
sudo ufw enable
```
### 4. Protection Brute-Force du port SSH (Fail2Ban)
```bash
sudo apt install -y fail2ban

# Création de la configuration locale (ne jamais toucher jail.conf)
sudo cat <<EOF > /etc/fail2ban/jail.local
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = 6464
mode = aggressive
EOF

# Démarrage
sudo systemctl enable --now fail2ban
```

## 5. Validation
```bash
# 1. Vérifier la config SSH
sudo sshd -t

# 2. Redémarrer SSH
sudo systemctl restart ssh

# 3. Tester la connexion dans un NOUVEAU terminal (ne pas fermer l'actuel !)
# ssh -p 6464 deploy@IP_SERVEUR
```

## 6. Astuce
### Débannir tout le monde
```bash
fail2ban-client unban --all
```
### Envoyer un rapport quotidien des journaux système par mail
```bash
logwatch --mailto mail@mail.me 
```






