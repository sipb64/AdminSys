# Base de connaissance Infrastructure & Automatisation
> **Michaël B.** - SysAdmin & DevOps | Passionné Libre et Open Source

Bienvenue sur ma base de connaissance technique. Ce dépôt centralise mes procédures d'infrastructure, mes scripts d'automatisation et mes notes de déploiement issues de situations réelles en production et en laboratoire.

## 🛠️ Environnement Technique
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Proxmox](https://img.shields.io/badge/Proxmox-E57000?style=for-the-badge&logo=proxmox&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Bash](https://img.shields.io/badge/Shell_Scripting-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)

---

## 🏗️ Virtualisation & Gestion du cycle de vie (MCO)
Gestion de cycle de vie de clusters Proxmox et plans de reprise d'activité.

- **Proxmox Virtual Environment (PVE)** : Stratégies de migration sans interruption de service.
  - [Migration majeure : PVE 8 vers 9 (Early Adopter)](Proxmox/MAJ-PVE-8to9.md)
  - [Maintenance : PVE 7 vers 8](Proxmox/MAJ-PVE-7to8.md)
- **Proxmox Backup Server (PBS)** : Sécurisation des sauvegardes.
  - [Upgrade d'infrastructure de sauvegarde (PBS 3 vers 4)](Proxmox/MAJ-PBS-3to4.md)

## 🔐 Sécurité & Réseau
Hardening système et gestion des flux.

- **Cryptographie & Accès** :
  - [Gestion centralisée des clés SSH](SSH/sshkey.md)
  - [Génération et gestion de certificats SSL auto-signés/publics](Réseaux/GenSSL.md)
- **Pare-feu & Filtrage** :
  - [Règles iptables essentielles pour serveurs Linux](Réseaux/Iptable.md)
  - [Optimisation réseau : Désactivation IPv6 (Hardening)](Réseaux/DisableIPv6_linux.md)

## 🤖 IA On-Premise & Hardware Passthrough
Déploiement de solutions LLM locales avec accélération matérielle.

- **Intégration GPU** : [Virtualisation GPU pour OpenWebUI (PCI Passthrough)](IA/OpenWebUI-serverGPU.md)
- **Déploiement LLM** : [Installation et tuning d'Ollama (Linux/Windows)](IA/Ollama.md)

## ⚡ Automatisation
Standardisation des déploiements.

- [Template de script Bash (Boilerplate avec gestion d'erreurs)](Template/script-template.md)

---
*Ce dépôt est maintenu activement. Pour discuter de ces implémentations ou d'opportunités professionnelles, retrouvez-moi sur [LinkedIn](https://www.linkedin.com/in/ethiksys).*







# Notes et procédures (Linux/Windows)

## Sommaire

### SSH
- [Gestion clés SSH](SSH/sshkey.md)

### Proxmox
- [Mise à niveau Proxmox Backup Server 3 vers 4](Proxmox/MAJ-PBS-3to4.md)
- [Mise à niveau Proxmox Virual Environment 8 vers 9](Proxmox/MAJ-PVE-8To9.md)
- [Mise à niveau Proxmox Virual Environment 7 vers 8](Proxmox/MAJ-PVE-7To8.md)

### Réseaux
- [Désactiver IPv6 sur linux](Réseaux/DisableIPv6_linux.md)
- [Gestion de certificats SSL](Réseaux/GenSSL.md)
- [Commandes de bases iptable](Réseaux/Iptable.md)

### Template
- [Template Script Bash](Template/script-template.md)

### IA
- [Ollama Linux/Windows](IA/Ollama.md)
- [OpenWebUI dans VM-GPU](IA/OpenWebUI-serverGPU.md)