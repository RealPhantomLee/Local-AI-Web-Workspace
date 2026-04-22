#!/usr/bin/env bash

set -u

echo "[+] Optional Tailscale installer for macOS"

if command -v tailscale >/dev/null 2>&1; then
  echo "[=] Tailscale already installed."
  exit 0
fi

if command -v brew >/dev/null 2>&1; then
  brew install --cask tailscale
  echo "[+] Tailscale installed."
  echo "[!] Open the Tailscale app and sign in."
else
  echo "[!] Homebrew not found."
  echo "[!] Install Tailscale manually if needed."
  exit 1
fi
