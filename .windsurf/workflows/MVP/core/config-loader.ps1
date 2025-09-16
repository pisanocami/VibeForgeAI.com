# MVP Config Loader
# Carga de configuración unificada desde múltiples fuentes

function Load-MVPConfig {
    # Prioridad: latest.json > mvp.config.json > variables de entorno

    $config = @{}

    # Cargar latest.json (generado por AutoParse)
    $latestPath = "$PSScriptRoot\..\..\latest.json"
    if (Test-Path $latestPath) {
        $config = Get-Content $latestPath -Encoding UTF8 | ConvertFrom-Json
        Write-Host "📄 Configuración cargada desde latest.json"
    }

    # Cargar mvp.config.json (configuración base)
    $configPath = "$PSScriptRoot\..\..\mvp.config.json"
    if (Test-Path $configPath) {
        $baseConfig = Get-Content $configPath -Encoding UTF8 | ConvertFrom-Json
        # Merge con latest.json (latest tiene prioridad)
        $config = Merge-Hashtables $baseConfig $config
        Write-Host "📄 Configuración base cargada desde mvp.config.json"
    }

    # Variables de entorno override
    if ($env:MVP_REQUEST) {
        $config.request = $env:MVP_REQUEST
    }
    if ($env:FRONTEND_TECH) {
        $config.frontend_tech = $env:FRONTEND_TECH
    }
    if ($env:BACKEND_TECH) {
        $config.backend_tech = $env:BACKEND_TECH
    }

    # Validación básica
    if (-not $config.plugins) {
        $config.plugins = @("docs", "frontend", "backend")  # defaults
    }

    Write-Host "⚙️ Configuración final: $($config | ConvertTo-Json -Depth 1)"
    return $config
}

function Merge-Hashtables {
    param([hashtable]$Base, [hashtable]$Override)

    $merged = $Base.Clone()

    foreach ($key in $Override.Keys) {
        if ($Override[$key] -is [hashtable] -and $merged.ContainsKey($key) -and $merged[$key] -is [hashtable]) {
            $merged[$key] = Merge-Hashtables $merged[$key] $Override[$key]
        } else {
            $merged[$key] = $Override[$key]
        }
    }

    return $merged
}
