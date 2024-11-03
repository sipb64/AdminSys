#!/bin/bash

# Génération de la paire de clés SSH sans mot de passe
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Liste des serveurs à inventorier
SERVERS="192.168.1.20 192.168.1.214"
USER="audit"

# Copie de la clé publique sur les serveurs
for server in $SERVERS; do
  ssh-copy-id -i ~/.ssh/id_rsa.pub $USER@$server
done

# Test de connexion sans mot de passe
for server in $SERVERS; do
  ssh $USER@$server "echo 'Connexion réussie à $server'"
done

# Création du script d'inventaire
cat << EOF > inventory.sh
#!/bin/bash

USER="inventory"
SERVERS="192.168.1.20 192.168.1.214"

{
for server in \$SERVERS; do
  echo "=== \$server ==="
  ssh \$USER@\$server "cat /etc/os-release; ssh -V 2>&1"
  echo
done
} > inventaireSRV.txt
EOF

# Rendre le script exécutable
chmod +x inventory.sh

# Exécuter le script d'inventaire
./inventory.sh

echo "Inventaire terminé. Résultats dans inventaireSRV.txt"


<!-- # Créer une machine de gestion et installer ansible

apt install ansible

# Créez un fichier d'inventaire Ansible (inventory.ini)

[proxmox]
proxmox1 ansible_host=192.168.1.2 ansible_user=root
proxmox2 ansible_host=192.168.1.11 ansible_user=root
proxmox3 ansible_host=192.168.1.11 ansible_user=root

# Créez un playbook Ansible (inventory.yml) 

---
- name: Collect OS information from Proxmox VMs and Containers
  hosts: proxmox
  gather_facts: no
  tasks:
    - name: Get list of VMs
      command: pvesh get /cluster/resources --type vm
      register: vm_list

    - name: Get list of Containers
      command: pvesh get /cluster/resources --type container
      register: container_list

    - name: Collect OS information from VMs
      shell: qm list | awk 'NR>1 {print $1}'
      register: vm_ids

    - name: Get OS information for each VM
      shell: qm config {{ item }} | grep -E '^(os|scsi|virtio)'
      with_items: "{{ vm_ids.stdout_lines }}"
      register: vm_os_info

    - name: Collect OS information from Containers
      shell: pct list | awk 'NR>1 {print $1}'
      register: container_ids

    - name: Get OS information for each Container
      shell: pct config {{ item }} | grep -E '^(os|scsi|virtio)'
      with_items: "{{ container_ids.stdout_lines }}"
      register: container_os_info

    - name: Display VM OS information
      debug:
        msg: "{{ vm_os_info.results }}"

    - name: Display Container OS information
      debug:
        msg: "{{ container_os_info.results }}" -->
