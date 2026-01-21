# Gestion des Certificats SSL/TLS (OpenSSL & Certbot)

## 1. Génération CSR (Certificate Signing Request)
### Nouvelle demande (avec génération de clé RSA 4096 bits sans mot de passe)
```bash
openssl req -new -newkey rsa:4096 -nodes -keyout privkey.pem -out domaine.csr
```
### Renouvellement (avec clé privée existante)
```bash
openssl req -new -key privkey.pem -out domaine.csr
```
### Exemple Champs interactifs (**Attention : Le "Common Name" (CN) doit correspondre exactement au FQDN** (ex: www.exemple.com ou *.exemple.com pour un wildcard))
```bash
Country Name (2 letter code) [AU]:FR
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:*.sitedomaine.com
Email Address []:it@sitedomaine.fr

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
```
## 2. Certificats Auto-signés (Dev/LAN)
### Génération avec SAN (Valide 1 an)
```bash
openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
  -keyout lan.key -out lan.crt \
  -subj "/CN=monserveur.lan" \
  -addext "subjectAltName=DNS:monserveur.lan,DNS:*.monserveur.lan,IP:192.168.1.10"
```
### 3. Let's Encrypt (Certbot)
#### Mode Standalone (Nécessite le port 80 libre aucun server Web ne tourne)
```bash
certbot certonly --standalone -d exemple.fr -d www.exemple.fr --email admin@exemple.fr --agree-tos --no-eff-email
```
#### Mode Webroot (Avec Nginx/Apache actif)
```bash
certbot certonly --webroot -w /var/www/html -d exemple.fr
```
### 4. Commandes utiles
#### Sécurisation de la clé privée
```bash
chmod 600 privekey.pem
chown root:root privkey.pem
```
#### Création d'un "Bundle" (Nginx/Haproxy)
**Ordre : Certificat serveur -> Intermédiaires -> Root (optionnel)**
```bash
cat certificat.crt ca_bundle.crt > fullchain.crt
```
#### Vérification de cohérence (Les deux hash doivent être identiques)
```bash
openssl x509 -noout -modulus -in certificat.crt | openssl md5
openssl rsa -noout -modulus -in privkey.pem | openssl md5
```
#### Vérifier la date d'expiration d'un site en ligne. (Debug)
```bash
echo | openssl s_client -servername exemple.com -connect exemple.com:443 2>/dev/null | openssl x509 -noout -dates
```
