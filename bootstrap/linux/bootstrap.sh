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
USER_NAME="${SUDO_USER:-$USER}"

echo "[+] Local-AI-Web-Workspace Linux bootstrap"
echo "[+] Repo root: $REPO_ROOT"
echo

if [ ! -f "$COMPOSE_FILE" ]; then
  echo "[!] Missing compose file: $COMPOSE_FILE"
  echo "[!] Run Step 4 first."
  exit 1
fi

detect_pm() {
  if command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  elif command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  else
    echo "unknown"
  fi
}

ensure_sudo() {
  if [ "$(id -u)" -eq 0 ]; then
    echo "[!] Run this as your normal user, not root."
    exit 1
  fi

  if ! command -v sudo >/dev/null 2>&1; then
    echo "[!] sudo is required."
    exit 1
  fi

  echo "[+] sudo check..."
  sudo -v
}

write_local_env() {
  echo "[+] Writing local env files..."

  mkdir -p "$COMPOSE_DIR/env" "$REPO_ROOT/docker-data/anythingllm/storage" "$REPO_ROOT/docker-data/homarr/appdata"

  if [ ! -f "$ENV_FILE" ]; then
    HOMARR_SECRET="$(openssl rand -hex 32 2>/dev/null || python - <<'PYTHON_SECRET'
import secrets
print(secrets.token_hex(32))
PYTHON_SECRET
)"
    cat > "$ENV_FILE" <<ENV_LOCAL
# Local runtime values for Linux
# Do not commit this file.

ANYTHINGLLM_PORT=3001
DASHBOARD_PORT=7575
OLLAMA_HOST=http://172.17.0.1:11434
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
    echo "[+] Docker not found. Running installer..."
    bash "$SCRIPT_DIR/install-docker.sh"
  fi

  if docker compose version >/dev/null 2>&1; then
    echo "[=] Docker Compose plugin available."
  else
    echo "[!] Docker Compose plugin not detected."
    echo "[!] Install Docker Compose plugin/package, then re-run."
    exit 1
  fi

  echo "[+] Enabling Docker service..."
  sudo systemctl enable --now docker

  if groups "$USER_NAME" | grep -qw docker; then
    echo "[=] User already in docker group."
  else
    echo "[!] User '$USER_NAME' is not in the docker group."
    echo "[!] To allow docker without sudo, run:"
    echo "    sudo usermod -aG docker $USER_NAME"
    echo "    newgrp docker"
    echo
    echo "[!] Continuing with sudo for Docker commands in this bootstrap."
  fi
}

install_ollama_if_needed() {
  if command -v ollama >/dev/null 2>&1; then
    echo "[=] Ollama already installed."
  else
    echo "[+] Ollama not found. Running installer..."
    bash "$SCRIPT_DIR/install-ollama.sh"
  fi

  echo "[+] Enabling Ollama service if present..."
  sudo systemctl enable --now ollama 2>/dev/null || true

  if systemctl is-active --quiet ollama 2>/dev/null; then
    echo "[=] Ollama service is active."
  else
    echo "[!] Ollama service not active via systemd."
    echo "[!] You may need to run 'ollama serve' manually in another terminal."
  fi
}

start_stack() {
  echo "[+] Starting core stack..."
  if groups "$USER_NAME" | grep -qw docker; then
    docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" up -d
  else
    sudo docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" up -d
  fi
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
  ensure_sudo
  PM="$(detect_pm)"
  echo "[+] Package manager detected: $PM"

  write_local_env
  install_docker_if_needed
  install_ollama_if_needed
  bash "$SCRIPT_DIR/postinstall-checks.sh" || true
  start_stack
  show_urls

  echo "[+] Linux bootstrap complete."
  echo "[+] Next recommended step: validate the services in a browser."
}

main "$@"
