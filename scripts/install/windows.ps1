$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..\..")
function Need($Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Write-Host "[-] Missing required command: $Name"
        exit 1
    }
}
Need git
Need docker
Need ollama
docker compose version | Out-Null
Write-Host "[+] Prerequisites verified."
Write-Host "[+] Starting Docker stack..."
docker compose up -d
Write-Host "[+] Current containers:"
docker ps
Write-Host "[+] Ollama models:"
ollama list
Write-Host "[+] Windows install routine complete."
