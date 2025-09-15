# Génération de certificats SSL

## Génération clé privé et CSR (Certificate Signing Request SSL)
```sh
openssl req -new -newkey rsa:4096 -nodes -keyout privkey.pem -out sitedomaine.csr
```
## Renouvellement avec clé privée 
```sh
openssl req -new -key privkey.pem -out sitedomaine.csr
```
```sh
Country Name (2 letter code) [AU]:FR
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:*.sitedomaine.com
Email Address []:it@sitedomaine.fr

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
```
## Certbot LetsEncrypt
```sh
certbot certonly --standalone -d sitedomaine.fr
```
## SSL auto-signé .lan
```sh
openssl x509 -req -days 365 -in mondomaine.lan.csr -signkey mondomaine.lan.key -out mondomaine.lan.crt
```
## Droit Clé privée 600 + Hash
```sh
chmod 600 privekey.pem
md5sum privekey.pem
```
## Cat bundle
```sh
cat star.site.net.csr ca_bundle.csr > ssl-bundle.csr
```
