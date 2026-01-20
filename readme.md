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
Gestion de clusters Proxmox et plans de reprise d'activité.

- **Proxmox Virtual Environment (PVE)** : Stratégies de migration sans interruption de service.
  - [Mise à jour majeure : PVE 8 vers 9 (POC)](Proxmox/MAJ-PVE-8to9.md)
  - [Mise à jour majeure : PVE 7 vers 8](Proxmox/MAJ-PVE-7to8.md)
- **Proxmox Backup Server (PBS)** : Sécurisation des sauvegardes.
  - [Mise à jour majeure : PBS 3 vers 4 (POC)](Proxmox/MAJ-PBS-3to4.md)

## 🔐 Sécurité & Réseau
Hardening système et gestion des flux.

- **Cryptographie & Accès** :
  - [Gestion des clés SSH](SSH/sshkey.md)
  - [Gestion de certificats SSL auto-signés/publics](Réseaux/GenSSL.md)
- **Pare-feu & Filtrage** :
  - [Règles iptables de base pour serveurs Linux](Réseaux/Iptable.md)
  - [Optimisation réseau : Désactivation IPv6 (Hardening)](Réseaux/DisableIPv6_linux.md)

## 🤖 IA On-Premise & Hardware Passthrough
Déploiement de solutions LLM locales avec accélération matérielle.

- **Intégration GPU** : [Virtualisation GPU pour OpenWebUI (PCI Passthrough)](IA/OpenWebUI-serverGPU.md)
- **Déploiement LLM** : [Installation d'Ollama (Linux/Windows)](IA/Ollama.md)

## ⚡ Automatisation
Standardisation des déploiements.

- [Template de script Bash](Template/script-template.md)

---
*Ce dépôt est maintenu activement. Pour discuter de ces implémentations ou d'opportunités professionnelles, retrouvez-moi sur [LinkedIn](https://www.linkedin.com/in/ethiksys).*