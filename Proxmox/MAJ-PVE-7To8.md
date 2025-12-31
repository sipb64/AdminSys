# Proxmox Virual Environment Mise à niveau 7 to 8

## Mise a jour des paquets de base et redémarrer si nécessaire
```
apt update && apt full-upgrade -y
```
## Lancer le script de proxmox (implémenté par les MAJS) pour verifier que tout est ok
```
pve7to8 --full
```
## Si besoin Installer les paquets necessaires pour la montée en version et verifier les dernières maj
```
apt install paquet manquant
apt update
apt dist-upgrade
```
## Verifier que la version est >= 7.4.5
```
pveversion
```
## Mettre à jour les dépots de base de debian 
```
sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
```
# # Mettre à jour les dépots de base de si ceph installé 
```
echo "deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription" > /etc/apt/sources.list.d/ceph.list
```
## Rafraichir l'index 
```
apt update
```
## Passer à la monter de version Debian et proxmox
```
apt dist-upgrade
```
## Suivre l’installation et répondre aux différentes questions et redemarrer
```
reboot
```