# Proxmox VE - Migration v7 vers v8 (Bullseye -> Bookworm)
**Important : Cette migration touche au cœur de l'hyperviseur. Toutes les VMs/CTs doivent être migrés ou sauvegardés (Vzdump/PBS) au préalable.**
---
### Aperçu des principales nouveautés et avantages de Proxmox VE 8

1. **Interface Utilisateur Améliorée** :
   - **Nouveau Tableau de Bord** : Une interface utilisateur plus moderne et intuitive, avec un tableau de bord réorganisé pour une meilleure navigation.
   - **Améliorations de l'Interface** : Des améliorations visuelles et fonctionnelles pour une expérience utilisateur plus fluide.

2. **Support des Conteneurs LXC** :
   - **Nouvelles Fonctionnalités LXC** : Améliorations dans la gestion des conteneurs LXC, y compris de nouvelles options de configuration et de meilleures performances.
   - **Intégration avec LXD** : Une meilleure intégration avec LXD, permettant une gestion plus fine des conteneurs.

3. **Améliorations des Machines Virtuelles (VM)** :
   - **Support des Nouveaux Périphériques** : Ajout de nouveaux types de périphériques virtuels et amélioration du support des périphériques existants.
   - **Performances Améliorées** : Optimisations pour améliorer les performances des machines virtuelles.

4. **Sécurité Renforcée** :
   - **Mises à Jour de Sécurité** : Intégration des dernières mises à jour de sécurité pour protéger contre les vulnérabilités connues.
   - **Nouvelles Options de Sécurité** : Ajout de nouvelles options de configuration pour renforcer la sécurité des environnements virtualisés.

5. **Gestion des Ressources** :
   - **Améliorations de la Gestion des Ressources** : Meilleure gestion des ressources système, y compris une allocation plus efficace de la mémoire et du CPU.
   - **Surveillance Améliorée** : Outils de surveillance améliorés pour suivre l'utilisation des ressources en temps réel.

6. **Support des Nouveaux Matériels** :
   - **Compatibilité Matérielle** : Support amélioré pour les nouveaux matériels, y compris les derniers processeurs et cartes réseau.
   - **Optimisations Matérielles** : Optimisations pour tirer parti des nouvelles capacités matérielles.

7. **Fonctionnalités de Sauvegarde et de Restauration** :
   - **Améliorations des Sauvegardes** : Nouvelles options de sauvegarde et de restauration pour une meilleure protection des données.
   - **Automatisation des Sauvegardes** : Options avancées pour l'automatisation des sauvegardes et des restaurations.

8. **Performance Accrue** :
   - Les optimisations apportées à Proxmox VE 8 permettent d'améliorer les performances globales des machines virtuelles et des conteneurs.

9. **Sécurité Renforcée** :
   - Les nouvelles fonctionnalités de sécurité et les mises à jour régulières assurent une protection accrue contre les menaces.

10. **Interface Utilisateur Améliorée** :
   - Une interface plus intuitive et moderne facilite la gestion des environnements virtualisés, rendant l'expérience utilisateur plus agréable.

11. **Support Matériel Étendu** :
   - Le support des nouveaux matériels permet de tirer parti des dernières avancées technologiques, offrant ainsi de meilleures performances et une plus grande flexibilité.

12. **Gestion des Ressources Optimisée** :
   - Une meilleure gestion des ressources système permet une allocation plus efficace des ressources, réduisant ainsi les coûts et améliorant l'efficacité.

13. **Fonctionnalités de Sauvegarde Avancées** :
   - Les nouvelles options de sauvegarde et de restauration offrent une meilleure protection des données et facilitent la récupération en cas de sinistre.
---
## Mise a jour des paquets de base et redémarrer si nécessaire
```bash
apt update && apt full-upgrade -y
```
## Lancer le script d'audit pré-migration
### **Action requise : Si le script signale des erreurs (FAIL) ou des avertissements (WARN), corrigez-les avant de continuer.**
```bash
pve7to8 --full
```

## Verifier que la version est >= 7.4.5
```bash
pveversion
```
## Mettre à jour les dépots de base de debian 
```bash
sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list /etc/apt/sources.list.d/*.list
```
## Mettre à jour les dépots de base de si ceph installé 
```bash
echo "deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription" > /etc/apt/sources.list.d/ceph.list
```
## Rafraichir l'index 
```bash
apt update
```
## Passer à la monter de version Debian et proxmox
```bash
apt dist-upgrade
```
## Suivre l’installation et répondre aux différentes questions et redemarrer
```bash
reboot
```
## Vérifier la version (noyau et pve)
```bash
uname -r
pveversion
```
## Nettoyer les paquets obsolètes
```bash
apt autoremove -y
```