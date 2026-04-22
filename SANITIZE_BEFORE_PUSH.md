# 🚨 SANITIZE BEFORE PUSH

Do NOT push until this checklist is complete.

## 🔐 Secrets Check
- [ ] No `.env` with real values
- [ ] No API keys or tokens
- [ ] No passwords
- [ ] No SSH private keys
- [ ] No recovery codes
- [ ] No Tailscale auth keys

## 🧠 Data Exposure Check
- [ ] No real hostnames
- [ ] No local IP addresses (unless intentionally sanitized)
- [ ] No tailnet names
- [ ] No personal usernames in configs
- [ ] No screenshots with sensitive info

## 📁 File Check
- [ ] `.env` is ignored
- [ ] Only `.env.example` is present
- [ ] No `docker-data/` contents included
- [ ] No logs or backups included
- [ ] No private notes included

## 📸 Screenshot Check
- [ ] URLs blurred or removed
- [ ] Tokens not visible
- [ ] Personal info removed

## 📄 Docs Check
- [ ] Docs describe process, not your real system
- [ ] Examples use placeholders
- [ ] No real deployment notes

## 🔍 Final Commands
Run these before pushing:

    git status
    git diff --cached

If anything looks sensitive → DO NOT PUSH.

## 🧱 Rule

Public repo = framework  
Private folder = real environment

If it exposes your system, it does not belong here.
