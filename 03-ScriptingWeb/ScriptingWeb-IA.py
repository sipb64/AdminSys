#coding:utf-8

import socket
import ssl
import requests
from bs4 import BeautifulSoup

# Définir l'URL dans une variable
url = "https://taisen.fr"

# Effectuer une requête GET
response = requests.get(url)

# Afficher l'IP et le nom du serveur DNS qui résout le nom de domaine
dns_server = socket.getaddrinfo(socket.gethostname(), None)[0][-1]
print(f"IP du serveur DNS : {dns_server}")
print(f"Nom du serveur DNS : {socket.gethostbyaddr(dns_server)[0]}")

# Afficher l'IP et le port Source
source_ip = socket.gethostbyname(socket.gethostname())
print(f"IP source : {source_ip}")
source_port = response.request.headers.get('X-Forwarded-Port')
print(f"Port source : {source_port if source_port else 'Inconnu'}")

# Afficher l'IP et le port de destination
destination_ip = socket.gethostbyname(response.url.split("//")[-1].split("/")[0])
print(f"IP de destination : {destination_ip}")
destination_port = response.request.port
print(f"Port de destination : {destination_port}")

# Afficher les Headers
headers = response.headers
for header, value in headers.items():
    print(f"{header} : {value}")

# Afficher le Content-Type et son utilité
content_type = headers.get("Content-Type")
print(f"Content-Type : {content_type}")
print("Utilité : Le Content-Type indique au navigateur le type de données à afficher.")

# Stocker les différentes balises Web
soup = BeautifulSoup(response.content, 'html.parser')
tags = soup.find_all(True)
tag_names = [tag.name for tag in tags]

# Afficher les différents éléments du certificat
certificate = ssl.get_server_certificate((destination_ip, destination_port))
print("Certificat :")
print(certificate.decode('utf-8'))

# Afficher les noms de certificats de la chaine de confiance
chain_certificates = ssl.create_default_context().wrap_socket(socket.socket()).connect((destination_ip, destination_port)).getpeercert(binary_form=True)
chain_names = [cert.subject.get_components()[1].value for cert in chain_certificates]
print("Noms de certificats dans la chaine de confiance :")
print(chain_names)

# Afficher la liste des IP équipements réseaux traversés pour atteindre le site Web
traceroute_result = os.popen(f"traceroute {destination_ip}").read()
print("IP des équipements réseaux traversés :")
print(traceroute_result)