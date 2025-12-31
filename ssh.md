# Connexion SSH par clés privées/publiques

## Génération des clés communs windows/linux

```Bash/Powershell
ssh-keygen -t ed25519
```

## Linux SSH copy id

```Bash
ssh-copy-id user@ip.du.srv.distant
```

## Windows SSH copy id

```Powershell
Get-Content C:\users\USER\.ssh\id_ed25519.pub | ssh user@ip.du.srv.distant "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

## Retirer un serveur du fichier known_hosts

```Bash/Powershell
ssh-keygen -R IPouNom.du.serveur
```

