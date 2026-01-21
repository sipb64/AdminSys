# Iptables - Configuration Pare-feu (Commandes de bases)

## Initialisation (Flush) part d'une base saine pour éviter les conflits.
```bash
iptables -F
iptables -X
```
## Règles de base
### Autoriser le Loopback
```bash
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
```
### Autoriser le trafic déjà établi
```bash
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```
### Autoriser SSH important avant de modifier la politique par défaut
```bash
# Remplacer 22 par le port SSH si modifié
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
```
## Services Publics (Web)
### Filtres trafic sur l'interface publique pour serveur web
```bash
iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT
```
## Politique ICMP (Bloquer le ping peut gêner le monitoring.)
```bash
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
```
## Rejet et log
```bash
iptables -A INPUT -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
```
## Application des Politiques
```bash
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
```
## Persistance
```bash
apt-get install -y iptables-persistent netfilter-persistent
netfilter-persistent save
# Autre méthode
iptables-save > /etc/iptables/rules.v4
```