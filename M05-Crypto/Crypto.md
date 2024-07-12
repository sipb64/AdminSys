# Les différents algorithmes

## Algo recommandés

**AES 256 avec mécanisme XTS** : chiffrement symétrique très sécurisé

**SHA2** : fonction de hachage sécurisée 

**RSA avec OAEP** : C'est un schéma de chiffrement à clé publique sécurisé

## Algo non recommandés

**AES 128 avec ECB** : ECB (Electronic Codebook) chiffre chaque bloc de manière identique, ce qui peut révéler des modèles dans les données

**3DES** : lenteur et faible sécurité

**SHA1** : encore largement utilisé, faible et obsolète en raison de vulnérabilités connues.

**MD5** : obsolète et non sécurisé en raison de vulnérabilités connues

**RSA avec PKCS1**mais no : encore largement utilisé, il a des vulnérabilités connues passer à OAEP est recommandé

# Chiffrer un message

## Generer clé AES256 et IV
openssl enc -aes-256-cbc -k secret_password -P -md sha256

## Crypter un message
openssl enc -aes-256-cbc -in TestCrypto.txt -out Chiffrement.bin -K XXXXXXXXXXXXXXKEYXXXXXXXX -iv XXXXXXXXXIVXXXXXXX

## Décrypter le message 

openssl enc -d -aes-256-cbc -in Chiffrement.bin -out Dechiffrement.txt -K XXXXXXXXXXXXXXKEYXXXXXXXX -iv XXXXXXXXXIVXXXXXXX

<p align="center">
    <img src="./TestCryptoOpenSSL.png" alt="TestCryptoOpenSSL" style="width: 800px;" />
</p>

# Générer une clé de chiffrement sûre et risque IV identiques

- Utiliser un générateur de nombres aléatoires cryptographiquement sécurisé
- Choisir la bonne taille de clé (elle dépend de l'algorithme utilisé)
- Protéger la clé et la stocker en toute sécurité (ex. TPM, HSM)

Les vecteurs d'initialisation (IV) s'assurent que le même texte en clair ne se traduit pas par le même texte chiffré lorsqu'il est chiffré plusieurs fois. Si les IV sont toujours les mêmes, des attaques par texte chiffré choisi ou texte en clair choisi, compromettent la sécurité du chiffrement.



