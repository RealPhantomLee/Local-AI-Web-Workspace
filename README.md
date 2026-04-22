# Local-AI-Web-Workspace

A local-first AI workspace for a single machine using Ollama, AnythingLLM, and a lightweight dashboard.

---

## What this project is

- A **general local AI workspace**
- Designed for **one machine (no cluster required)**
- Built with a **local-first philosophy**
- Uses **Docker Compose for service orchestration**
- Supports **optional remote access via Tailscale**

---

## What this project is not

- Not a cyberdeck-only build
- Not a Raspberry Pi requirement
- Not a cloud-dependent system
- Not a public internet exposure template
- Not a repository of real credentials or operator data

---

## Core Stack

- **Ollama (host)** → local LLM runtime
- **AnythingLLM (Docker)** → AI interface + workflows
- **Dashboard (Docker)** → service access layer

---

## Optional Extras

- code-server (browser IDE)
- WeTTY (browser terminal)
- Filebrowser (file UI)
- Cockpit (Linux system panel)
- Tailscale Serve (remote access)

---

## Support Statement

- **Linux** → fully validated (recommended)
- **macOS** → core stack supported
- **Windows** → core stack supported
- **Extras** → vary by platform

See: `docs/00-overview/support-matrix.md`

---

## Security Model

- Local-first by default
- Remote access is optional (Tailscale Serve)
- No real secrets are stored in this repository
- Public/private separation is required

---

## Quick Start

See:
- `docs/01-quickstart/linux-quickstart.md`
- `docs/01-quickstart/macos-quickstart.md`
- `docs/01-quickstart/windows-quickstart.md`

---

## Repository Structure

- `compose/` → Docker Compose configs
- `bootstrap/` → OS setup scripts
- `docs/` → documentation
- `templates/` → safe config templates
- `assets/` → diagrams and screenshots

---

## Public / Private Split

This project requires a private companion folder.

See:
- `docs/05-sanitization/public-private-split.md`

---

## Lessons Incorporated

- Brick #7 AI Intelligence Layer
- AnythingLLM + Ollama integration patterns
- Tailscale Serve troubleshooting
- GitHub sanitization workflows
- Public/private documentation separation

---

## License

TBD
