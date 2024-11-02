# Rapport d'Audit de Sécurité - Référentiel PASSI 

 

## 1. Introduction  

Contexte de l'audit :  

ABC est une entreprise spécialisée dans le développement de logiciels, employant 30 salariés. Dans le cadre de son programme d'audit, ABC a sollicité nos services pour réaliser un audit de sécurité de certains composants de son système d'information (SI).  

Périmètre de l'audit :  

L’audit couvre le serveur Linux non intégré au domaine hébergeant un serveur FTP et un serveur Web. (Vérification de la sécurité et de la configuration du serveur). 

## 2. Objectif de l'Audit 

L'objectif de cet audit est d'évaluer la sécurité de l'infrastructure et des applications en place, afin d'identifier les vulnérabilités potentielles et de proposer des recommandations pour améliorer la sécurité globale du SI. 
 
## 3. Méthodologie 

Cet audit sera réalisé en suivant la méthodologie PASSI (Prestataire d'Audit de la Sécurité des Systèmes d'Information). Cette approche structurée nous permettra d'effectuer une évaluation complète et rigoureuse des composants du SI d'ABC. Les étapes principales de la méthodologie PASSI incluent l'analyse des risques, les tests techniques, les entretiens avec le personnel et l'observation sur le terrain. 

 

## 5. Résumé Exécutif 

 

Ce résumé présente les principaux constats de l'audit, les vulnérabilités critiques identifiées, et les recommandations clés. 

 

### 5.1 Constat Global 

 

- **État général** : [Bonne, Moyenne, Critique] 

- **Nombre de vulnérabilités identifiées** : [Total] 

- **Vulnérabilités critiques** : [Nombre] 

- **Risques majeurs identifiés** : [Détails des risques] 

 

--- 

 

## 6. Constatations Détaillées 

Le serveur à était installé avec les configurations par défaut.  

 

### 6.1 Vulnérabilités Identifiées 

| ID  | Type de vulnérabilité        | Niveau de risque | Impact potentiel                    | Priorité | 
|-----|------------------------------|------------------|-------------------------------------|----------| 
| 01  | Absence de Fail2Ban           | Élevé            | Compromission par force brute       | Haute    | 
| 02  | Absence de partitionnement /var  | Moyen          | Saturation des journaux systèmes et des logs | Moyenne  | 
| 03  | Aucun mot de passe GRUB | Élevé            | Modification des paramètres de démarrage par un personne non autorisée | Haute  | 
| 04  | Permissions pour le répertoire /etc/sudoers.d | Élevé | Risque d'escalade de privilèges non autorisée    | Haute    | 
| 05 | Permissions pour le fichier de configuration CUPS | Moyen | Risque de sécurité lié aux permissions des fichiers | Moyenne | 
| 06 | wpa_supplicant.service | Risqué | Vulnérabilités potentielles dans la gestion des connexions Wi-Fi | Haute | 
| 07 | user@1000.service | Risqué | Risque potentiel lié à des services utilisateurs mal configurés | Haute | 
| 08 | systemd-rfkill.service | Risqué | Risque lié à la gestion des périphériques RF (Wi-Fi/Bluetooth) | Haute | 
| 09 | USBGuard non installé | Élevé | Exposition du système à des attaques physiques ou à des fuites de données par USB | Haute |  
| 10 | Paramètres de timeout de session | Moyen | Risque d'accès non autorisé en cas de session inactive | Moyenne | 
| 11 | Pas scanner de malware | Élevé | Système vulnérable aux menaces | Haute | 
| 12 | Durée maximale de validité du mot de passe désactivé | Très élevé | Compromission de la robustesse des mots de passe sur le long terme | Très haute | 

 ## 7. Recommandations 

 ### 7.1 Recommandations Générales 

 Quelques ajustements sont nécessaires pour optimiser la sécurité du serveur. 

 ### 7.2 Recommandations Spécifiques 

| Vulnérabilité | Action recommandée | Priorité | 
|---------------|--------------------|----------| 
| [ID] | [Description de l'action] | [Haute/Basse] |  
| 01| Installez Fail2Ban pour bannir automatiquement les hôtes ayant plusieurs erreurs d'authentification. | Haute | 
| 02 | Partitionner le disque en séparant /home /tmp  /var | Moyenne | 
| 03 | Affecter un mot de passe robuste au GRUB | Haute | 
| 04 | Vérifiez et ajustez les permissions du répertoire /etc/sudoers.d pour éviter les escalades de privilèges non autorisées. | Haute | 
| 05 | Vérifiez et ajustez les permissions des fichiers de configuration de CUPS pour améliorer la sécurité. | Moyenne | 
| 06 | Examinez la configuration du service wpa_supplicant pour identifier et corriger les vulnérabilités potentielles. | Haute | 
| 07 | Vérifiez la configuration du service user@1000 pour garantir qu'il ne présente pas de risques de sécurité. | Haute | 
| 08 | Examinez la configuration du service systemd-rfkill pour réduire les risques liés à la gestion des périphériques RF. | Haute | 
| 09 | Installer et configurer USBGuard | Haute |   
| 10 | Configurer le timeout des sessions utilisateur local et SSH| Moyenne | 
| 11 | Installer ClamAV et planifier des scans automatiques| Haute | 
| 12 | Configurer la durée maximale de validité des mots de passe de minimum 90 jours | Très haute | 

 

 

 

 

 

 

 

 

| ... | ... | ... | ... | 

 

--- 

 

## 8. Conclusion 

 

En conclusion, cet audit a permis d’identifier [nombre] vulnérabilités, dont [nombre] critiques. Des recommandations ont été proposées pour remédier aux problèmes identifiés. L’amélioration des mesures de sécurité est nécessaire pour réduire les risques. 

 

--- 

 

## 9. Annexes 

 

### 9.1 Glossaire 

 

- **PASSI** : Prestataire d'Audit de la Sécurité des Systèmes d'Information 

- **Vulnérabilité** : Faiblesse d'un système ou d'une infrastructure qui peut être exploitée pour compromettre sa sécurité. 

 

### 9.2 Liste des documents analysés 

 

- [Nom du document 1] 

- [Nom du document 2] 

 

### 9.3 Logs et Résultats des Tests Techniques 

 

- [Insérer des logs, détails techniques si nécessaire] 

 

--- 

 

**Fait à [Ville], le [Date]** 

 

**[Nom de l'auditeur principal]** 

 

 