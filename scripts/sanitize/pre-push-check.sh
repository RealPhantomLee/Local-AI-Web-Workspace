#!/usr/bin/env bash

echo "[+] Running pre-push sanitization check..."

echo
echo "[+] Checking staged files..."
git diff --cached --name-only

echo
echo "[+] Searching for common secret patterns..."
grep -RIn --exclude-dir=.git \
-E "(password=|TOKEN=|api_key|PRIVATE KEY|BEGIN RSA|BEGIN OPENSSH)" . || true

echo
echo "[+] Searching for suspicious secret variable names..."
grep -RIn --exclude-dir=.git \
-E "(SECRET=|SECRET_|_SECRET|AUTH_KEY=|API_KEY=)" . \
| grep -v "HOMARR_SECRET" \
| grep -v "SECRET_ENCRYPTION_KEY" \
| grep -v "scripts/sanitize/pre-push-check.sh" \
|| true

echo
echo "[+] Searching for .env files..."
find . -type f -name ".env" -not -name ".env.example"

echo
echo "[+] Checking for docker-data..."
find . -type d -name "docker-data"

echo
echo "[+] Checking for logs/backups..."
find . -type d \( -name "logs" -o -name "backups" \)

echo
echo "[!] Review output above carefully."
echo "[!] If anything looks sensitive, STOP and fix before pushing."
