#!/bin/bash
# ─────────────────────────────────────────────────────────────────────
# stop.sh  –  Arrête l'application Spring Boot en cours d'exécution
# Usage : ./scripts/stop.sh
# ─────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PID_FILE="$PROJECT_DIR/logs/app.pid"

echo "=================================================="
echo "  Arrêt de l'application Spring Boot"
echo "=================================================="

# ── Méthode 1 : via le fichier PID sauvegardé par run.sh ─────────────
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "🔍 Processus trouvé via PID file (PID : $PID)"
        kill -15 "$PID"          # SIGTERM : arrêt propre
        sleep 2

        # Si toujours actif, forcer l'arrêt
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "⚠️  Processus résistant, envoi SIGKILL..."
            kill -9 "$PID"
        fi

        rm -f "$PID_FILE"
        echo "✅ Processus $PID arrêté avec succès."
        exit 0
    else
        echo "ℹ️  PID file présent mais processus $PID inexistant."
        rm -f "$PID_FILE"
    fi
fi

# ── Méthode 2 : recherche par nom de processus (plus large) ──────────
# Chercher plusieurs patterns
PIDS=$(ps aux | grep -E 'spring-boot:run|springbash.jar|mvnw' | grep -v grep | awk '{print $2}')

if [ -z "$PIDS" ]; then
    echo "ℹ️  Aucun processus Spring Boot trouvé."
    exit 0
fi

for PID in $PIDS; do
    echo "🔍 Processus trouvé (PID : $PID)"
    kill -9 "$PID" 2>/dev/null
    echo "✅ Processus $PID arrêté"
done

# Nettoyer les fichiers PID
rm -f "$PROJECT_DIR/logs/app.pid" "$PROJECT_DIR/logs/deploy.pid"