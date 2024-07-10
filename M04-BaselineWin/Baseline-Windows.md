# Utilisation Auditpol

 La configuration initiale d'Auditpol n'est pas persistante par défaut, elle peut être rendue persistante en configurant les paramètres d'audit dans une stratégie de groupe

AuditPol [/commande] [/souscommande]
## Verification des politiques

AuditPol /get /category:*

## Configuration pour erreur d'authentification

Auditpol /set /category:"Connexion de compte" /failure:enable

Auditpol /set /subcategory:"Ouvrir la session" /failure:enable

<p align="center">
    <img src="./auditpol-connexion.png" alt="connexion" style="width: 800px;" />
</p>

## Configuration pour Audit escalade de privilèges

Auditpol /set /category:"Utilisation de privilège" /success:enable /failure:enable

<p align="center">
    <img src="./auditpol-privilege.png" alt="privilege" style="width: 800px;" />
</p>

# MSCT et LGPO doc 

https://learn.microsoft.com/fr-fr/windows/security/operating-system-security/device-management/windows-security-configuration-framework/security-compliance-toolkit-10

## Policy Analyser 

### Avant script MSCT

<p align="center">
    <img src="./PolAnaBefScr.png" alt="PolAnaBefScr" style="width: 800px;" />
</p>

### Apres script

<p align="center">
    <img src="./PolAftScr.png" alt="PolAftScr" style="width: 800px;" />
</p>

# Activation Bitlocker

<p align="center">
    <img src="./Bitlockv2.png" alt="Bitlock" style="width: 800px;" />
</p>

# Renforcer config Antivirus powershell

https://learn.microsoft.com/fr-fr/powershell/module/defender/?view=windowsserver2022-ps

<p align="center">
    <img src="./WinDefPow.png" alt="WinDef" style="width: 800px;" />
</p>

## Capture d'événements

<p align="center">
    <img src="./auditpol-even.png" alt="even" style="width: 800px;" />
</p>



