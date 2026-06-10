#!/bin/bash
# ─────────────────────────────────────────────────────────────────────
# healthcheck.sh  –  Vérifie la disponibilité de l'application
# Usage : ./scripts/healthcheck.sh [--watch]
# ─────────────────────────────────────────────────────────────────────

HOST="http://localhost:8085"
HEALTH_URL="$HOST/actuator/health"
INFO_URL="$HOST/actuator/info"
API_URL="$HOST/api/etudiants"

WATCH=false
[[ "$1" == "--watch" || "$1" == "-w" ]] && WATCH=true

check_once() {
    echo "=================================================="
    echo "  Healthcheck  –  $(date '+%Y-%m-%d %H:%M:%S')"
    echo "=================================================="

    # ── Santé générale ────────────────────────────────────────────────
    echo ""
    echo "🏥 Endpoint /actuator/health :"
    # curl -s  → mode silencieux (pas de barre de progression)
    HEALTH=$(curl -s --max-time 5 "$HEALTH_URL")
    if [ $? -eq 0 ]; then
        echo "$HEALTH" | python3 -m json.tool 2>/dev/null || echo "$HEALTH"
    else
        echo "   ❌ Impossible de joindre $HEALTH_URL"
        echo "   L'application est-elle démarrée ? (./scripts/run.sh)"
        return 1
    fi

    # ── Informations applicatives ─────────────────────────────────────
    echo ""
    echo "ℹ️  Endpoint /actuator/info :"
    INFO=$(curl -s --max-time 5 "$INFO_URL")
    echo "$INFO" | python3 -m json.tool 2>/dev/null || echo "$INFO"

    # ── Test de l'API métier ──────────────────────────────────────────
    echo ""
    echo "👥 Endpoint /api/etudiants :"
    API_RESP=$(curl -s --max-time 5 "$API_URL")
    if [ $? -eq 0 ]; then
        # Compter le nombre d'étudiants retournés
        COUNT=$(echo "$API_RESP" | python3 -c "import sys,json; print(len(json.load(sys.stdin)))" 2>/dev/null)
        echo "   ✅ API accessible — $COUNT étudiant(s) en base"
    else
        echo "   ❌ API non accessible"
    fi

    echo ""
    echo "=================================================="
}

if $WATCH; then
    echo "👀 Mode surveillance — vérification toutes les 10 secondes (Ctrl+C pour quitter)"
    while true; do
        check_once
        sleep 10
    done
else
    check_once
fi
