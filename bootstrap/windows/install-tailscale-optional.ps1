$ErrorActionPreference = "Stop"

Write-Host "[+] Optional Tailscale installer for Windows"

if (Get-Command tailscale -ErrorAction SilentlyContinue) {
    Write-Host "[=] Tailscale already installed."
    exit 0
}

Write-Host "[!] Install Tailscale manually on Windows if needed."
exit 1
