# Réaliser une requête Web GET sur un site Web

# Définir la variable site le site de la requête
$Site = "taisen.fr"

# Effectuer la requête Web GET
$Reponse = Invoke-WebRequest -Uri $Site

# Afficher le contenu de la réponse status du site

#Write-Output $Reponse.Content  # Tout le contenu html du site

Write-Host "Statut HTTP : $($Reponse.StatusCode)"

# Afficher l'IP et le nom du serveur DNS qui résout le nom de domaine

# Nom de domaine par défaut
$Domaine = "taisen.fr"

# Obtenir les informations DNS pour le domaine
$InfoDNS = Resolve-DnsName -Name $Domaine

# Afficher l'adresse IP du site
Write-Host "Adresses IP du site: $($InfoDNS.IPAddress)"

# Obtenir les informations sur le serveur DNS utilisé par le système
$SrvDNS = Get-DnsClientServerAddress -AddressFamily IPv4

# Afficher les serveurs DNS qui résout le nom de domaine
Write-Host "Serveurs DNS : $($SrvDNS.ServerAddresses)"

# Afficher l'IP et le port source
$IPsource = (Test-Connection -ComputerName (hostname) -Count 1).IPV4Address.IPAddressToString
$Portsource = $IPsource.BaseResponse.ResponseUri.Port
Write-Host "IP source: $IPsource"
Write-Host "Port source: $Portsource"

# Afficher l'IP et le port de destination
$IPdestination = $Reponse.BaseResponse.ResponseUri.Host
$Portdestination = $Reponse.BaseResponse.ResponseUri.Port
Write-Host "IP de destination: $IPdestination"
Write-Host "Port de destination: $Portdestination"

# Afficher les Headers et leur utilité
foreach ($header in $Reponse.Headers.Keys) {
    Write-Host "$header : $($Reponse.Headers[$header])"
    switch ($header) {
        "Date" { Write-Host "Indique la date et l'heure à laquelle le message a été généré" }
        "Server" { Write-Host "Indique le nom et la version du serveur HTTP" }
        "Last-Modified" { Write-Host "Indique la date et l'heure de la derniere modification du document" }
        "Content-Type" { Write-Host "Indique le type MIME du document" }
        "Content-Length" { Write-Host "Indique la taille du document en octets" }
        default { Write-Host "Inconnue" }
    }
}

# Afficher le Content-Type et son utilité
$TypeContenu = $Reponse.Headers["Content-Type"]
Write-Host "Content-Type : $TypeContenu"
switch ($TypeContenu) {
    "text/html; charset=utf-8" { Write-Host "Indique que le document est une page HTML et son format de caractère" }
    "image/jpeg" { Write-Host "Indique que le document est une image JPEG" }
    "application/pdf" { Write-Host "Indique que le document est un fichier PDF"}
    default { Write-Host "Non connu"}
}

# Stocker les balises Web dans un tableau

$BalisesWeb = [System.Text.RegularExpressions.Regex]::Matches($Reponse.Content, "<[^>]+>") | ForEach-Object { $_.Value }
Write-Host "Balises Web :" 
$BalisesWeb

# Afficher la liste des IP des équipements réseau traversés
$trace = Test-NetConnection -ComputerName $Domaine -TraceRoute
Write-Host "Equipements reseau traverses :"
$trace.TraceRoute 

# Créer une requête Web
$request = [System.Net.HttpWebRequest]::Create($Site)
$request.Method = "GET"
$request.AllowAutoRedirect = $false

# Obtenir le certificat
$certificate = $request.ServicePoint.Certificate

# Convertir le certificat en un objet X509Certificate2 pour obtenir plus d'informations
$cert2 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $certificate

# Afficher les informations du certificat
Write-Host "Informations du certificat"
Write-Output "Subject: $($cert2.Subject)"
Write-Output "Issuer: $($cert2.Issuer)"
Write-Output "Valid From: $($cert2.NotBefore)"
Write-Output "Valid Until: $($cert2.NotAfter)"
Write-Output "Thumbprint: $($cert2.Thumbprint)"