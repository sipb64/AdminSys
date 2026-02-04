# Gestion avancée des conteneurs LXC (CLI)

## 1. Suppression d'un conteneur en CLI

Si l'interface web est inaccessible ou pour scripter.

```bash
#Lister les conteneurs pour récupérer le VMID (ex: 100, 102)
pct list

# Arrêter un conteneur
pct shutdown <vmid>

# Supprimer le conteneur
pct destroy <vmid>
```

## 2. Dépannage : Erreur "ipcc_send_rec failed"

- **Symptôme :** Impossible d'arrêter ou supprimer un CT. Erreur `Connection refused` ou `TASK ERROR`.
- **Cause :** Le conteneur est dans un état instable (verrouillé) ou le daemon pvestatd a du mal à communiquer.

```bash
# Vérifier le statut
pct status <vmid>


# Si bloqué (status running/stopping bloqué), utiliser `stop` pour tuer les processus.
pct stop <vmid>

# Si le conteneur est "stopped" mais impossible à supprimer (backup dispo): 
# Vérifier s'il y a un fichier de lock
ls -l /var/lock/lxc/pve-config-<vmid>.lock
# Le supprimer manuellement 
rm /var/lock/lxc/pve-config-<vmid>.lock

# Supprimer le conteneur
pct destroy <vmid>
```

## 3. Convertir "Unprivileged" vers "Privileged"

**Attention à utiliser en cas de nécessité absolue (ex: accès direct matériel)** 

*Privileged* mappe l'utilisateur root du conteneur directement sur le root de l'hôte Proxmox. Il faut passer par un Backup/Restore, pas de commande direct.

```bash
# Arrêter le conteneur
pct stop <vmid>

# Sauvegarder et noter le chemin du fichier .tar/.zst généré
vzdump <vmid>

# Détruire le conteneur original
pct destroy 105

# Restaurer avec le flag Privileged `--unprivileged 0`
pct restore <vmid> <chemin_backup> --unprivileged 0 --storage <pool>
# exemple pct restore 105 /var/lib/vz/dump/vzdump-lxc-105-2024...zst --unprivileged 0 --storage local-lvm

# Vérification, doit retourner : unprivileged: 0
pct config 105 | grep unprivileged
```