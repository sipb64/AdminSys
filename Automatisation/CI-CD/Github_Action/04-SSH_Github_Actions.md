# Clé de deploiement Github Action

## Passer en tant qu'utilisateur deploy
```bash
sudo su - deploy
```

## Générer une clé SSH sur le VPS
```bash
ssh-keygen -t ed25519 -C "vm-mon_projet" -f ~/.ssh/github_mon_projet -N ""
```

## Autoriser la clé publique pour la connexion
```bash
cat ~/.ssh/github_mon_projet.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## Afficher la clé privée à copier dans GitHub Secrets
```bash
cat ~/.ssh/github_mon_projet
```

## Copier cette clé publique et l'ajouter comme Deploy Key dans le dépôt GitHub (Settings > Deploy keys > Add deploy key).Puis :
```bash
cat >> ~/.ssh/config << EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_mon_projet
EOF
```

## Cloner le dépôt
```bash
git clone git@github.com:ethiksys/mon_projet.git /opt/mon_projet
```

## Secrets variables Action
VPS_IP = IP du VPS

VPS_USER = utilisateur de déploiement du VPS

VPS_SSHPRIVE = clé privé de l'utilisateur du de déploiement du VPS