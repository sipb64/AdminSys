#!/bin/bash

# Liste des serveurs à auditer
SERVERS="192.168.1.20 192.168.1.214"
USER="audit"

# Date actuelle pour le nom du fichier de sortie
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
AUDIT_REPORT="audit_report_${DATE}.txt"

# Récupération des configurations SSH actuelles
for server in $SERVERS; do
  ssh $USER@$server "cat /etc/ssh/sshd_config" > ${server}_sshd_config.txt
done

# Comparaison des configurations avec les recommandations de l'ANSSI
# Exemple de recommandations ANSSI (à adapter selon les recommandations actuelles)
ANSSI_RECOMMENDATIONS=(
  "Protocol 2"
  "StrictHostKeyChecking ask"
  "StrictModes yes"
  "PermitEmptyPasswords no"
  "MaxAuthTries 3"
  "LoginGraceTime 30"
  "PermitRootLogin no"
  "PrintLastLog yes"
  "PermitUserEnvironment no"
  "X11Forwarding no"
)

# Fonction pour vérifier une configuration
check_config() {
  local server=$1
  local config=$2
  local recommendation=$3
  local result=$(grep -E "$recommendation" ${server}_sshd_config.txt)
  if [[ -z "$result" ]]; then
    echo "Non conforme: $config ($recommendation) sur $server" >> $AUDIT_REPORT
  else
    echo "Conforme: $config ($recommendation) sur $server" >> $AUDIT_REPORT
  fi
}

# Fonction pour vérifier les permissions et la propriété des fichiers de clés SSH
check_key_permissions() {
  local server=$1
  local key_file=$2
  local expected_permissions="-rw-------"
  local expected_owner="root:root"

  local permissions=$(ssh $USER@$server "stat -c '%A %U:%G' $key_file")
  if [[ "$permissions" == "$expected_permissions $expected_owner" ]]; then
    echo "Conforme: Permissions et propriété de $key_file sur $server" >> $AUDIT_REPORT
  else
    echo "Non conforme: Permissions et propriété de $key_file sur $server ($permissions)" >> $AUDIT_REPORT
  fi
}

# Vérification des configurations pour chaque serveur
for server in $SERVERS; do
  echo "=== Audit de $server ===" >> $AUDIT_REPORT
  for recommendation in "${ANSSI_RECOMMENDATIONS[@]}"; do
    check_config $server "SSH Configuration" "$recommendation"
  done

  # Vérification des permissions et de la propriété des fichiers de clés SSH
  check_key_permissions $server "/etc/ssh/ssh_host_rsa_key"
  check_key_permissions $server "/etc/ssh/ssh_host_ecdsa_key"

  echo "" >> $AUDIT_REPORT
done

# Effacement des configurations SSH après l'analyse
for server in $SERVERS; do
  rm -f ${server}_sshd_config.txt
done

echo "Audit terminé. Résultats dans $AUDIT_REPORT"
