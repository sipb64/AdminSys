# Ansible - Gestion de l'Inventaire (Inventory)

Ne jamais modifier le fichier global (hosts), toujours créer un inventaire par projet (ex: "inventory/prod.yml") et l'appeler (-i).

## Format INI (inventory.ini)
```ini
# Connexion locale (sans SSH)
localhost ansible_connection=local

[deploy]
srv-web-01 ansible_host=192.X.X.10
srv-db-01  ansible_host=192.X.X.11

# Variables communes au groupe [deploy]
[deploy:vars]
ansible_user=ansible
ansible_port=22
```
## Format YAML (inventory.yml)**
```yaml
all:
  hosts:
    localhost:
      ansible_connection: local
  children:
    deploy:
      vars:
        ansible_user: ansible
        ansible_ssh_private_key_file: ~/.ssh/id_ed25519
      hosts:
        srv-web-01:
          ansible_host: 192.X.X.10
        srv-db-01:
          ansible_host: 192.X.X.11
```

## Commandes de Validation

### Lister les hôtes

```bash
ansible-inventory -i inventory.yml --graph
```

### Tester la connectivité (Pin gsur tout le groupe 'deploy')
```bash
ansible deploy -m ping -i inventory.yml
```

### Voir les variables assignées à un hôte (Debug)
```bash
ansible srv-web-01 -m debug -a "var=hostvars[inventory_hostname]" -i inventory.yml
```






