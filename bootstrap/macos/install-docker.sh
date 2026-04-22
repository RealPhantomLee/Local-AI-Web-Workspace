#!/usr/bin/env bash

set -u

echo "[+] macOS Docker helper"

if command -v docker >/dev/null 2>&1; then
  echo "[=] Docker already available."
  exit 0
fi

if command -v brew >/dev/null 2>&1; then
  echo "[+] Homebrew detected."
  echo "[+] Installing Docker Desktop cask..."
  brew install --cask docker
  echo "[!] Launch Docker Desktop once, allow permissions, then re-run bootstrap if needed."
else
  echo "[!] Homebrew not found."
  echo "[!] Install Docker Desktop manually, then re-run bootstrap."
  exit 1
fi
