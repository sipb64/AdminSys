#!/bin/bash

# ==============================================================================
# TITRE          : DURCISSEMENT SERVEUR (Debian/Ubuntu)
# DESCRIPTION    : Basé sur les recommandations ANSSI
# AUTEUR         : ethiksys
# DATE           : 2026-02-01
# VERSION        : 2.3.0
# USAGE          : À exécuter sur une nouvelle installation 
#                  sudo ./hardening_debian.sh
# ==============================================================================

set -e

echo ">>> Démarrage du durcissement système..."

# 1. MISE A JOUR SYSTÈME
echo "[+] Mise à jour complète..."
apt update && apt full-upgrade -y
apt install -y curl wget ufw fail2ban rsyslog aide auditd

# 2. GESTION UTILISATEUR & SUDO
echo "[+] Sécurisation des comptes..."
# Désactivation du compte root (sécurité basique)
passwd -l root

# 3. DURCISSEMENT SSH (SSHD_CONFIG)
echo "[+] Durcissement SSH..."
SSHD_CONF="/etc/ssh/sshd_config"
cp $SSHD_CONF "$SSHD_CONF.bak"

# Désactiver root login et auth par mot de passe
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' $SSHD_CONF
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' $SSHD_CONF
sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' $SSHD_CONF
sed -i 's/^#*X11Forwarding.*/X11Forwarding no/' $SSHD_CONF

# Validation et redémarrage
sshd -t && systemctl restart ssh

# 4. PARE-FEU (UFW)
echo "[+] Configuration Pare-feu (UFW)..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh  # Attention : assurez-vous que SSH est sur le port 22 ou ajustez
ufw allow 80/tcp
ufw allow 443/tcp
# ufw allow 25/tcp # Décommenter si serveur mail
ufw --force enable

# 5. PARAMÈTRES NOYAU (SYSCTL)
echo "[+] Application des paramètres Sysctl (Network hardening)..."
cat << EOF > /etc/sysctl.d/99-security.conf
# Protection contre le spoofing
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
# Ignorer les ping broadcast
net.ipv4.icmp_echo_ignore_broadcasts=1
# Désactiver l'acceptation des redirections ICMP
net.ipv4.conf.all.accept_redirects=0
net.ipv6.conf.all.accept_redirects=0
net.ipv4.conf.all.send_redirects=0
# Protection SYN flood
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_max_syn_backlog=2048
EOF
sysctl --system

# 6. FAIL2BAN
echo "[+] Configuration Fail2Ban..."
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
# Augmenter le temps de bannissement (1h)
sed -i 's/^bantime  = 10m/bantime = 1h/' /etc/fail2ban/jail.local
systemctl enable fail2ban --now

# 7. SÉCURITÉ FICHIERS (UMASK)
echo "[+] Configuration umask..."
if ! grep -q "umask 027" /etc/profile; then
    echo "umask 027" >> /etc/profile
fi

# 8. AUDIT (AIDE)
echo "[+] Initialisation de la base d'intégrité AIDE (peut être long)..."
aideinit
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

echo ">>> Durcissement terminé. Redémarrage recommandé."
