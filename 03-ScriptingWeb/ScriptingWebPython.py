#coding:utf-8

"""
Réaliser une requête Web GET sur un site Web (Defaut = https://taisen.fr)
Afficher l'IP et le nom du serveur DNS qui résout le nom de domaine
Afficher l'IP et le port Source
Afficher l'IP et le port de destination
Afficher les Headers, si le header est connu, alors afficher son utilité
Afficher le Content-Type, s'il est générique, afficher son utilité
Stocker dans une variable de type tableau / Array les différentes balises Web
Afficher les différents éléments du certificat
Afficher les noms de certificats de la chaine de confiance
Afficher la liste des IP équipements réseaux traversés pour atteindre le site Web
"""

# Réaliser une requête Web GET sur un site Web (Defaut = https://taisen.fr)

import requests                                     # Importation du module requests

url = input("Taper l'url du site (http://nomdusite.extension) -> ")                          # Définir l'URL dans une variable

rget = requests.get(url)                            # Effectuer une requête GET stockée dans la variable rget

print(f"        La requête GET de {url} est {rget}")       #Afficher les infos

# Afficher l'IP et le nom du serveur DNS qui résout le nom de domaine

import socket                                       # Importation du module socket

domaine = input("Taper le nom de domaine (exemple.com) -> ")
# Obtenir l'adresse IP pour le nom de domaine
adresseIP = socket.gethostbyname(domaine)
print(" Son Adresse IP est ", adresseIP)



                                   # Importation du module dns.resolver
#import dns.name
import dns.resolver
"""
domaine = dns.name.from_text('example.com')
answer = dns.resolver.query(n,'A')
for rdata in answer:
    print(rdata.to_text())
"""
# Obtenir le nom du serveur DNS qui a résolu le nom de domaine
resolver = dns.resolver.Resolver()
resolver.nameservers = ['8.8.8.8'] # utiliser le DNS de Google pour éviter les problèmes de cache
answer = resolver.resolve(domain_name, 'A')
dns_server = answer.rrset.source
print("Serveur DNS :", dns_server)
