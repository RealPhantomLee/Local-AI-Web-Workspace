$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)

$ComposeDir = Join-Path $RepoRoot "compose\core"
$ComposeFile = Join-Path $ComposeDir "compose.yaml"
$EnvFile = Join-Path $RepoRoot ".env"
$AnythingEnv = Join-Path $ComposeDir "env\anythingllm.env"
$DashboardEnv = Join-Path $ComposeDir "env\dashboard.env"

Write-Host "[+] Local-AI-Web-Workspace Windows bootstrap"
Write-Host "[+] Repo root: $RepoRoot"
Write-Host ""

if (-not (Test-Path $ComposeFile)) {
    Write-Host "[!] Missing compose file: $ComposeFile"
    Write-Host "[!] Run Step 4 first."
    exit 1
}

function New-LocalEnvFiles {
    Write-Host "[+] Writing local env files..."

    New-Item -ItemType Directory -Force -Path (Join-Path $ComposeDir "env") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $RepoRoot "docker-data\anythingllm\storage") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $RepoRoot "docker-data\homarr\appdata") | Out-Null

    if (-not (Test-Path $EnvFile)) {
        $Secret = -join ((48..57 + 97..102) | Get-Random -Count 64 | ForEach-Object {[char]$_})
@"
# Local runtime values for Windows
# Do not commit this file.

ANYTHINGLLM_PORT=3001
DASHBOARD_PORT=7575
OLLAMA_HOST=http://host.docker.internal:11434
APP_UID=1000
APP_GID=1000
HOMARR_SECRET_ENCRYPTION_KEY=$Secret
"@ | Set-Content -Path $EnvFile -Encoding UTF8
        Write-Host "[+] Created $EnvFile"
    } else {
        Write-Host "[=] Keeping existing $EnvFile"
    }

    if (-not (Test-Path $AnythingEnv)) {
@"
# Local AnythingLLM env overrides if needed.
# Keep real values private. Do not commit this file.
"@ | Set-Content -Path $AnythingEnv -Encoding UTF8
        Write-Host "[+] Created $AnythingEnv"
    } else {
        Write-Host "[=] Keeping existing $AnythingEnv"
    }

    if (-not (Test-Path $DashboardEnv)) {
@"
# Local dashboard env overrides if needed.
# Keep real values private. Do not commit this file.
"@ | Set-Content -Path $DashboardEnv -Encoding UTF8
        Write-Host "[+] Created $DashboardEnv"
    } else {
        Write-Host "[=] Keeping existing $DashboardEnv"
    }
}

function Test-CommandExists($Command) {
    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Install-DockerIfNeeded {
    if (Test-CommandExists "docker") {
        Write-Host "[=] Docker already installed."
    } else {
        Write-Host "[+] Docker not found. Running installer helper..."
        powershell -ExecutionPolicy Bypass -File (Join-Path $ScriptDir "install-docker.ps1")
    }

    try {
        docker compose version | Out-Null
        Write-Host "[=] Docker Compose available."
    } catch {
        Write-Host "[!] Docker Compose not detected."
        Write-Host "[!] Start Docker Desktop and verify installation, then re-run."
        exit 1
    }
}

function Install-OllamaIfNeeded {
    if (Test-CommandExists "ollama") {
        Write-Host "[=] Ollama already installed."
    } else {
        Write-Host "[+] Ollama not found. Running installer helper..."
        powershell -ExecutionPolicy Bypass -File (Join-Path $ScriptDir "install-ollama.ps1")
    }
}

function Invoke-PostChecks {
    powershell -ExecutionPolicy Bypass -File (Join-Path $ScriptDir "postinstall-checks.ps1")
}

function Start-Stack {
    Write-Host "[+] Starting core stack..."
    docker compose --env-file $EnvFile -f $ComposeFile up -d
}

function Show-Urls {
    Write-Host ""
    Write-Host "[+] Local URLs"
    Write-Host "    AnythingLLM : http://localhost:3001"
    Write-Host "    Dashboard   : http://localhost:7575"
    Write-Host "    Ollama API  : http://127.0.0.1:11434"
    Write-Host ""
}

New-LocalEnvFiles
Install-DockerIfNeeded
Install-OllamaIfNeeded
Invoke-PostChecks
Start-Stack
Show-Urls

Write-Host "[+] Windows bootstrap complete."
