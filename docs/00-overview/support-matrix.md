# Support Matrix

This document defines what is actually supported and validated.

---

## Core Stack

| Component     | Linux | macOS | Windows |
|--------------|------|-------|--------|
| Ollama       | ✅ Full | ✅ Full | ✅ Full |
| AnythingLLM  | ✅ Full | ✅ Full | ✅ Full |
| Dashboard    | ✅ Full | ✅ Full | ✅ Full |

---

## Extras

| Component     | Linux | macOS | Windows | Notes |
|--------------|------|-------|--------|------|
| code-server  | ✅ | ⚠️ | ⚠️ | Works best on Linux |
| WeTTY        | ✅ | ⚠️ | ⚠️ | Requires careful exposure control |
| Filebrowser  | ✅ | ⚠️ | ⚠️ | Works but less tested |
| Cockpit      | ✅ | ❌ | ❌ | Linux-only system tool |
| Tailscale    | ✅ | ✅ | ✅ | Supported on all platforms |
| Tailscale Serve | ✅ | ⚠️ | ⚠️ | Validate carefully outside Linux |

---

## Validation Levels

- ✅ **Full** → tested and documented
- ⚠️ **Partial** → expected to work, limited validation
- ❌ **Not supported** → do not use in this project

---

## Design Principles

- Linux is the primary platform
- Cross-platform support is limited to the core stack
- Extras are optional and not required for base functionality
- Remote access is never required for core usage

---

## What we do NOT claim

- Full parity across all operating systems
- All extras working everywhere
- GPU acceleration across all environments
- Production-ready remote exposure

---

## Recommendation

If you want the most stable experience:

→ Use Linux as your primary environment

---

## Future Expansion

Support may expand based on:
- real testing
- documented workflows
- reproducible setups

No feature is marked “supported” without validation.
