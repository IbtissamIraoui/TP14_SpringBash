#!/bin/bash
# ─────────────────────────────────────────────────────────────────────
# run.sh  –  Démarre l'application Spring Boot en arrière-plan
# Usage : ./scripts/run.sh
# ─────────────────────────────────────────────────────────────────────

# Répertoire racine du projet (parent du dossier scripts/)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/app.log"
PID_FILE="$LOG_DIR/app.pid"

echo "=================================================="
echo "  Démarrage de l'application Spring Boot"
echo "=================================================="

# Créer le dossier logs s'il n'existe pas
mkdir -p "$LOG_DIR"

# Vérifier si l'application tourne déjà
if [ -f "$PID_FILE" ]; then
    EXISTING_PID=$(cat "$PID_FILE")
    if ps -p "$EXISTING_PID" > /dev/null 2>&1; then
        echo "⚠️  L'application tourne déjà (PID : $EXISTING_PID)"
        echo "   Utilisez ./scripts/stop.sh pour l'arrêter d'abord."
        exit 1
    else
        echo "ℹ️  Ancien PID trouvé mais processus inexistant. Nettoyage..."
        rm -f "$PID_FILE"
    fi
fi

cd "$PROJECT_DIR" || exit 1

# Utiliser le Maven Wrapper (mvnw) au lieu de mvn
if [ -f "./mvnw" ]; then
    echo "📦 Utilisation du Maven Wrapper (./mvnw)"
    MVN_CMD="./mvnw"
elif [ -f "./mvnw.cmd" ]; then
    echo "📦 Utilisation du Maven Wrapper (./mvnw.cmd)"
    MVN_CMD="./mvnw.cmd"
else
    echo "❌ Maven Wrapper non trouvé !"
    exit 1
fi

echo "🚀 Lancement via $MVN_CMD spring-boot:run..."
echo "📄 Logs disponibles dans : $LOG_FILE"
echo ""

# nohup  → survit à la fermeture du terminal
# 2>&1   → redirige stderr vers stdout
# &      → exécution en arrière-plan
# $!     → PID du processus lancé
nohup $MVN_CMD spring-boot:run > "$LOG_FILE" 2>&1 &
APP_PID=$!

# Sauvegarder le PID pour stop.sh
echo "$APP_PID" > "$PID_FILE"

# Petite attente pour vérifier que ça démarre
sleep 5

if ps -p "$APP_PID" > /dev/null 2>&1; then
    echo "✅ Application démarrée avec succès"
    echo "   PID         : $APP_PID"
    echo "   Port        : 8085"
    echo "   URL         : http://localhost:8085"
    echo "   Logs        : $LOG_FILE"
    echo ""
    echo "👉 Pour vérifier les logs : ./scripts/logs.sh"
    echo "👉 Pour arrêter           : ./scripts/stop.sh"
else
    echo "❌ L'application n'a pas démarré correctement"
    echo "   Vérifiez les logs : cat $LOG_FILE"
    rm -f "$PID_FILE"
    exit 1
fi