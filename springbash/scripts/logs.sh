#!/bin/bash
# ─────────────────────────────────────────────────────────────────────
# logs.sh  –  Affiche et surveille les logs de l'application
# Usage : ./scripts/logs.sh [--follow] [--lines N] [--errors]
# ─────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_DIR/logs/app.log"

# Valeurs par défaut
LINES=30
FOLLOW=false
ERRORS_ONLY=false

# ── Parsing des arguments ─────────────────────────────────────────────
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --follow|-f)   FOLLOW=true ;;
        --errors|-e)   ERRORS_ONLY=true ;;
        --lines|-n)    LINES="$2"; shift ;;
        *)             echo "Option inconnue : $1"; exit 1 ;;
    esac
    shift
done

echo "=================================================="
echo "  Logs de l'application Spring Boot"
echo "  Fichier : $LOG_FILE"
echo "=================================================="

# Vérifier que le fichier de logs existe
if [ ! -f "$LOG_FILE" ]; then
    echo "⚠️  Fichier de logs introuvable : $LOG_FILE"
    echo "   L'application a-t-elle été démarrée avec run.sh ?"
    exit 1
fi

if $ERRORS_ONLY; then
    echo "🔴 Affichage des erreurs uniquement :"
    echo ""
    # grep -i filtre sans tenir compte de la casse
    grep -i "error\|exception\|warn" "$LOG_FILE" | tail -n "$LINES"

elif $FOLLOW; then
    echo "👀 Suivi en temps réel (Ctrl+C pour quitter) :"
    echo ""
    # tail -f suit le fichier en temps réel
    tail -f "$LOG_FILE"

else
    echo "📋 Dernières $LINES lignes :"
    echo ""
    tail -n "$LINES" "$LOG_FILE"
fi
