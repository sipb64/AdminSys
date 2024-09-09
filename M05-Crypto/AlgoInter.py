from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.backends import default_backend
import itertools

def des_decrypt(key, ciphertext):
    cipher = Cipher(algorithms.TripleDES(key), modes.ECB(), backend=default_backend())
    decryptor = cipher.decryptor()
    pt = decryptor.update(ciphertext) + decryptor.finalize()
    unpadder = padding.PKCS7(64).unpadder()
    unpadded_data = unpadder.update(pt) + unpadder.finalize()
    return unpadded_data 

# Message chiffré
ciphertext = b'\xd72U\xc03.\xda\x99Q\xb5\x020\xc4\xb8\x16\xc6\xfa-\xb9U+\xda\\\x126L\xf3~\xbd8\x12q\x02?\x80\xeaVI\xa9\xe1'

# Clé partielle
key_part = b'12345678bien'

# Caractères possibles ASCII seulement les lettres minuscules
possible_chars = map(chr, range(97, 123))

# Test des combinaisons possibles pour compléter la clé
for chars in itertools.product(possible_chars, repeat=4):
    key = key_part + ''.join(chars).encode()
    try:
        plaintext = des_decrypt(key, ciphertext)
        print("Clé trouvée :", key)
        print("Message déchiffré :", plaintext.decode('utf-8'))
        break
    except Exception as e:
        continue


