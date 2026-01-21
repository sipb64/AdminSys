# Passbolt CE - Installation & Migration
```
Gestionnaire de mots de passe collaboratif Open Source.
Recommandations doc officielle
Système : Ubuntu 24.04 LTS
2 core
2GB of ram
```
## Installation Neuve
### Préparation
```sh
apt update && apt full-upgrade -y
apt install -y curl sudo gnupg
```
### Script d'installation officiel
```sh
curl -LO "https://download.passbolt.com/ce/installer/passbolt-repo-setup.ce.sh"

curl -LO "https://github.com/passbolt/passbolt-dep-scripts/releases/latest/download/passbolt-ce-SHA512SUM.txt"

sha512sum -c passbolt-ce-SHA512SUM.txt && bash ./passbolt-repo-setup.ce.sh || echo "Bad checksum. Aborting" && rm -f passbolt-repo-setup.ce.sh

apt install passbolt-ce-server
```
### Gestion des SSL configuration initiale
```
Placer la clé : /etc/ssl/private/passbolt.key (chmod 600)

Placer le certificat : /etc/ssl/certs/passbolt.crt

Indiquer ces chemins lors de l'assistant dpkg-reconfigure passbolt-ce-server.
```
## Procédure de Migration / Restauration
Migration d'un serveur A vers un serveur B
### Sauvegarde
```bash
mkdir -p /home/user/backup_passbolt
```
#### Dump Base de données
```bash
mysqldump -u root -p passdb > /home/user/backup_passbolt/passbolt_dump.sql
```
#### Clés GPG Serveur
```bash
cp -r /etc/passbolt/gpg /home/user/backup_passbolt/gpg_keys
```
#### Avatar et clés JWT (Optionnel mais recommandé)
```bash
cp -r /usr/share/php/passbolt/webroot/img/avatar /home/user/backup_passbolt/avatars
cp -r /etc/passbolt/jwt /home/user/backup_passbolt/jwt_keys
```
#### Fichier de config
```bash
cp /etc/passbolt/passbolt.php /home/user/backup_passbolt/
```
### Restauration sur le nouveau serveur
Prérequis : Avoir installé Passbolt (étape 1) mais ne pas avoir complété le wizard web.
#### Restauration BDD
```bash
mysql -u passbolt -p passbolt < /home/user/backup_passbolt/passbolt_dump.sql
```
#### Restauration GPG (Clés serveur)
```bash
# Copie
rm -rf /etc/passbolt/gpg
cp -r /home/user/backup_passbolt/gpg_keys /etc/passbolt/gpg

# Permissions strictes (www-data doit pouvoir lire)
chown -R www-data:www-data /etc/passbolt/gpg
chmod 750 /etc/passbolt/gpg
chmod 640 /etc/passbolt/gpg/*
```
#### Restauration Config & JWT
```bash
# Config PHP
cp /home/user/backup_passbolt/passbolt.php /etc/passbolt/
chown www-data:www-data /etc/passbolt/passbolt.php
chmod 640 /etc/passbolt/passbolt.php

# JWT (Si présent)
cp -r /home/user/backup_passbolt/jwt_keys/* /etc/passbolt/jwt/
chown -R root:www-data /etc/passbolt/jwt
chmod 750 /etc/passbolt/jwt
chmod 640 /etc/passbolt/jwt/*.pem
```
#### Ré-importation du Keyring GPG
```bash
sudo su -s /bin/bash -c "gpg --home /var/lib/passbolt/.gnupg --import /etc/passbolt/gpg/serverkey_private.asc" www-data
sudo su -s /bin/bash -c "gpg --home /var/lib/passbolt/.gnupg --import /etc/passbolt/gpg/serverkey.asc" www-data
```
#### Migration, mise à jour du schéma de base de données
```bash
sudo -H -u www-data bash -c "/usr/share/php/passbolt/bin/cake passbolt migrate"
```
#### Vérification finale (Healthcheck)
```bash
sudo -H -u www-data bash -c "/usr/share/php/passbolt/bin/cake passbolt healthcheck"
```