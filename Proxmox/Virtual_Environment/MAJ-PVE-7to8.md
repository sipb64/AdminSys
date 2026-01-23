# Proxmox VE - Migration v7 vers v8 (Bullseye -> Bookworm)
**Important : Cette migration touche au cœur de l'hyperviseur. Toutes les VMs/CTs doivent être migrés ou sauvegardés (Vzdump/PBS) au préalable.**

## Mise a jour des paquets de base et redémarrer si nécessaire
```bash
apt update && apt full-upgrade -y
```
## Lancer le script d'audit pré-migration
### **Action requise : Si le script signale des erreurs (FAIL) ou des avertissements (WARN), corrigez-les avant de continuer.**
```bash
pve7to8 --full
```

## Verifier que la version est >= 7.4.5
```bash
pveversion
```
## Mettre à jour les dépots de base de debian 
```bash
sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list /etc/apt/sources.list.d/*.list
```
## Mettre à jour les dépots de base de si ceph installé 
```bash
echo "deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription" > /etc/apt/sources.list.d/ceph.list
```
## Rafraichir l'index 
```bash
apt update
```
## Passer à la monter de version Debian et proxmox
```bash
apt dist-upgrade
```
## Suivre l’installation et répondre aux différentes questions et redemarrer
```bash
reboot
```
## Vérifier la version (noyau et pve)
```bash
uname -r
pveversion
```
## Nettoyer les paquets obsolètes
```bash
apt autoremove -y
```