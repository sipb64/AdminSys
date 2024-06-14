# Réaliser une requête Web GET sur un site Web (Défaut = https://taisen.fr)

$url = "taisen.fr"
$response = Invoke-WebRequest $url

# Afficher l'IP et le nom du serveur DNS qui résout le nom de domaine

$ip = Resolve-DnsName $url -Server 8.8.8.8
$DnsServer = (Get-DnsClientServerAddress -InterfaceAlias "Ethernet 3" -AddressFamily IPv4).serverAddresses | Resolve-DnsName | select NameHost
write-host "Serveur DNS :" $DnsServer[0] "`nIp résolues : " $ip.IPAddress

# Afficher l'IP et le port Source
# Afficher l'IP et le port de destination

Test-NetConnection -ComputerName $ip.IPAddress[-1] -Port 443 
Get-NetTCPConnection -RemoteAddress $ip.IPAddress[-1] | select -Property LocalAddress,LocalPort,RemoteAddress,RemotePort

# Afficher les Headers qui ont un lien avec la sécurité

$response.Headers

# Afficher le Content-Type, s'il est générique, afficher son utilité

$response.Headers |findstr /i content-type

# Stocker dans une variable de type tableau, liste ou dictionnaire les différentes balises Web

$tab = $response.ParsedHtml

# à partir de la question précédente, afficher le titre de niveau 1 (balise h1)

$($response.ParsedHtml.getElementsByTagName("h1")).outerhtml

# Afficher la clé publique du certificat

$request = [Net.HttpWebRequest]::Create("https://$url")
$request.Method = "GET"
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$resp = $request.GetResponse()
$certificate = $request.ServicePoint.Certificate

$certificate | Format-List -Property *

Write-Output "Clé publique : $($certificate.GetPublicKeyString())"

# Afficher le nom de l'autorité qui a signé le certificat

Write-Output "Autorité de certification : $($certificate.Issuer)"

# Afficher la liste des IP des équipements réseau traversés pour atteindre le site Web

get-NetConnection -ComputerName $ip.IPAddress[-1] -TraceRoute