from cryptography.fernet import Fernet
import base64
import os

# Générer une nouvelle clé AES256 et un IV
key = Fernet.generate_key()
iv = Fernet.generate_key()[:16] # L'IV doit avoir une longueur de 16 octets pour AES256


# Afficher la clé et l'IV encodées en base64
print("Clé AES256 :", key)
print("IV :", iv)

# Partager la clé et l'IV de manière sécurisée avec le destinataire (par exemple, via un canal chiffré)
# Vous pouvez envoyer key_b64 et iv_b64 au destinataire via un canal sécurisé, comme une messagerie chiffrée

#openssl enc -aes-256-cbc -in TestCrypto.txt -out encrypted.bin -K A809F3396F7D0FF39FDFB4907FE17EF8C68B02F525AFAA0F665C27BE01EAEA75 -iv CB574EF1FA8440B693CEE653F087480A