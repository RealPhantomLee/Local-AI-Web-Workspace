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

if (-not (Test-Path ".env")) {
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-Host "[+] Copied .env.example to .env — review it before long-term use."
    } else {
        Write-Host "[-] .env.example not found. Cannot create .env."
        exit 1
    }
} else {
    Write-Host "[*] .env already exists, skipping copy."
}

Write-Host "[+] Starting Docker stack..."
docker compose -f compose/docker-compose.yml up -d

Write-Host "[+] Stack status:"
docker compose -f compose/docker-compose.yml ps

Write-Host "[+] Ollama models:"
ollama list

Write-Host ""
Write-Host "[+] Windows install complete."
Write-Host "    AnythingLLM : http://localhost:3001"
Write-Host "    Homarr      : http://localhost:7575"
Write-Host "    Ollama API  : http://localhost:11434"
Write-Host ""
Write-Host "    Next: pull a model with 'ollama pull gemma3:latest'"
