# install.ps1 - Funciones de instalación de dependencias
# Requiere: config.ps1

function Install-Dependencies {
    param(
        [string[]]$Packages,
        [string[]]$DevPackages,
        [string]$TargetDir = "."
    )

    Write-Log "Instalando dependencias en $TargetDir..." "INFO"

    # Cambiar al directorio objetivo
    $originalDir = Get-Location
    try {
        Set-Location $TargetDir

        # Instalar dependencias de producción
        if ($Packages -and $Packages.Count -gt 0) {
            Write-Log "Instalando dependencias de producción: $($Packages -join ', ')" "INFO"
            npm install @($Packages)
            if ($LASTEXITCODE -ne 0) {
                Write-Log "Error instalando dependencias de producción" "ERROR"
                exit 1
            }
        }

        # Instalar dependencias de desarrollo
        if ($DevPackages -and $DevPackages.Count -gt 0) {
            Write-Log "Instalando dependencias de desarrollo: $($DevPackages -join ', ')" "INFO"
            npm install -D @($DevPackages)
            if ($LASTEXITCODE -ne 0) {
                Write-Log "Error instalando dependencias de desarrollo" "ERROR"
                exit 1
            }
        }

        Write-Log "Dependencias instaladas exitosamente" "OK"
    } finally {
        Set-Location $originalDir
    }
}

function Install-FrontendTech {
    param([string]$Tech, [string]$TargetDir = ".")

    Write-Log "Instalando tecnología frontend: $Tech" "INFO"

    $config = Get-FrontendConfig -Tech $Tech
    if (-not $config) {
        Write-Log "Configuración no encontrada para tecnología: $Tech" "ERROR"
        exit 1
    }

    # Ejecutar comandos de inicialización
    if ($config.postInit) {
        foreach ($cmd in $config.postInit) {
            Write-Log "Ejecutando: $cmd" "INFO"
            Invoke-Expression $cmd
            if ($LASTEXITCODE -ne 0) {
                Write-Log "Error ejecutando comando: $cmd" "ERROR"
                exit 1
            }
        }
    }

    # Instalar dependencias específicas
    if ($config.packages -or $config.devPackages) {
        Install-Dependencies -Packages $config.packages -DevPackages $config.devPackages -TargetDir $TargetDir
    }

    Write-Log "Tecnología $Tech instalada exitosamente" "OK"
}

function Install-UILibs {
    param([string]$UILibs, [string]$TargetDir = ".")

    Write-Log "Instalando librerías UI: $UILibs" "INFO"

    $config = Get-UIConfig -UILibs $UILibs
    if (-not $config) {
        Write-Log "Configuración no encontrada para UI: $UILibs" "ERROR"
        exit 1
    }

    # Ejecutar comandos de inicialización
    if ($config.postInit) {
        foreach ($cmd in $config.postInit) {
            Write-Log "Ejecutando: $cmd" "INFO"
            Invoke-Expression $cmd
            if ($LASTEXITCODE -ne 0) {
                Write-Log "Error ejecutando comando: $cmd" "ERROR"
                exit 1
            }
        }
    }

    # Instalar dependencias específicas
    if ($config.packages) {
        Install-Dependencies -Packages $config.packages -TargetDir $TargetDir
    }

    Write-Log "Librerías UI $UILibs instaladas exitosamente" "OK"
}

function Install-BaseDependencies {
    param([string]$TargetDir = ".")

    Write-Log "Instalando dependencias base..." "INFO"

    $config = Get-MVPConfig
    if ($config -and $config.base) {
        Install-Dependencies -Packages $config.base.packages -DevPackages $config.base.devPackages -TargetDir $TargetDir
    } else {
        Write-Log "Configuración base no encontrada" "WARN"
    }
}
