# Installation OpenVPN et gestion de base

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
## Lancer l'installation
```bash
./openvpn-install.sh install
```
## Gestion du serveur
```bash
./openvpn-install.sh interactive
```
## Gestion des Clients
```bash
./openvpn-install.sh client add client_nom
```
## Administration du Service
### Vérifier le statut
```bash
systemctl status openvpn@server
```
### Redémarrer le service
```bash
systemctl restart openvpn@server
```
### Logs (Debug connexion)
```bash
journalctl -u openvpn@server -f
```
# Maintenance PKI (Easy-RSA)
## Audit des certificats
### Vérifier la validité du certificat SERVEUR
```bash
openssl x509 -in /etc/openvpn/server.crt -noout -dates
```
### Vérifier la validité de l'autorité de certification (CA) - CRITIQUE
```bash
openssl x509 -in /etc/openvpn/ca.crt -noout -enddate
```
### Vérifier un certificat CLIENT spécifique
```bash
openssl x509 -in /etc/openvpn/easy-rsa/pki/issued/client_nom.crt -noout -enddate
```

## Renouvellement du Certificat Serveur (erreur TLS Handshake)
```bash
cd /etc/openvpn/easy-rsa/
```
### Renouveler le certificat 'server_NAME' par le Common Name (CN) réel du serveur
```bash
./easyrsa renew server_NAME nopass
```
### Copie du certificat public
```bash
cp pki/issued/server_NAME.crt /etc/openvpn/server/
```
### Copie de la clé privée (si régénérée)
```bash
cp pki/private/server_NAME.key /etc/openvpn/server/
```
### Sécuriser et Redémarrer
```bash
chmod 600 /etc/openvpn/server/server_NAME.key
systemctl restart openvpn@server
```
## Renouvellement du certificat d'autorité
```bash
cd /etc/openvpn/easy-rsa/
```
### Renouveler la CA (EasyRSA v3) ne change pas la clé privée, juste la date de fin du CRT. L'envoi du nouveau ca.crt ou regénérer les fichiers clients est nécessaire.
```bash
./easyrsa build-ca nopass subca
```
### Remplacer la CA du serveur
```bash
cp pki/ca.crt /etc/openvpn/
```
### Redémarrer
```bash
systemctl restart openvpn@server
```
## Renouvellement d'un Client
```bash
cd /etc/openvpn/easy-rsa/
./easyrsa renew client_nom nopass
```
#### Récupérer le nouveau certificat pour le client et intégrer dans son fichier .ovpn ou lui envoyer
```bash
cat pki/issued/client_nom.crt
```