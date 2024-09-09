# Script Mika

from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.backends import default_backend

def des_encrypt(key, plaintext):
    cipher = Cipher(algorithms.TripleDES(key), modes.ECB(), backend=default_backend())
    encryptor = cipher.encryptor()
    padder = padding.PKCS7(64).padder()
    padded_data = padder.update(plaintext) + padder.finalize()
    ct = encryptor.update(padded_data) + encryptor.finalize()
    return ct

def des_decrypt(key, ciphertext):
    cipher = Cipher(algorithms.TripleDES(key), modes.ECB(), backend=default_backend())
    decryptor = cipher.decryptor()
    pt = decryptor.update(ciphertext) + decryptor.finalize()
    unpadder = padding.PKCS7(64).unpadder()
    unpadded_data = unpadder.update(pt) + unpadder.finalize()
    return unpadded_data

key = b'12345678bienjoue'
ciphertext = b'\xd72U\xc03.\xda\x99Q\xb5\x020\xc4\xb8\x16\xc6\xfa-\xb9U+\xda\\\x126L\xf3~\xbd8\x12q\x02?\x80\xeaVI\xa9\xe1'

decrypt = des_decrypt(key, ciphertext)
print(f"Mess : {decrypt}")

# Solution sans affichage

# from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
# from cryptography.hazmat.primitives import padding
# from cryptography.hazmat.backends import default_backend
# import itertools

# def des_decrypt(key, ciphertext):
#     cipher = Cipher(algorithms.TripleDES(key), modes.ECB(), backend=default_backend())
#     decryptor = cipher.decryptor()
#     pt = decryptor.update(ciphertext) + decryptor.finalize()
#     unpadder = padding.PKCS7(64).unpadder()
#     unpadded_data = unpadder.update(pt) + unpadder.finalize()
#     return unpadded_data

# # Clé partielle connue
# partial_key = b'12345678bien'

# # Message chiffré
# ciphertext = b'\xd72U\xc03.\xda\x99Q\xb5\x020\xc4\xb8\x16\xc6\xfa-\xb9U+\xda\\\x126L\xf3~\xbd8\x12q\x02?\x80\xeaVI\xa9\xe1'

# # Caractères possibles pour les octets manquants (chiffres et lettres minuscules)
# possible_chars = list(range(48, 58)) + list(range(97, 123))

# # Essayer toutes les combinaisons possibles des 4 octets manquants
# for missing_bytes in itertools.product(possible_chars, repeat=4):
#     full_key = partial_key + bytes(missing_bytes)
#     try:
#         decrypted_message = des_decrypt(full_key, ciphertext)
#         # Vérifier si le message déchiffré est lisible (par exemple, si ce sont des caractères imprimables)
#         if all(32 <= b <= 126 for b in decrypted_message):
#             print(f"Clé complète trouvée : {full_key}")
#             print(f"Message déchiffré : {decrypted_message}")
#             break
#     except Exception as e:
#         continue