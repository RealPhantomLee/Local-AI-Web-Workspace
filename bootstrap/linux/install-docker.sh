#!/usr/bin/env bash

set -u

echo "[+] Installing Docker for Linux..."

if command -v pacman >/dev/null 2>&1; then
  echo "[+] Arch-based system detected."
  sudo pacman -Sy --noconfirm docker docker-compose
elif command -v apt-get >/dev/null 2>&1; then
  echo "[+] Debian/Ubuntu-style system detected."
  sudo apt-get update
  sudo apt-get install -y docker.io docker-compose-plugin
elif command -v dnf >/dev/null 2>&1; then
  echo "[+] Fedora/RHEL-style system detected."
  sudo dnf install -y docker docker-compose-plugin
else
  echo "[!] Unsupported package manager for this starter installer."
  echo "[!] Install Docker manually, then re-run bootstrap."
  exit 1
fi

sudo systemctl enable --now docker
echo "[+] Docker installation step complete."
