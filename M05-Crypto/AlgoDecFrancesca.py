from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.backends import default_backend

def des_decrypt(key, ciphertext):
    cipher = Cipher(algorithms.TripleDES(key), modes.ECB(), backend=default_backend())
    decryptor = cipher.decryptor()
    pt = decryptor.update(ciphertext) + decryptor.finalize()
    unpadder = padding.PKCS7(64).unpadder()
    unpadded_data = unpadder.update(pt) + unpadder.finalize()
    return unpadded_data

ciphertext = b'\xd72U\xc03.\xda\x99Q\xb5\x020\xc4\xb8\x16\xc6\xfa-\xb9U+\xda\\\x126L\xf3~\xbd8\x12q\x02?\x80\xeaVI\xa9\xe1'

partial_key = b'12345678bien'  

def find_key():
    characters = "abcdefghijklmnopqrstuvwxyz"
    
    for c1 in characters:
        for c2 in characters:
            for c3 in characters:
                for c4 in characters:
                    yield c1 + c2 + c3 + c4

# Essayer toutes les combinaisons possibles
for key_suffix in find_key():
    key = partial_key + key_suffix.encode()  # Convertir la combinaison en bytes
    
    try:
        decrypted_message = des_decrypt(key, ciphertext)
        # Tentative de décodage en tant que texte UTF-8
        try:
            decoded_message = decrypted_message.decode('utf-8')
            print(f"Key: {key_suffix} - Decrypted Message: {decoded_message}")
        except UnicodeDecodeError:
            # Ignorer les messages qui ne sont pas valides en UTF-8
            continue
    except Exception as e:
        # Ignorer les erreurs liées aux clés incorrectes
        continue


