# OLLAMA - Guide d'administration (Bare Metal)
## **Installation**
### Windows GUI / powershell
#### Télécharger et exécuter l'installateur : https://ollama.com/download/OllamaSetup.exe
### Linux
```bash
curl -fsSL https://ollama.com/install.sh | sh
```
#### Gestion du service
```bash
# Vérifier le statut
systemctl status ollama

# Redémarrer après une config
systemctl restart ollama

# Consulter les logs
journalctl -u ollama -f
```
#### Configuration réseau :
```bash
# Editer le service systemd
systemctl edit ollama.service
```
```bash
# Ajouter le bloc 
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
Environment="OLLAMA_ORIGINS=*"
```
```bash
# Appliquer et redémarrer
systemctl daemon-reload
systemctl restart ollama
```
## **Commande de base Commune Linux / Windows**
### Télécharger un modèle
```
ollama pull NomDuModele:Tag
```
### Lancer un modèle
```
ollama run NomDuModele:Tag
```
### Lister les modèles présents
```
ollama ls
```
### Supprimer un modèle
```
ollama rm NomDuModele:Tag
```
## **Mise à jour des modèles**
### Commande powershell pour mettre à jour tous les modeles sur windows
```powershell
ollama list | Select-Object -Skip 1 | ForEach-Object {
    $model = ($_ -split '\s+')[0]
    if ($model -and $model -ne "NAME") {
        Write-Host "Mise à jour du modèle: $model"
        ollama pull $model
    }
}
```
### Commande bash pour mettre à jour tous les modeles sur linux
```bash
ollama list | tail -n +2 | awk '{print $1}' | xargs -r -n1 ollama pull
```