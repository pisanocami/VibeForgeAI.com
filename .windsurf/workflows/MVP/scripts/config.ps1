# config.ps1 - Funciones de configuración para mvp-frontend
# Carga configuraciones y funciones auxiliares

function Get-MVPConfig {
    param([string]$ConfigPath = "mvp.config.json")

    if (Test-Path $ConfigPath) {
        try {
            $config = Get-Content $ConfigPath | ConvertFrom-Json
            return $config
        } catch {
            Write-Host ("[ERROR] No se pudo leer {0}: {1}" -f $ConfigPath, $($_.Exception.Message)) -ForegroundColor Red
            return $null
        }
    } else {
        Write-Host "[ERROR] Archivo de configuración no encontrado: $ConfigPath" -ForegroundColor Red
        return $null
    }
}

function Get-FrontendConfig {
    param([string]$Tech, [string]$ConfigPath = "mvp.config.json")

    $config = Get-MVPConfig -ConfigPath $ConfigPath
    if ($config -and $config.frontend) {
        return $config.frontend.$Tech
    }
    return $null
}

function Get-UIConfig {
    param([string]$UILibs, [string]$ConfigPath = "mvp.config.json")

    $config = Get-MVPConfig -ConfigPath $ConfigPath
    if ($config -and $config.ui) {
        return $config.ui.$UILibs
    }
    return $null
}

function Test-Prerequisites {
    # Verificar Node.js
    try {
        $nodeVersion = node --version
        Write-Host "[OK] Node.js encontrado: $nodeVersion" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Node.js no está instalado o no está en PATH" -ForegroundColor Red
        exit 1
    }

    # Verificar npm
    try {
        $npmVersion = npm --version
        Write-Host "[OK] npm encontrado: $npmVersion" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] npm no está instalado o no está en PATH" -ForegroundColor Red
        exit 1
    }
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    switch ($Level) {
        "ERROR" { Write-Host $logMessage -ForegroundColor Red }
        "WARN"  { Write-Host $logMessage -ForegroundColor Yellow }
        "OK"    { Write-Host $logMessage -ForegroundColor Green }
        default { Write-Host $logMessage }
    }
}
