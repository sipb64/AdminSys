# Connexion SSH par clés sans mot de passe

## Génération des clés communs window linux
ssh-keygen -t rsa -b 4096

## Linux SSH copy id 
ssh-copy-id user@ip.du.srv.distant

## Windows SSH copy id
Get-Content C:\users\USER\.ssh\id_rsa.pub | ssh user@ip.du.srv.distant "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

## Retirer un serveur du fichier known_hosts 
ssh-keygen -R IPouNom.du.serveur

