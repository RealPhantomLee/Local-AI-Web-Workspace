#!/usr/bin/env bash

set -u

echo "[+] macOS Ollama helper"

if command -v ollama >/dev/null 2>&1; then
  echo "[=] Ollama already available."
  exit 0
fi

if command -v brew >/dev/null 2>&1; then
  echo "[+] Installing Ollama with Homebrew..."
  brew install ollama
  echo "[!] Start Ollama if needed, then re-run bootstrap."
else
  echo "[!] Homebrew not found."
  echo "[!] Install Ollama manually, then re-run bootstrap."
  exit 1
fi
