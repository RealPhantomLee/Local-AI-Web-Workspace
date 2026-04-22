$ErrorActionPreference = "Stop"

Write-Host "[+] Windows Docker helper"

if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "[=] Docker already available."
    exit 0
}

Write-Host "[!] Install Docker Desktop manually or through your preferred package workflow."
Write-Host "[!] Then start Docker Desktop and re-run bootstrap.ps1."
exit 1
