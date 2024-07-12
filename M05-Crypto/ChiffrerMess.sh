#!/bin/bash

##################################################
#
# Chiffrer un message + Création clé
#
##################################################

# L'utilisateur ecrit son message
read -p "Ecrire un message : " message

# Le message est stocke dans un fichier
echo $message > MonMessage.txt

# Affiche le contenu du fichier pour vérifier que c'est ok (optionnel)
cat MonMessage.txt

# Creation de la cle AES256 et de l'IV avec openssl qui seront stockees dans un fichier
openssl enc -aes-256-cbc -k secret_password -P -md sha256 > Cles.txt

# Inviter l'utilisateur à rentrer la cle et l'IV et les stocker en tant que variable
#read -p "Tapez la clé AES : " CleAES
#read -p "Tapez IV : " IV

# Definition de la cle et de l'IV en variable en utilisant le fichier qui les stocke
CleAES=$(sed -n '2p' Cles.txt | cut -c5-)
IV=$(sed -n '3p' Cles.txt | cut -c5-)

# Chiffrement du message
openssl enc -aes-256-cbc -in MonMessage.txt -out Chiffrement.bin -K $CleAES -iv $IV

# Affiche le contenu chiffrer
cat Chiffrement.bin

# Dechiffrement du message 
#openssl enc -d -aes-256-cbc -in Chiffrement.bin -out Dechiffrement.txt -K $CleAES -iv $IV 

# Affiche le message dechiffre
#cat Dechiffrement.txt