#!/bin/bash

##################################################
#
# Déchiffrer Message
#
##################################################

# Inviter l'utilisateur à rentrer la cle et l'IV et les stocker en tant que variable
#read -p "Tapez la clé AES : " CleAES
#read -p "Tapez IV : " IV

# Definition de la cle et de l'IV en variable en utilisant le fichier qui les stocke
CleAES=$(sed -n '2p' Cles.txt | cut -c5-)
IV=$(sed -n '3p' Cles.txt | cut -c5-)

# Dechiffrement du message 
openssl enc -d -aes-256-cbc -in Chiffrement.bin -out Dechiffrement.txt -K $CleAES -iv $IV 

# Affiche le message dechiffre
cat Dechiffrement.txt
