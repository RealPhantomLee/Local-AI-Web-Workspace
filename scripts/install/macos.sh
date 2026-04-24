#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
command -v git >/dev/null 2>&1 || { echo "[-] Missing required command: git"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "[-] Missing required command: docker"; exit 1; }
command -v ollama >/dev/null 2>&1 || { echo "[-] Missing required command: ollama"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "[-] Docker Compose is not available."; exit 1; }
echo "[+] Prerequisites verified."
echo "[+] Starting Docker stack..."
docker compose up -d
echo "[+] Current containers:"
docker ps
echo "[+] Ollama models:"
ollama list || true
echo "[+] macOS install routine complete."
