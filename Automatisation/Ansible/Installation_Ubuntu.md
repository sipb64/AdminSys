# Ansible - Installation & Configuration Initiale
---
Installation via Python Virtual Environment (Recommandée pour avoir la dernière version et isoler les dépendances).
OS : Ubuntu/Debian.
---
## Préparation du serveur 
### Installation des dépendances système
```bash
sudo apt update && sudo apt install -y python3 python3-pip python3-venv git sshpass
```
### Création de l'Environnement Virtuel (VENV)
```bash
# Créer le dossier pour les venvs (si inexistant)
mkdir -p ~/.venv

# Créer l'environnement dédié Ansible
python3 -m venv ~/.venv/ansible

# Activer l'environnement
source ~/.venv/ansible/bin/activate

# Installer Ansible (Core + Collections Community)
pip install --upgrade pip
pip install ansible
```
### Persistance, activer Ansible facilement à chaque session.
```bash
echo "alias ansible-env='source ~/.venv/ansible/bin/activate'" >> ~/.bashrc
source ~/.bashrc
```

## Générer la paire de clés (sans mot de passe pour l'automatisation, ou avec ssh-agent)
```bash
ssh-keygen -t ed25519 -C "ansible-controller"
```
## Préparation des Nœuds Cibles (chaque serveur à manager, nécessite un utilisateur avec droits sudo.)

### Création de l'utilisateur 'ansible' (Sur la cible)
```bash
# Créer l'utilisateur
sudo adduser ansible

# Lui donner les droits sudo
sudo usermod -aG sudo ansible
```
### IMPORTANT : Configurer sudo sans mot de passe (NOPASSWD)
```bash
# Créez un fichier dédié dans sudoers.d
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible
```
### Copier la clé publique vers la cible (Depuis le Contrôleur)
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub ansible@IP_CIBLE
```
## Test de connectivité

### Créer un inventaire simple pour tester inventory.ini :
```text
[servers]
192.168.1.50
```
### Commande de test pour recevoir ping : pong
```bash
ansible -i inventory.ini servers -m ping -u ansible
```






