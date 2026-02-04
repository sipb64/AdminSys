# Ansible - Structure Projet & Premier Playbook
Installer des paquets de base, créer un utilisateur et déployer sa clé SSH.
## Structure du Projet
```bash
# Créer l'arborescence dans home
mkdir -p ~/ansible/projet1
cd ~/ansible/projet1
```
## Exemple de Playbook (projet1.yml)
```yaml
---
- name: Configuration de base des serveurs Linux
  hosts: deploy          # Groupe défini dans l'inventaire
  remote_user: ansible   # Utilisateur de connexion SSH
  become: yes            # Élévation de privilèges (sudo)

  tasks:
    - name: Mettre à jour le cache APT (Si plus vieux que 1h)
      ansible.builtin.apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Installer les paquets de base (htop, vim, curl)
      ansible.builtin.apt:
        name:
          - htop
          - vim
          - curl
        state: present

    - name: Créer l'utilisateur 'user'
      ansible.builtin.user:
        name: user
        shell: /bin/bash
        create_home: yes
        groups: sudo      # Ajouter au groupe sudo (optionnel)
        append: yes

    - name: Déployer la clé SSH publique pour 'user'
      ansible.posix.authorized_key:
        user: user
        state: present
        key: "{{ lookup('file', '~/.ssh/id_ed25519.pub') }}"
```
## Exécution du Playbook
### Validation de la syntaxe (Dry Run)
```bash
ansible-playbook projet1.yml --syntax-check
```
### Lancement
```bash
# Si sudo nécessite un mot de passe
ansible-playbook -i inventory.ini projet1.yml --ask-become-pass

# Si sudo est configuré en NOPASSWD
ansible-playbook -i inventory.ini projet1.yml
```