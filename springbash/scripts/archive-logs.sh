#!/bin/bash
# ─────────────────────────────────────────────────────────────────────
# archive-logs.sh  –  Archive et compresse les fichiers de logs
# Usage : ./scripts/archive-logs.sh
# ─────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs"
ARCHIVE_DIR="$PROJECT_DIR/logs/archives"

echo "=================================================="
echo "  Archivage des logs"
echo "=================================================="

mkdir -p "$ARCHIVE_DIR"

# Nom de l'archive horodatée
# date +%Y%m%d_%H%M%S → ex: 20250522_143000
ARCHIVE_NAME="logs_$(date +%Y%m%d_%H%M%S).tar.gz"
ARCHIVE_PATH="$ARCHIVE_DIR/$ARCHIVE_NAME"

# Fichiers à archiver (hors archives elles-mêmes)
LOG_FILES=$(find "$LOG_DIR" -maxdepth 1 -name "*.log" 2>/dev/null)

if [ -z "$LOG_FILES" ]; then
    echo "ℹ️  Aucun fichier .log trouvé dans $LOG_DIR"
    exit 0
fi

echo "📦 Création de l'archive : $ARCHIVE_NAME"
echo "   Fichiers inclus :"

for f in $LOG_FILES; do
    echo "   • $(basename "$f")"
done

# tar -czf  → créer (-c) une archive gzip (-z) dans le fichier (-f)
tar -czf "$ARCHIVE_PATH" -C "$LOG_DIR" $(basename -a $LOG_FILES)

if [ $? -eq 0 ]; then
    SIZE=$(du -sh "$ARCHIVE_PATH" | awk '{print $1}')
    echo ""
    echo "✅ Archive créée : $ARCHIVE_PATH ($SIZE)"

    # Optionnel : vider les logs après archivage
    read -r -p "🗑️  Vider les fichiers .log originaux ? [o/N] " CONFIRM
    if [[ "$CONFIRM" =~ ^[oO]$ ]]; then
        for f in $LOG_FILES; do
            > "$f"   # Vide le fichier sans le supprimer
            echo "   ✓ $f vidé"
        done
        echo "✅ Logs vidés."
    fi
else
    echo "❌ Échec de la création de l'archive."
    exit 1
fi
