# Template script de base 

```bash
#!/bin/bash

# ==============================================================================
# TITRE          : template.sh
# DESCRIPTION    : Squelette de script Bash robuste avec logs, options et checks.
# AUTEUR         : ethiksys
# DATE           : 2026-01-21
# VERSION        : 1.0.0
# USAGE          : ./template.sh [options]
# ==============================================================================

# --- Configuration (Fail Fast) ---
set -o errexit  # Quitter si une commande échoue (set -e)
set -o nounset  # Quitter si une variable non définie est utilisée (set -u)
set -o pipefail # Quitter si un pipe échoue (ex: cmd1 | cmd2)

# --- Constantes & Couleurs ---
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/tmp/script_$(date +%F).log"

# Couleurs ANSI
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly NC='\033[0m' # No Color

# --- Fonctions Utilitaires ---

log_info() {
    echo -e "${GREEN}[INFO] $(date +'%H:%M:%S') - $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}[WARN] $(date +'%H:%M:%S') - $1${NC}" >&2
}

log_error() {
    echo -e "${RED}[ERROR] $(date +'%H:%M:%S') - $1${NC}" >&2
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Ce script doit être lancé en tant que root (sudo)."
        exit 1
    fi
}

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Description du script ici...

Options:
  -c, --create    Créer la ressource
  -d, --drop      Supprimer la ressource
  -s, --start     Démarrer le service
  -h, --help      Afficher cette aide

Exemple:
  sudo ./$(basename "$0") --create
EOF
    exit 0
}

# --- Logique Principale ---

main() {
    # Variables par défaut
    local action=""

    # Parsing des arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c|--create)
                action="create"
                shift # Passer à l'argument suivant
                ;;
            -d|--drop)
                action="drop"
                shift
                ;;
            -s|--start)
                action="start"
                shift
                ;;
            -h|--help)
                usage
                ;;
            *)
                log_error "Argument inconnu : $1"
                usage
                ;;
        esac
    done

    # Validation
    if [[ -z "$action" ]]; then
        log_error "Aucune action spécifiée."
        usage
    fi

    # Exécution
    log_info "Démarrage du script..."
    
    case "$action" in
        create)
            log_info "Exécution de la création..."
            # Tes commandes ici...
            ;;
        drop)
            log_warn "Attention, suppression en cours..."
            # Tes commandes ici...
            ;;
        start)
            log_info "Démarrage du service..."
            # Tes commandes ici...
            ;;
    esac

    log_info "Terminé avec succès."
}

# --- Point d'entrée ---
# Décommenter si root est requis
# check_root 

main "$@"

```