# Ansible - Structure & Utilisation des Rôles

Utiliser les rôles pour de découper un playbook en unités logiques réutilisables.

## Initialisation du Projet (structure recommandée par Ansible)
```text
projet2/
├── inventory.yml       # Inventaire des serveurs
├── site.yml            # Playbook principal (point d'entrée)
└── roles/              # Dossier contenant tous les rôles
    └── webserver/      # Notre rôle exemple
        ├── tasks/main.yml
        ├── handlers/main.yml
        ├── templates/index.html.j2
        └── vars/main.yml
```
```bash
mkdir -p projet2/roles
cd projet2/roles
ansible-galaxy init webserver
```
## Configuration du Rôle (Exemple Nginx)
### Tasks - Définition des tâches à effectuer (roles/webserver/tasks/main.yml)
```yaml
---
- name: Installer Nginx
  ansible.builtin.apt:
    name: nginx
    state: present

- name: Déployer la page d'accueil (Template)
  ansible.builtin.template:
    src: index.html.j2
    dest: /var/www/html/index.html
    mode: '0644'
  notify: Restart Nginx
```
### Handlers - Actions qui ne s'exécutent que si notifiées (roles/webserver/handlers/main.yml)
```yaml
---
- name: Restart Nginx
  ansible.builtin.service:
    name: nginx
    state: restarted
```
### Templates - Fichier avec variables Jinja2 (roles/webserver/templates/index.html.j2)
```html
<h1>Bienvenue sur {{ ansible_hostname }}</h1>
<p>Servi par Nginx via Ansible.</p>
```
## Appel des rôles dans le Playbook Principal (projet2.yml)
```yaml
---
- name: Configuration des serveurs Web
  hosts: deploy
  remote_user: ansible
  become: yes

  roles:
    # Rôle système de base (existant)
    - role: common
    
    # Notre nouveau rôle webserver
    - role: webserver
```
## Exécution dans la racine du projet
```bash
ansible-playbook -i inventory.yml projet2.yml
```
