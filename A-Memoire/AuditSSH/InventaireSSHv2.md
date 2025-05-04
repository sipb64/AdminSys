#!/bin/bash

# Demander à l'utilisateur les valeurs des variables
echo "Entrez le nom d'utilisateur à utiliser pour la connexion SSH :"
read USER
echo "Entrez les adresses IP des serveurs à inventorier, séparées par un espace :"
read SERVERS

# Génération de la paire de clés SSH sans mot de passe
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

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

USER=$USER
SERVERS=$SERVERS
{
for server in \$SERVERS; do
  echo "=== \$server ==="
  ssh \$USER@\$server "cat /etc/os-release; ssh -V 2>&1; dpkg --list | grep openssh"
  echo
done
} > inventaireSRV.txt
EOF

# Rendre le script exécutable
chmod +x inventory.sh

# Exécuter le script d'inventaire
./inventory.sh

echo "Inventaire terminé. Résultats dans inventaireSRV.txt"
