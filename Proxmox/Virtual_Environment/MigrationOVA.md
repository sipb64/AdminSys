# Import OVA dans Proxmox 8.3+

Migration d'une VM ubuntu depuis VMware/VirtualBox vers Proxmox VE.

## Références

- [Doc officielle Proxmox](https://pve.proxmox.com/wiki/Migration_of_servers_to_Proxmox_VE)
- [Procédure 4sysops](https://4sysops.com/archives/ova-import-in-proxmox-83/)
- [Procédure credibleDEV](https://credibledev.com/import-virtualbox-and-virt-manager-vms-to-proxmox/)

## Prérequis
- Proxmox VE 8.3+
- Fichier .ova disponible
- Storage configuré avec le type "Import" activé

## Méthode 1 : Interface Web (Proxmox 8.3+)

### Activer l'import sur le storage
1. **Datacenter** > **Storage** > Sélectionner le storage (ex: `local`)
2. **Edit** > Cocher **Import** dans la liste "Content"
3. **OK** pour valider

### Uploader et importer l'OVA
1. **Storage** > **Import** > **Upload** ou **Download from URL**
2. Sélectionner le fichier `.ova`
3. Une fois uploadé, cliquer sur **Import to VM**
4. Suivre l'assistant (VMID, nom, storage cible, format qcow2)

## Méthode 2 : CLI

### Extraire l'archive OVA
```bash
cd /var/lib/vz/template/
tar -xvf mon-vm.ova
```

### Importer la configuration et le disque
```bash
# Créer la VM depuis le descriptor OVF
qm importovf <VMID> mon-vm.ovf <storage> --format qcow2

# Exemple :
qm importovf 100 mon-vm.ovf local-lvm --format qcow2
```

## Dépannage : Absence de réseau après import

### Symptôme
La VM démarre mais n'a pas d'accès réseau (pas de DHCP, pas de connectivité).

### Diagnostic

```bash
# Identifier le nom de l'interface (retourne enp0sXX, ensXX, etc.)
ip a
```

### Solution : Adapter la config Netplan (Ubuntu/Debian)

```bash
# Éditer le fichier Netplan
sudo nano /etc/netplan/01-netcfg.yaml
```

**Corriger le nom de l'interface :**
```yaml
network:
  version: 2
  ethernets:
    ensXX:  # ← Remplacer par le nom réel (ex: ens18)
      dhcp4: true
```

**Appliquer les changements :**
```bash
sudo netplan apply
```

### Installer QEMU Guest Agent (recommandé)

```bash
sudo apt update && sudo apt install qemu-guest-agent -y
sudo systemctl enable --now qemu-guest-agent
```

**Dans Proxmox :** Options VM > QEMU Guest Agent > Use QEMU Guest Agent

## Checklist post-import

- [ ] Réseau fonctionnel (`ping 1.1.1.1`)
- [ ] qemu-guest-agent installé et actif
- [ ] Contrôleur SCSI en VirtIO (conseillé pour la performance)
- [ ] Firmware UEFI/BIOS conforme à l'origine
- [ ] Premier snapshot avant mise en prod