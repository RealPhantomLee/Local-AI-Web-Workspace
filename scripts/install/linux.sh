#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

command -v git    >/dev/null 2>&1 || { echo "[-] Missing required command: git";    exit 1; }
command -v docker >/dev/null 2>&1 || { echo "[-] Missing required command: docker"; exit 1; }
command -v ollama >/dev/null 2>&1 || { echo "[-] Missing required command: ollama"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "[-] Docker Compose is not available."; exit 1; }
echo "[+] Prerequisites verified."

if [ ! -f ".env" ]; then
  if [ -f ".env.example" ]; then
    cp .env.example .env
    echo "[+] Copied .env.example to .env — review it before long-term use."
  else
    echo "[-] .env.example not found. Cannot create .env."
    exit 1
  fi
else
  echo "[*] .env already exists, skipping copy."
fi

echo "[+] Starting Docker stack..."
docker compose -f compose/docker-compose.yml up -d

echo "[+] Stack status:"
docker compose -f compose/docker-compose.yml ps

echo "[+] Ollama models:"
ollama list || true

echo ""
echo "[+] Linux install complete."
echo "    AnythingLLM : http://localhost:3001"
echo "    Homarr      : http://localhost:7575"
echo "    Ollama API  : http://localhost:11434"
echo ""
echo "    Next: pull a model with 'ollama pull gemma3:latest'"
