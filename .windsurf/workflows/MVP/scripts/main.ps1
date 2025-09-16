# main.ps1 - Orquestador principal del workflow mvp-frontend
# Requiere: config.ps1, install.ps1, scaffold.ps1

param(
  [string]$Tech = 'react-vite',
  [string]$UILibs = 'tailwind+shadcn',
  [string]$TargetDir = 'apps/front',
  [string]$ConfigPath = 'mvp.config.json',
  [switch]$SkipInstall,
  [switch]$SkipScaffold,
  [switch]$Force
)

# Importar módulos
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir "config.ps1")
. (Join-Path $scriptDir "install.ps1")
. (Join-Path $scriptDir "scaffold.ps1")

# Función principal
function Main {
  Write-Log "🚀 Iniciando MVP Frontend Setup" "INFO"
  Write-Log "Tecnología: $Tech | UI: $UILibs | Destino: $TargetDir" "INFO"

  try {
    # Verificar prerrequisitos
    Test-Prerequisites

    # Verificar configuración
    $config = Get-MVPConfig -ConfigPath $ConfigPath
    if (-not $config) {
      Write-Log "Configuración no válida" "ERROR"
      exit 1
    }

    # Crear directorio destino si no existe
    if (-not (Test-Path $TargetDir)) {
      New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
      Write-Log "Directorio creado: $TargetDir" "OK"
    }

    # Instalar dependencias base
    if (-not $SkipInstall) {
      Write-Log "📦 Instalando dependencias..." "INFO"
      Install-BaseDependencies -TargetDir $TargetDir
      Install-FrontendTech -Tech $Tech -TargetDir $TargetDir
      Install-UILibs -UILibs $UILibs -TargetDir $TargetDir
    }

    # Crear estructura y archivos
    if (-not $SkipScaffold) {
      Write-Log "🏗️ Creando estructura del proyecto..." "INFO"
      Scaffold-Frontend -Tech $Tech -UILibs $UILibs -TargetDir $TargetDir
    }

    Write-Log "✅ MVP Frontend configurado exitosamente!" "OK"
    Write-Log "📁 Ubicación: $TargetDir" "INFO"
    Write-Log "🚀 Ejecuta: cd $TargetDir && npm run dev" "INFO"

  } catch {
    Write-Log "❌ Error durante la configuración: $($_.Exception.Message)" "ERROR"
    exit 1
  }
}

# Ejecutar función principal
Main
