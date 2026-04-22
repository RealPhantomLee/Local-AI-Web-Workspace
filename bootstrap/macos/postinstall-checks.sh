#!/usr/bin/env bash

set -u

echo "[+] Running macOS post-install checks..."

if command -v docker >/dev/null 2>&1; then
  echo "[OK] docker found: $(docker --version 2>/dev/null || true)"
else
  echo "[!!] docker not found"
fi

if docker compose version >/dev/null 2>&1; then
  echo "[OK] docker compose found: $(docker compose version 2>/dev/null | head -n 1)"
else
  echo "[!!] docker compose not found"
fi

if command -v ollama >/dev/null 2>&1; then
  echo "[OK] ollama found: $(ollama --version 2>/dev/null || true)"
else
  echo "[!!] ollama not found"
fi

if curl -fsS http://127.0.0.1:11434 >/dev/null 2>&1; then
  echo "[OK] Ollama API reachable on 127.0.0.1:11434"
else
  echo "[!!] Ollama API not reachable yet on 127.0.0.1:11434"
fi
