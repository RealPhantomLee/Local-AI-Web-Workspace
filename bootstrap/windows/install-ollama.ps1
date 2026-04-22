$ErrorActionPreference = "Stop"

Write-Host "[+] Windows Ollama helper"

if (Get-Command ollama -ErrorAction SilentlyContinue) {
    Write-Host "[=] Ollama already available."
    exit 0
}

Write-Host "[!] Install Ollama manually on Windows, then re-run bootstrap.ps1."
exit 1
