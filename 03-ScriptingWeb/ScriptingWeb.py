#coding:utf-8

import socket
import ssl
import requests
#from bs4 import BeautifulSoup

# Définir l'URL dans une variable
url = "https://taisen.fr"

# Effectuer une requête GET
response = requests.get(url)

