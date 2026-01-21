# Proxmox VE - Migration v8 vers v9 (Bookworm -> Trixie)
**Important : Cette migration touche au cœur de l'hyperviseur. Toutes les VMs/CTs doivent être migrés ou sauvegardés (Vzdump/PBS) au préalable. Si ceph quincy ou reef est installé monter en version vers squid est nécessaire.**

## Mise a jour des paquets de base
```bash
apt update && apt full-upgrade -y
```
## Lancer le script d'audit pré-migration
### **Action requise : Si le script signale des erreurs (FAIL) ou des avertissements (WARN), corrigez-les avant de continuer.**
```bash
pve8to9 --full
```
## Verifier que la version est >= 8.4
```bash
pveversion
```
## Mettre à jour les dépots de base de debian et ceph
```bash
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list /etc/apt/sources.list.d/*.list
```
## Ajouter le depot de pve9
```bash
cat > /etc/apt/sources.list.d/proxmox.sources << EOF
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF
```
## Si besoin ajouter
```bash
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list.d/ceph.list
```
## Raffraichier l'index 
```bash
apt update
```
## Passer à la monter de version Debian
```bash
apt dist-upgrade
```
## Redemarrer
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