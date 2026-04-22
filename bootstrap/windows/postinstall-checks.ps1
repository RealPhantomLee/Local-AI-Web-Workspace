$ErrorActionPreference = "Continue"

Write-Host "[+] Running Windows post-install checks..."

if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "[OK] docker found"
} else {
    Write-Host "[!!] docker not found"
}

try {
    $composeVersion = docker compose version
    Write-Host "[OK] docker compose found: $composeVersion"
} catch {
    Write-Host "[!!] docker compose not found"
}

if (Get-Command ollama -ErrorAction SilentlyContinue) {
    Write-Host "[OK] ollama found"
} else {
    Write-Host "[!!] ollama not found"
}

try {
    Invoke-WebRequest -UseBasicParsing -Uri "http://127.0.0.1:11434" -TimeoutSec 3 | Out-Null
    Write-Host "[OK] Ollama API reachable on 127.0.0.1:11434"
} catch {
    Write-Host "[!!] Ollama API not reachable yet on 127.0.0.1:11434"
}
