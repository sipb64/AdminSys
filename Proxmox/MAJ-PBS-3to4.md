# Proxmox Backup Server - Migration v3 vers v4 (Bookworm -> Trixie)
**Avertissement : Cette procédure implique une mise à niveau majeure de l'OS (Debian 12 vers 13). Toujours tester les sauvegardes avant de procéder.**
## Faire un backup de /etc/proxmox-backup pour pouvoir récupérer la configuration

```bash
tar czf "pbs3-etc-backup-$(date -I).tar.gz" -C "/etc" "proxmox-backup"
```

## S'assurer d'avoir 10go de disque libre dans le point de montage racine

```bash
df -h /
```

## Mise à jour complète

```bash
apt update && apt full-upgrade -y
```
## Vérification de la version actuelle
```bash
proxmox-backup-manager versions
```

## Lancer le script d'audit pré-migration
### **Action requise : Si le script signale des erreurs (FAIL) ou des avertissements (WARN), corrigez-les avant de continuer.**
```bash
pbs3to4 --full
```
## Arrêter les services PBS pour qu'aucune tâche planifiée ne se déclenche

```bash
systemctl stop proxmox-backup
systemctl stop proxmox-backup-proxy.service
```

## Mettre à jour les dépots de base de debian

```bash
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
```

## Ajoute le depot de pbs4

```bash
cat > /etc/apt/sources.list.d/proxmox.sources << EOF
Types: deb
URIs: http://download.proxmox.com/debian/pbs
Suites: trixie
Components: pbs-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF
```

## Raffraichier l'index

```bash
apt update
```

## Passer à la monter de version Debian

```bash
apt dist-upgrade
```

## Redémarrer

```bash
systemctl reboot
```
## Vérifier la version
```bash
uname -r
proxmox-backup-manager versions
```
## Nettoyer les paquets obsolètes
```bash
apt autoremove -y
```