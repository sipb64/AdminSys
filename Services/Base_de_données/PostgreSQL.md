# PostgreSQL - Administration & Gestion Quotidienne

## 1. Installation & Service

```bash
# Installation (Dernière version dispo)
sudo apt update && sudo apt install -y postgresql postgresql-contrib

# Vérifier l'état du cluster
pg_lsclusters

# Gérer le service
sudo systemctl status postgresql
sudo systemctl restart postgresql
```

## 2. Connexion (compte système par défaut `postgres` se connecte au compte DB `postgres`).

```bash
# Se connecter au shell SQL en tant que super-admin
sudo -u postgres psql

# Se connecter pour lancer une commande
sudo -u postgres psql -c "SELECT version();"
```

## 3. Gestion des Bases & Utilisateurs

### Via le Shell
```bash
# Créer un utilisateur
sudo -u postgres createuser --interactive --pwprompt
# --interactive : demande les rôles (superuser, createrole...)
# --pwprompt : demande le mot de passe tout de suite

# Créer une base de données (appartenant à un utilisateur spécifique)
sudo -u postgres createdb -O mon_utilisateur ma_base_db

# Supprimer une base
sudo -u postgres dropdb ma_base_db
```

### Via SQL
```sql
-- Créer un utilisateur avec mot de passe
CREATE USER mon_utilisateur WITH PASSWORD 'MonMDP123!';

-- Créer une base
CREATE DATABASE ma_base OWNER mon_utilisateur;

-- Donner tous les droits sur une base
GRANT ALL PRIVILEGES ON DATABASE ma_base TO mon_utilisateur;

-- Changer un mot de passe (Cas fréquent : mdp perdu)
ALTER USER mon_utilisateur WITH PASSWORD 'NouveauMdp!';

-- Lister les bases
\l
-- Lister les users
\du
-- Quitter
\q
```

## 4. Sauvegarde & Restauration (Backup/Restore)

### Sauvegarde (Dump)
```bash
# Sauvegarder une base
sudo -u postgres pg_dump ma_base_db > backup_mabase.sql

# Sauvegarder TOUT le serveur (Utilisateurs + Toutes les bases)
# Important avant une migration ou mise à jour !
sudo -u postgres pg_dumpall > backup_full_server.sql
```

### Restauration
```bash
# Restaurer une base spécifique
# 1. Créer la base vide si elle n'existe pas
sudo -u postgres createdb ma_base_db
# 2. Importer
sudo -u postgres psql ma_base_db < backup_mabase.sql

# Restaurer un dump complet (pg_dumpall)
sudo -u postgres psql -f backup_full_server.sql postgres
```

## 5. Configuration & Accès Distant (Par défaut n'écoute que sur `localhost`.)

### Autoriser les connexions distantes
1.  **Modifier `postgresql.conf`** (Autoriser l'écoute réseau) :
    `listen_addresses = '*'`
2.  **Modifier `pg_hba.conf`** (Autoriser l'authentification) :
    Ajouter à la fin : `host all all 0.0.0.0/0 scram-sha-256`
3.  **Redémarrer** : `sudo systemctl restart postgresql`

## 6. Troubleshooting (Problèmes fréquents)

### Erreur : `Peer authentication failed for user "..."`
*   **Cause** : Tu essaies de te connecter en local (`psql -U mon_utilisateur`) mais PostgreSQL attend que ton utilisateur Linux s'appelle aussi `mon_utilisateur`.
*   **Solution** : Force la connexion TCP pour utiliser le mot de passe :
    `psql -h localhost -U mon_utilisateur -d ma_base`

### Erreur : `FATAL: password authentication failed`
*   **Cause** : Mot de passe incorrect ou méthode d'auth incompatible.
*   **Solution** :
    1.  Vérifier `pg_hba.conf` (méthode `md5` ou `scram-sha-256` recommandée).
    2.  Réinitialiser le mot de passe : `sudo -u postgres psql -c "ALTER USER mon_utilisateur WITH PASSWORD 'reset';"`

### Erreur : `Connection refused` (Port 5432)
*   **Cause** : Le service est éteint ou écoute sur un autre port (ex: 5433 après une mise à jour ratée).
*   **Diagnostic** : `pg_lsclusters` pour voir quel cluster tourne sur quel port.