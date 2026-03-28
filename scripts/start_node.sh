#!/bin/zsh
set -euo pipefail

WORKDIR="/Users/emre/Dergah"
PYTHON_BIN="$WORKDIR/.venv/bin/python"

ROLE="${1:-orchestrator}"
MODE="${2:-panel}"

case "$ROLE" in
  orchestrator)
    ENV_FILE="$WORKDIR/.env.m5-orchestrator.example"
    ;;
  worker1)
    ENV_FILE="$WORKDIR/.env.worker1.example"
    ;;
  worker2)
    ENV_FILE="$WORKDIR/.env.worker2.example"
    ;;
  *)
    echo "Bilinmeyen rol: $ROLE"
    echo "Kullanim: scripts/start_node.sh [orchestrator|worker1|worker2] [panel|core|operator|openclaw]"
    exit 1
    ;;
esac

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Env dosyasi bulunamadi: $ENV_FILE"
  exit 1
fi

# shellcheck source=/dev/null
source "$ENV_FILE"

cd "$WORKDIR"

start_panel() {
  pkill -f "scripts/dervis_panel.py" >/dev/null 2>&1 || true
  sleep 0.3
  nohup "$PYTHON_BIN" "$WORKDIR/scripts/dervis_panel.py" >/tmp/dervis_panel.log 2>&1 &
  disown
  echo "Panel baslatildi: /tmp/dervis_panel.log"
}

start_core() {
  pkill -f "scripts/dervis_core.py" >/dev/null 2>&1 || true
  sleep 0.3
  nohup "$PYTHON_BIN" "$WORKDIR/scripts/dervis_core.py" >/tmp/dervis_core.log 2>&1 &
  disown
  echo "Core baslatildi: /tmp/dervis_core.log"
}

start_operator() {
  pkill -f "scripts/dervis_operator.py" >/dev/null 2>&1 || true
  sleep 0.3
  nohup "$PYTHON_BIN" "$WORKDIR/scripts/dervis_operator.py" >/tmp/dervis_operator.log 2>&1 &
  disown
  echo "Operator baslatildi: /tmp/dervis_operator.log"
}

start_openclaw() {
  if [[ -n "${OPENCLAW_BIN:-}" && -x "${OPENCLAW_BIN}" ]]; then
    nohup "${OPENCLAW_BIN}" >/tmp/openclaw.log 2>&1 &
    disown
    echo "OPENCLAW_BIN ile openclaw baslatildi: /tmp/openclaw.log"
    return
  fi

  if command -v openclaw >/dev/null 2>&1; then
    nohup openclaw >/tmp/openclaw.log 2>&1 &
    disown
    echo "openclaw baslatildi: /tmp/openclaw.log"
    return
  fi

  if "$PYTHON_BIN" -m openclaw --help >/dev/null 2>&1; then
    nohup "$PYTHON_BIN" -m openclaw >/tmp/openclaw.log 2>&1 &
    disown
    echo "python -m openclaw baslatildi: /tmp/openclaw.log"
    return
  fi

  echo "openclaw komutu bulunamadi."
  echo "Not: pip ile kurulu openclaw paketi bu ortamda CLI/entrypoint saglamiyor."
  echo "Cozum: resmi kurulum scriptiyle CLI kur veya OPENCLAW_BIN degiskenini tanimla."
  echo "Ornek: export OPENCLAW_BIN=\"/usr/local/bin/openclaw\""
  exit 1
}

case "$MODE" in
  panel)
    start_panel
    ;;
  core)
    start_core
    ;;
  operator)
    start_operator
    ;;
  openclaw)
    start_openclaw
    ;;
  *)
    echo "Bilinmeyen mod: $MODE"
    echo "Kullanim: scripts/start_node.sh [orchestrator|worker1|worker2] [panel|core|operator|openclaw]"
    exit 1
    ;;
esac

echo "ROL=$ROLE MODE=$MODE NODE=${DERGAH_NODE_NAME:-unknown} PROVIDER=${DERGAH_LLM_PROVIDER:-unset} MODEL=${DERGAH_MODEL_NAME:-unset}"
