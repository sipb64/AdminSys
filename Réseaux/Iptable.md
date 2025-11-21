# iptables

## Politique par défaut

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

## Trafic local

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -i lo -j ACCEPT
iptables -A INPUT -i eth0 -j ACCEPT
iptables -A OUTPUT -i eth0 -j ACCEPT


## Autoriser les connexions établies et reliées

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
## Filtres trafic sur l'interface publique pour serveur web

iptables -A INPUT -i eth1 -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -i eth1 -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT

iptables -A OUTPUT -i eth1 -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
iptables -A OUTPUT -i eth1 -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT

## Rejet des autres port
iptables -A INPUT -i eth1 -j LOG --log-prefix "IPTables-Dropped: " --log-level 4

## Sauvegardes des règles

apt-get install iptables-persistent
iptables-save > /etc/iptables/rules.v4