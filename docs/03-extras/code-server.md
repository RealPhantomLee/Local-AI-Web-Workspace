# code-server

`code-server` is an optional browser-based IDE.

## Why add it
- edit configs from a browser
- work inside the workspace remotely
- keep a lightweight web IDE next to AnythingLLM

## Why it is optional
The core stack works without it.

## Default behavior
- binds to a local port
- uses password auth
- mounts the workspace directory

## Recommended use
- local-only first
- add Tailscale Serve only after local validation
- do not expose casually to the public internet

## Notes
Change the password locally before real use.
