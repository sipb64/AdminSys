# Désactiver l'ipv6 sur linux (Debian/Ubuntu)

## Désactivation Temporaire pour tester l'impact avant de rendre la modification permanente.
### Via procfs
```bash
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
```
### Via sysctl
```bash
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
```
### Verification
```bash
ip a | grep inet6
```
## Désactiver IPv6 de manière permanent
### Editer le fichier /etc/sysctl.d
```bash
cat > /etc/sysctl.d/99-disable-ipv6.conf << EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
```
### Appliquer immédiatement
```bash
sysctl -p /etc/sysctl.d/99-disable-ipv6.conf
```
### Vérification de la persistance
```bash
# Recharger toutes les configs sysctl
sysctl --system

# Vérifier l'état (devrait retourner 1)
cat /proc/sys/net/ipv6/conf/all/disable_ipv6
```