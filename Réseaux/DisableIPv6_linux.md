# Désactiver l'ipv6 sur linux

## Modifier la configuration du kernel Linux de manière temporaire
```
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
```
## Désactiver IPv6 de manière permanent, éditez le fichier /etc/sysctl.conf et ajoutez les lignes :
```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
```