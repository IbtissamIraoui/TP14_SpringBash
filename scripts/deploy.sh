#!/bin/bash
# ─────────────────────────────────────────────────────────────────────
# deploy.sh  –  Compile et déploie une nouvelle version de l'application
# Usage : ./scripts/deploy.sh
# ─────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs"
DEPLOY_LOG="$LOG_DIR/deploy.log"
PID_FILE="$LOG_DIR/deploy.pid"
JAR="$PROJECT_DIR/target/springbash.jar"

echo "=================================================="
echo "  Déploiement de l'application Spring Boot"
echo "  $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================================="

mkdir -p "$LOG_DIR"

# ── Étape 1 : Arrêter la version précédente ───────────────────────────
echo ""
echo "🛑 Étape 1/3 : Arrêt de la version précédente..."
"$SCRIPT_DIR/stop.sh"
sleep 1

# ── Étape 2 : Compilation avec Maven Wrapper ─────────────────────────
echo ""
echo "🔨 Étape 2/3 : Compilation Maven..."
cd "$PROJECT_DIR" || exit 1

# Utiliser le Maven Wrapper
if [ -f "./mvnw" ]; then
    MVN_CMD="./mvnw"
    echo "📦 Utilisation du Maven Wrapper (./mvnw)"
elif [ -f "./mvnw.cmd" ]; then
    MVN_CMD="./mvnw.cmd"
    echo "📦 Utilisation du Maven Wrapper (./mvnw.cmd)"
else
    echo "❌ Maven Wrapper non trouvé !"
    exit 1
fi

echo "   Commande : $MVN_CMD clean package -DskipTests"
echo ""

if $MVN_CMD clean package -DskipTests; then
    echo ""
    echo "✅ Compilation réussie"
    echo "   JAR généré : $JAR"
else
    echo ""
    echo "❌ Échec de la compilation. Déploiement annulé."
    exit 1
fi

# ── Étape 3 : Lancement du JAR ────────────────────────────────────────
echo ""
echo "🚀 Étape 3/3 : Lancement du nouveau JAR..."
echo "   Logs de déploiement : $DEPLOY_LOG"
echo ""

nohup java -jar "$JAR" > "$DEPLOY_LOG" 2>&1 &
DEPLOY_PID=$!

echo "$DEPLOY_PID" > "$PID_FILE"

echo "✅ Nouvelle version déployée avec succès"
echo "   PID     : $DEPLOY_PID"
echo "   Port    : 8085"
echo "   URL     : http://localhost:8085"
echo "   Logs    : $DEPLOY_LOG"
echo ""
echo "👉 Attendre ~15 secondes puis : ./scripts/healthcheck.sh"