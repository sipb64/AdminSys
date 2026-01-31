### Utilisation de `ufw`

1. **Autoriser le trafic entrant d'un réseau spécifique** :
   ```sh
   sudo ufw allow from 192.168.5.0/24
   ```

2. **Autoriser le trafic sortant vers un réseau spécifique** :
   ```sh
   sudo ufw allow out to 192.168.5.0/24
   ```
3. **Activer `ufw` si ce n'est pas déjà fait** :
   ```sh
   sudo ufw enable
   ```

4. **Vérifier les règles `ufw`** :
   ```sh
   sudo ufw status
   ```
