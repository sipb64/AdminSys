# Pentest Juice Shop

## Reconnaissance : Identifier l'adresse IP ou le nom de domaine de l'instance Juice Shop dans le réseau cible.

Ip machine cible via nmap -> 10.0.0.101

## Scan des ports : 

nmap -sn 10.0.0.101/24

Port ouvert :
22 pour ssh et 3000 pour l'app

<p align="center">
    <img src="./ScanPortLANCible.png" alt="ScanNmap" style="width: 800px;" />
</p>

## Accès à l'application : Se connecter à l'URL et explorer l'app

<p align="center">
    <img src="./FirstConnectJuice.png" alt="ScanNmap" style="width: 800px;" />
</p>


## Déploiement d'OpenVAS

### Install 
sudo apt install openvas
### Chmod Fichier log 
sudo chmod 666 /var/log/gvm/openvas.log
### Synchronisation des flux de données
sudo greenbone-feed-sync
### Initialisation
sudo gvm-setup
### Vérification de l'installation
sudo gvm-check-setup
### Initialisation
sudo gvm-setup
### Lancement
sudo gvm-start
### Accès à l'interface (login)
https://localhost:9392

<p align="center">
    <img src="./OpenVasFonctionnel.png" alt="ScanNmap" style="width: 800px;" />
</p>

- Ajouter la cible dans OpenVAS

Configuration -> Target

<p align="center">
    <img src="./ConfTarget.png" alt="ScanNmap" style="width: 800px;" />
</p>

- Scanner la cible 

Scans -> New Task 

<p align="center">
    <img src="./ConfTask.png" alt="ScanNmap" style="width: 800px;" />
</p>

- Résultats du premier Scan

<p align="center">
    <img src="./FirstScanOpen.png" alt="ScanNmap" style="width: 800px;" />
</p>

- Analyse du code source : Examiner le code source de l'application, en particulier le fichier main.js, pour des informations utiles.

Télécharger le site :

wget -r http://10.0.0.101:3000

Maintenant on peut lire le code source avec un éditeur de code.