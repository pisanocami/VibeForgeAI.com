# MVP Plugin Manager
# Gestor de plugins dinámicos

class PluginManager {
    [hashtable]$LoadedPlugins = @{}

    PluginManager() {
        # Constructor
    }

    [void]ExecutePlugin([string]$pluginName) {
        $pluginPath = "$PSScriptRoot\..\plugins\$pluginName.ps1"

        if (Test-Path $pluginPath) {
            Write-Host "Ejecutando plugin: $pluginName"
            try {
                & $pluginPath
                Write-Host "Plugin $pluginName completado"
            } catch {
                Write-Error "Error en plugin $pluginName : $_"
                throw
            }
        } else {
            Write-Warning "[AVISO] Plugin '$pluginName' no encontrado en $pluginPath"
        }
    }

    [void]ExecutePluginWithParams([string]$pluginName, [hashtable]$params) {
        $pluginPath = "$PSScriptRoot\..\plugins\$pluginName.ps1"

        if (Test-Path $pluginPath) {
            Write-Host "Ejecutando plugin: $pluginName con parámetros"
            try {
                & $pluginPath @params
                Write-Host "Plugin $pluginName completado"
            } catch {
                Write-Error "Error en plugin $pluginName : $_"
                throw
            }
        } else {
            Write-Warning "[AVISO] Plugin '$pluginName' no encontrado en $pluginPath"
        }
    }

    [void]ListAvailablePlugins() {
        $pluginsDir = "$PSScriptRoot\..\plugins"
        if (Test-Path $pluginsDir) {
            $plugins = Get-ChildItem -Path $pluginsDir -Filter "*.ps1" -Recurse | Select-Object -ExpandProperty BaseName
            Write-Host "Plugins disponibles:"
            $plugins | ForEach-Object { Write-Host "  - $_" }
        } else {
            Write-Host "No hay plugins disponibles"
        }
    }

    [void]LoadPlugin([string]$pluginName) {
        $pluginPath = "$PSScriptRoot\..\plugins\$pluginName.ps1"
        if (Test-Path $pluginPath) {
            # Cargar script en memoria si es necesario
            $this.LoadedPlugins[$pluginName] = $pluginPath
            Write-Host "Plugin '$pluginName' cargado"
        } else {
            Write-Warning "[AVISO] Plugin '$pluginName' no encontrado"
        }
    }
}
