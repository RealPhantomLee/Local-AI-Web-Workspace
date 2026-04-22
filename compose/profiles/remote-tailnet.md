# Remote Tailnet Profile

This profile adds remote access through Tailscale after the local stack is validated.

## Suggested path
1. Build local-only first
2. Confirm local URLs
3. Install and join Tailscale
4. Add only the specific Serve mappings you need
5. Keep sensitive services restricted

## Good candidates for remote access
- dashboard
- AnythingLLM
- code-server
- Filebrowser

## Higher-risk candidate
- WeTTY

## Rule
Remote access is an add-on, not a requirement.
