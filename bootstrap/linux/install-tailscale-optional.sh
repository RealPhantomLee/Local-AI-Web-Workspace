#!/usr/bin/env bash

set -u

echo "[+] Optional Tailscale installer for Linux"

if command -v tailscale >/dev/null 2>&1; then
  echo "[=] Tailscale already installed."
  exit 0
fi

curl -fsSL https://tailscale.com/install.sh | sh
echo "[+] Tailscale installed."
echo "[+] Next:"
echo "    sudo tailscale up"
