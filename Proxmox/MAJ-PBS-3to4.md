# Proxmox Backup Server Mise à niveau 8 to 9

## Faire un backup de /etc/proxmox-backup pour pouvoir récupérer la configuration

```
tar czf "pbs3-etc-backup-$(date -I).tar.gz" -C "/etc" "proxmox-backup"
```

## S'assurer d'avoir 10go de disque libre dans le point de montage racine

```
df -h /
```

## Mise a jour des paquets de base

```
apt update && apt full-upgrade -y
```

## Lancer le script de proxmox (implémenté par les MAJS) pour verifier que tout est ok

```
pbs3to4 --full
```

## Installer les paquets necessaires pour la montée en version et verifier les dernières maj

```
apt install paquet manquant
apt update
apt dist-upgrade
proxmox-backup-manager versions
```

## Arrêter les services PBS pour qu'aucune tâche planifiée ne se déclenche

```
systemctl stop proxmox-backup
systemctl stop proxmox-backup-proxy.service
```

## Mettre à jour les dépots de base de debian

```
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
```

## Ajoute le depot de pbs4

```
cat > /etc/apt/sources.list.d/proxmox.sources << EOF
Types: deb
URIs: http://download.proxmox.com/debian/pbs
Suites: trixie
Components: pbs-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF
```

## Raffraichier l'index

```
apt update
```

## Passer à la monter de version Debian

```
apt dist-upgrade
```

## Redémarrer

```
systemctl reboot
```