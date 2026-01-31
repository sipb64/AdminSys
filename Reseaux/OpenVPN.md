# Infrastructure VPN, CLient & Routage Avancé (OpenVPN)

## 1. Coté Serveur (Installation et Gestion)
### Installation des dépendances
```bash
apt update && apt install -y curl
```
### Téléchargement du script
```bash
curl -O https://raw.githubusercontent.com/Angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
```
### Déploiement non-interactif (Exemple de variables)
```bash
# AUTO_INSTALL=y : Valide automatiquement les choix
# APPROVE_IP : IP publique détectée
export AUTO_INSTALL=y
export APPROVE_IP=$(curl -s ifconfig.me)
export ENDPOINT=$APPROVE_IP
export PORT_CHOICE=1   # Port par défaut (1194)
export PROTOCOL_CHOICE=1 # UDP (recommandé) ou 2 pour TCP
export DNS=1 # 1=Current, 3=Cloudflare, 9=Google
export COMPRESSION_ENABLED=n
export CUSTOMIZE_ENC=n # Garder le chiffrement fort par défaut (AES-256-GCM)
```
### Lancer l'installation
```bash
./openvpn-install.sh install
```
### Gestion du serveur
```bash
./openvpn-install.sh interactive
```
### Gestion des Clients
```bash
./openvpn-install.sh client add client_nom
```
### Administration du Service
#### Vérifier le statut
```bash
systemctl status openvpn@server
```
#### Redémarrer le service
```bash
systemctl restart openvpn@server
```
#### Logs (Debug connexion)
```bash
journalctl -u openvpn@server -f
```
### Maintenance PKI (Easy-RSA)
### Audit des certificats
#### Vérifier la validité du certificat SERVEUR
```bash
openssl x509 -in /etc/openvpn/server.crt -noout -dates
```
#### Vérifier la validité de l'autorité de certification (CA) - CRITIQUE
```bash
openssl x509 -in /etc/openvpn/ca.crt -noout -enddate
```
#### Vérifier un certificat CLIENT spécifique
```bash
openssl x509 -in /etc/openvpn/easy-rsa/pki/issued/client_nom.crt -noout -enddate
```

#### Renouvellement du Certificat Serveur (erreur TLS Handshake)
```bash
cd /etc/openvpn/easy-rsa/
```
#### Renouveler le certificat 'server_NAME' par le Common Name (CN) réel du serveur
```bash
./easyrsa renew server_NAME nopass
```
#### Copie du certificat public
```bash
cp pki/issued/server_NAME.crt /etc/openvpn/server/
```
#### Copie de la clé privée (si régénérée)
```bash
cp pki/private/server_NAME.key /etc/openvpn/server/
```
#### Sécuriser et Redémarrer
```bash
chmod 600 /etc/openvpn/server/server_NAME.key
systemctl restart openvpn@server
```
#### Renouvellement du certificat d'autorité
```bash
cd /etc/openvpn/easy-rsa/
```
#### Renouveler la CA (EasyRSA v3) ne change pas la clé privée, juste la date de fin du CRT. L'envoi du nouveau ca.crt ou regénérer les fichiers clients est nécessaire.
```bash
./easyrsa build-ca nopass subca
```
#### Remplacer la CA du serveur
```bash
cp pki/ca.crt /etc/openvpn/
```
#### Redémarrer
```bash
systemctl restart openvpn@server
```
#### Renouvellement d'un Client
```bash
cd /etc/openvpn/easy-rsa/
./easyrsa renew client_nom nopass
```
#### Récupérer le nouveau certificat pour le client et intégrer dans son fichier .ovpn ou lui envoyer
```bash
cat pki/issued/client_nom.crt
```
### Configuration Réseau (/etc/openvpn/server.conf)
Pour éviter les conflits avec les box internet domestiques (souvent en 192.168.0.x ou 1.x), utiliser un sous-réseau dédié pour le tunnel.

```nginx
port 1194
proto udp
dev tun
topology subnet

# Plage IP du Tunnel (Éviter 192.168.0.0/24 et 1.0/24)
server 192.168.5.0 255.255.255.0

# Persistence des IP clients
ifconfig-pool-persist ipp.txt

# --- ROUTAGE AVANCÉ (Split Tunneling) ---
# Pousser la route vers le LAN interne (ex: 10.0.0.0/24)
push "route 10.0.0.0 255.255.255.0"

# --- GESTION DNS ---
# Forcer les DNS internes pour résoudre les noms de domaine locaux
push "dhcp-option DNS 10.0.0.254" # Serveur DNS Interne
push "dhcp-option DOMAIN macompagnie.local"

keepalive 10 120
cipher AES-256-GCM
user nobody
group nogroup
persist-key
persist-tun
verb 3
```

## 2. Coté Client (Linux)

## Installation de paquet pour network manager
```bash
sudo apt install openvpn network-manager-openvpn network-manager-openvpn-gnome
```

### Routage IP
```bash
# 1. Activer l'IP Forwarding de manière persistante
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# 2. Vérification
cat /proc/sys/net/ipv4/ip_forward # Doit retourner 1
```
## Sécurisation & Pare-feu (UFW)
```bash
# 1. Autoriser le port VPN (UDP 1194)
sudo ufw allow 1194/udp comment 'OpenVPN Access'

# 2. Autoriser le trafic depuis le Tunnel vers le LAN
sudo ufw allow from 192.168.5.0/24 to 10.0.0.0/24 comment 'VPN to LAN'

# 3. (Important) Configuration du NAT dans /etc/ufw/before.rules
# Ajouter en haut du fichier :
# *nat
# :POSTROUTING ACCEPT [0:0]
# -A POSTROUTING -s 192.168.5.0/24 -o eth0 -j MASQUERADE
# COMMIT
```

## 3. Automatisation Client (Linux Mint/Ubuntu)
```bash
#!/bin/bash
# Connecter le VPN en ligne de commande
CONFIG_FILE="/etc/openvpn/client/mon-entreprise.ovpn"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Fichier de configuration introuvable !"
    exit 1
fi

echo "Connexion au VPN..."
sudo openvpn --config "$CONFIG_FILE" --daemon
echo "OK ! VPN démarré en arrière-plan."
```
#### Démarrer OpenVPN automatiquement
```bash
sudo openvpn /etc/openvpn/monfichier.ovpn
sudo systemctl enable openvpn@monfichier
```
## Lanceurs d'applications".
```text
Cliquez sur le bouton "Ajouter" pour créer un nouveau lanceur. Remplissez les champs suivants :

Type : Application
Nom : OpenVPN Connect
Commande : /chemin/vers/openvpn-connect.sh
```
## 4. Troubleshooting & Diagnostic Réseau

Résolution des problèmes fréquents rencontrés en production (DNS, Routage).

| Symptôme | Cause Probable | Solution Technique |
| :--- | :--- | :--- |
| **Ping OK mais pas de nom** | Le client utilise toujours son DNS local (FAI) au lieu du DNS du VPN. | **Linux (systemd-resolved)** :<br>`sudo nano /etc/systemd/resolved.conf`<br>Ajouter `DNS=10.0.0.254`<br>`sudo systemctl restart systemd-resolved` |
| **Accès LAN impossible** | Le client n'a pas la route ou le serveur ne fait pas de NAT. | 1. Vérifier le forwarding (`sysctl`).<br>2. Vérifier le NAT (`iptables -t nat -L`).<br>3. Vérifier la route client (`ip route | grep tun0`). |
| **Connexion instable** | MTU trop élevé pour le réseau intermédiaire. | Ajouter `mssfix 1420` dans la config serveur et client. |
| **Erreur TLS Handshake** | Horloge système désynchronisée ou port bloqué. | Vérifier `date` sur le serveur et le client. Vérifier UFW. |