# OLLAMA Linux/Windows
## **Installation**
### Windows
#### Télécharger et installer l'executable https://ollama.com/download/OllamaSetup.exe
### Linux
```
curl -fsSL https://ollama.com/install.sh | sh
```
## **Commande de base**
### Télécharger un modèle
```
ollama pull NomDuModele:Poids
```
### Lancer un modèle
```
ollama run NomDuModele:Poids
```
### Lister les modèles présents
```
ollama ls
```
### Supprimer un modèle
```
ollama rm NomDuModele:Poids
```
## **Mise à jour des modèles**
### Commande powershell pour mettre à jour tous les modeles sur windows
```
ollama list | Select-Object -Skip 1 | ForEach-Object {
    $model = ($_ -split '\s+')[0]
    if ($model -and $model -ne "NAME") {
        Write-Host "Mise à jour du modèle: $model"
        ollama pull $model
    }
}
```
### Commande bash pour mettre à jour tous les modeles sur linux
```
ollama list | tail -n +2 | awk '{print $1}' | xargs -I {} sh -c 'echo "Mise à jour du modèle : {}"; ollama pull {}; echo "—"'
```