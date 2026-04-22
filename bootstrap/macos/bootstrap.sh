#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

COMPOSE_DIR="$REPO_ROOT/compose/core"
COMPOSE_FILE="$COMPOSE_DIR/compose.yaml"
ENV_FILE="$REPO_ROOT/.env"
ANYTHING_ENV="$COMPOSE_DIR/env/anythingllm.env"
DASHBOARD_ENV="$COMPOSE_DIR/env/dashboard.env"

APP_UID="$(id -u)"
APP_GID="$(id -g)"

echo "[+] Local-AI-Web-Workspace macOS bootstrap"
echo "[+] Repo root: $REPO_ROOT"
echo

if [ ! -f "$COMPOSE_FILE" ]; then
  echo "[!] Missing compose file: $COMPOSE_FILE"
  echo "[!] Run Step 4 first."
  exit 1
fi

write_local_env() {
  echo "[+] Writing local env files..."

  mkdir -p "$COMPOSE_DIR/env" "$REPO_ROOT/docker-data/anythingllm/storage" "$REPO_ROOT/docker-data/homarr/appdata"

  if [ ! -f "$ENV_FILE" ]; then
    HOMARR_SECRET="$(openssl rand -hex 32 2>/dev/null || python3 - <<'PYTHON_SECRET'
import secrets
print(secrets.token_hex(32))
PYTHON_SECRET
)"
    cat > "$ENV_FILE" <<ENV_LOCAL
# Local runtime values for macOS
# Do not commit this file.

ANYTHINGLLM_PORT=3001
DASHBOARD_PORT=7575
OLLAMA_HOST=http://host.docker.internal:11434
APP_UID=$APP_UID
APP_GID=$APP_GID
HOMARR_SECRET_ENCRYPTION_KEY=$HOMARR_SECRET
ENV_LOCAL
    echo "[+] Created $ENV_FILE"
  else
    echo "[=] Keeping existing $ENV_FILE"
  fi

  if [ ! -f "$ANYTHING_ENV" ]; then
    cat > "$ANYTHING_ENV" <<'ANYTHING_ENV_FILE'
# Local AnythingLLM env overrides if needed.
# Keep real values private. Do not commit this file.
ANYTHING_ENV_FILE
    echo "[+] Created $ANYTHING_ENV"
  else
    echo "[=] Keeping existing $ANYTHING_ENV"
  fi

  if [ ! -f "$DASHBOARD_ENV" ]; then
    cat > "$DASHBOARD_ENV" <<'DASHBOARD_ENV_FILE'
# Local dashboard env overrides if needed.
# Keep real values private. Do not commit this file.
DASHBOARD_ENV_FILE
    echo "[+] Created $DASHBOARD_ENV"
  else
    echo "[=] Keeping existing $DASHBOARD_ENV"
  fi
}

install_docker_if_needed() {
  if command -v docker >/dev/null 2>&1; then
    echo "[=] Docker already installed."
  else
    echo "[+] Docker not found. Running installer helper..."
    bash "$SCRIPT_DIR/install-docker.sh"
  fi

  if docker compose version >/dev/null 2>&1; then
    echo "[=] Docker Compose available."
  else
    echo "[!] Docker Compose not detected."
    echo "[!] Start Docker Desktop and verify installation, then re-run."
    exit 1
  fi
}

install_ollama_if_needed() {
  if command -v ollama >/dev/null 2>&1; then
    echo "[=] Ollama already installed."
  else
    echo "[+] Ollama not found. Running installer helper..."
    bash "$SCRIPT_DIR/install-ollama.sh"
  fi
}

start_stack() {
  echo "[+] Starting core stack..."
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" up -d
}

show_urls() {
  ANYTHING_PORT="$(grep '^ANYTHINGLLM_PORT=' "$ENV_FILE" | cut -d= -f2)"
  DASHBOARD_PORT="$(grep '^DASHBOARD_PORT=' "$ENV_FILE" | cut -d= -f2)"

  echo
  echo "[+] Local URLs"
  echo "    AnythingLLM : http://localhost:${ANYTHING_PORT:-3001}"
  echo "    Dashboard   : http://localhost:${DASHBOARD_PORT:-7575}"
  echo "    Ollama API  : http://127.0.0.1:11434"
  echo
}

main() {
  write_local_env
  install_docker_if_needed
  install_ollama_if_needed
  bash "$SCRIPT_DIR/postinstall-checks.sh" || true
  start_stack
  show_urls
  echo "[+] macOS bootstrap complete."
}

main "$@"
