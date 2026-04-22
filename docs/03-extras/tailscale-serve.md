# Tailscale Serve

Tailscale Serve is an optional remote access layer.

## Why add it
- reach local services remotely over your tailnet
- avoid opening ports to the public internet
- keep remote access separate from the local-first baseline

## Why it is optional
The core stack is designed to work locally first.

## Recommended sequence
1. Validate Ollama locally
2. Validate AnythingLLM locally
3. Validate dashboard locally
4. Then add Tailscale
5. Then add Serve mappings only for the services you truly need

## Important rule
Treat Tailscale Serve as an add-on, not part of initial deployment.
