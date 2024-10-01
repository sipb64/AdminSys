# Attaque

apt install nmap hydra hping3 curl
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall

nmap -sS 10.0.0.109

<p align="center">
    <img src="./NmapLoic.png" alt="snort" style="width: 800px;" />
</p>

hydra -l user -P /root/passwords.txt -t 4 -vV ssh://10.0.0.109

<p align="center">
    <img src="./HydraLoic.png" alt="snort" style="width: 800px;" />
</p>

hping3 -S -p 22 --flood 10.0.0.109

<p align="center">
    <img src="./HpingLoic.png" alt="snort" style="width: 800px;" />
</p>

# Defense

Log Nmap

<p align="center">
    <img src="./LogNmapLayilla.png" alt="snort" style="width: 800px;" />
</p>

Log Ddos

<p align="center">
    <img src="./DDOS.png" alt="snort" style="width: 800px;" />
</p>

nano /root/snort3/lua/rules/local.rules 

alert tcp any any -> any any (msg:"Scan de ports détecté"; flags:S; detection_filter:track by_src, count 20, seconds 60; sid>

alert tcp any any -> any 22 (msg:"Tentative de connexion SSH suspecte"; flags:S; sid:1000002; rev:1;)

alert tcp any any -> any any (msg:"Tentative d'exploitation détectée"; content:"|90 90 90|"; sid:1000003; rev:1;)

snort -c /root/snort3/lua/snort.lua -R /root/snort3/lua/rules/local.rules -i ens18 -A alert_fast -l /var/log/snort

######
#
######
# NMAP
alert tcp any any -> any any (msg:"Scan Nmap SYN détecté"; flags:S; detection_filter:track by_src, count 5, seconds 10; sid:>


alert tcp any any -> any any (msg:"Scan Nmap FIN détecté"; flags:F; detection_filter:track by_src, count 5, seconds 10; sid:>alert udp any any -> any any (msg:"Scan Nmap UDP détecté"; detection_filter:track by_src, count 5, seconds 10; sid:2000003; >

# SSH

alert tcp any any -> any 22 (msg:"Hydra SSH force brute détecté"; flow:to_server,established; content:"SSH"; detection_filte>alert tcp any any -> any 22 (msg:"Hydra SSH force brute détecté - Échec d'authentification"; flow:to_server,established; con>


# Hping

alert icmp any any -> any any (msg:"DDoS ICMP avec hping3 détecté"; detection_filter:track by_src, count 100, seconds 1; sid>

alert tcp any any -> any any (msg:"DDoS SYN flood avec hping3 détecté"; flags:S; detection_filter:track by_src, count 100, s>


# Metasploit

alert tcp any any -> any 445 (msg:"Tentative d'exploitation SMB avec Metasploit détectée"; flow:to_server,established; conte>


alert tcp any any -> any any (msg:"Payload Meterpreter détecté"; flow:to_server,established; content:"|90 90 90 90|"; sid:20>
