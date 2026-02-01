# Redis - Administration & Gestion Quotidienne

## 1. Installation & Sécurisation

```bash
# Installation
sudo apt update && sudo apt install -y redis-server

# Configuration de base (/etc/redis/redis.conf)
# 1. Lier uniquement à localhost
# bind 127.0.0.1 ::1

# 2. Définir un mot de passe (Requis en prod)
# requirepass MonSecretRedis123!

# 3. Changer le mode de supervision pour systemd
# supervised systemd

# Redémarrer
sudo systemctl restart redis-server
```

## 2. CLI Redis (Test et Debug)

```bash
# Se connecter (local)
redis-cli

# Si mot de passe actif
redis-cli -a MonSecretRedis123!

# Ping (Test de vie)
127.0.0.1:6379> PING
PONG
```

## 3. Commandes de Base (`redis-cli`)

```bash
# -- SET / GET (Strings) --
SET ma_cle "Bonjour"
GET ma_cle
# >> "Bonjour"

# -- EXPIRATION (Cache) --
# Définir une clé qui s'efface dans 10 secondes (TTL)
SET ma_session "TokenXYZ" EX 10
TTL ma_session
# >> (integer) 8  (reste 8 secondes)

# -- LISTES (Queues) --
LPUSH ma_file "job1"
LPUSH ma_file "job2"
RPOP ma_file
# >> "job1" (FIFO)

# -- NETTOYAGE --
DEL ma_cle       # Supprimer une clé
FLUSHDB          # Vider la base courante
FLUSHALL         # Vider TOUT le serveur (Attention !)
```

## 4. Monitoring & Debug

```bash
# Voir les infos serveur (Mémoire utilisée, Clients connectés...)
redis-cli INFO

# Voir uniquement la mémoire
redis-cli INFO memory

# Voir les commandes en temps réel (Comme un tail -f des requêtes)
redis-cli MONITOR
```

## 5. Persistence (RDB vs AOF)

*   **RDB (Snapshot)** : Photo de la RAM toutes les X minutes. (Fichier `/var/lib/redis/dump.rdb`). Rapide mais perte possible des dernières minutes.
*   **AOF (Append Only File)** : Logue chaque écriture. Plus lent mais plus sûr.

```bash
# Forcer une sauvegarde manuelle immédiate
redis-cli BGSAVE
```