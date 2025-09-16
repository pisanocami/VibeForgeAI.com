# MVP Builder Orchestrator
# Motor principal para ejecutar workflows MVP con arquitectura de plugins

# Importar módulos
. $PSScriptRoot/config-loader.ps1
. $PSScriptRoot/plugin-manager.ps1

function Start-MVPBuilder {
    param(
        [string]$Request,
        [hashtable]$Config = $null
    )

    Write-Host "🚀 Iniciando MVP Builder Orchestrator"

    # Cargar configuración
    if (-not $Config) {
        $Config = Load-MVPConfig
    }

    # Inicializar plugin manager
    $PluginManager = [PluginManager]::new()

    # Ejecutar plugins según configuración (pasando Config como Context)
    foreach ($plugin in $Config.plugins) {
        $PluginManager.ExecutePluginWithParams($plugin, @{ Context = $Config })
    }

    Write-Host "✅ MVP Builder completado"
}

# Punto de entrada si se ejecuta directamente
if ($MyInvocation.InvocationName -eq $null) {
    Start-MVPBuilder
}
