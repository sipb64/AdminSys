##################################################
#
# Proxmox Virual Environment Mise à niveau 8 to 9 
# (si ceph quincy ou reef monter en version vers squid nécessaire)
#
##################################################

# Mise a jour des paquets de base

apt update && apt full-upgrade -y

# Lancer le script de proxmox (implémenté par les MAJS) pour verifier que tout est ok

pve8to9 --full

# Installer les paquets necessaires pour la montée en version et verifier les dernières maj

# apt install paquet manquant
apt update
apt dist-upgrade
pveversion

# Mettre à jour les dépots de base de debian et ceph

sed -i 's/bookworm/trixie/g' /etc/apt/sources.list

# Ajoute le depot de pve9

cat > /etc/apt/sources.list.d/proxmox.sources << EOF
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF

# Si besoin ajouter

sed -i 's/bookworm/trixie/g' /etc/apt/sources.list.d/ceph.list

# Raffraichier l'index 

apt update

# Passer à la monter de version Debian

apt dist-upgrade