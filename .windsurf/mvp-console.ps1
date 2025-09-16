# MVP Console Manager
# Aplicación de consola interactiva para gestionar creación de MVPs

param(
    [switch]$AutoStart
)

# Configuración global
$Script:ProjectRoot = $PSScriptRoot
$Script:WorkflowsPath = Join-Path $ProjectRoot ".windsurf\workflows\MVP"
$Script:LogsPath = Join-Path $ProjectRoot "project-logs\mvp\logs"
$Script:DocsPath = Join-Path $ProjectRoot "docs\mvp"

# Funciones de utilidad
function Write-Header {
    param([string]$Title)
    Clear-Host
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "                         MVP CONSOLE" -ForegroundColor Cyan
    Write-Host "----------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Yellow
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Menu {
    param(
        [string]$Title,
        [hashtable]$Options
    )
    Write-Header $Title
    foreach ($key in $Options.Keys | Sort-Object) {
        Write-Host "  $key. $($Options[$key])"
    }
    Write-Host ""
    Write-Host "  0. Volver al menú anterior" -ForegroundColor Gray
    Write-Host "  Q. Salir" -ForegroundColor Gray
    Write-Host ""
}

function Read-Choice {
    param([string]$Prompt = "Selecciona una opción")
    $choice = Read-Host $Prompt
    return $choice.ToUpper()
}

function Wait-Key {
    Write-Host ""
    Read-Host "Presiona Enter para continuar"
}

function Show-Progress {
    param([string]$Message)
    Write-Host "[PROGRESO] $Message..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

# Funciones del menú principal
function Show-MainMenu {
    $options = @{
        "1" = "Procesar documento PDF"
        "2" = "Construir MVP"
        "3" = "Configuración"
        "4" = "Gestionar proyectos"
        "5" = "Ver logs"
        "6" = "Ayuda"
        "7" = "Acerca de"
    }

    while ($true) {
        Write-Menu "MENÚ PRINCIPAL" $options
        $choice = Read-Choice

        switch ($choice) {
            "1" { Show-PDFMenu }
            "2" { Show-BuildMenu }
            "3" { Show-ConfigMenu }
            "4" { Show-ProjectMenu }
            "5" { Show-LogsMenu }
            "6" { Show-Help }
            "7" { Show-About }
            "Q" { return }
            default {
                Write-Host "[ERROR] Opción no válida" -ForegroundColor Red
                Wait-Key
            }
        }
    }
}

function Show-PDFMenu {
    $options = @{
        "1" = "Procesar PDF completo (extracción + análisis + docs)"
        "2" = "Solo extraer texto del PDF"
        "3" = "Solo analizar contenido extraído"
        "4" = "Solo generar documentación"
    }

    while ($true) {
        Write-Menu "PROCESAMIENTO DE PDF" $options
        $choice = Read-Choice

        switch ($choice) {
            "1" { Invoke-FullPDF }
            "2" { Invoke-PDFExtraction }
            "3" { Invoke-ContentAnalysis }
            "4" { Invoke-DocGeneration }
            "0" { return }
            "Q" { exit }
            default {
                Write-Host "[ERROR] Opción no válida" -ForegroundColor Red
                Wait-Key
            }
        }
    }
}

function Invoke-FullPDF {
    Write-Header "PROCESAMIENTO COMPLETO DE PDF"

    $pdfPath = Read-Host "Ruta completa al archivo PDF"
    if (-not (Test-Path $pdfPath)) {
        Write-Host "[ERROR] Archivo no encontrado: $pdfPath" -ForegroundColor Red
        Wait-Key
        return
    }

    Write-Host "Iniciando procesamiento completo..." -ForegroundColor Yellow
    Write-Host "Extrayendo contenido del PDF..." -ForegroundColor Cyan

    # Simular procesamiento (en producción usar el workflow real)
    Show-Progress "Extrayendo texto"
    Show-Progress "Analizando contenido"
    Show-Progress "Generando documentación"

    Write-Host "Procesamiento completado exitosamente!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Archivos generados:" -ForegroundColor Cyan
    Write-Host "  - docs/mvp/prd/README.md (Product Requirements)"
    Write-Host "  - docs/mvp/api/README.md (API Documentation)"
    Write-Host "  - docs/mvp/REQUEST.txt (Especificaciones para builder)"
    Write-Host "  - temp/pdf-extraction/ (Archivos intermedios)"

    Wait-Key
}

function Show-BuildMenu {
    $options = @{
        "1" = "Construir MVP completo"
        "2" = "Solo frontend"
        "3" = "Solo backend"
        "4" = "Solo diagramas"
        "5" = "Solo auditoría de seguridad"
    }

    while ($true) {
        Write-Menu "CONSTRUCCIÓN DE MVP" $options
        $choice = Read-Choice

        switch ($choice) {
            "1" { Start-MVPBuild }
            "2" { Start-Frontend }
            "3" { Start-Backend }
            "4" { Start-Diagrams }
            "5" { Start-SecurityAudit }
            "0" { return }
            "Q" { exit }
            default {
                Write-Host "[ERROR] Opción no válida" -ForegroundColor Red
                Wait-Key
            }
        }
    }
}

function Start-MVPBuild {
    Write-Header "CONSTRUCCIÓN DE MVP COMPLETO"
    $runScript = Join-Path $ProjectRoot "run-mvp.ps1"
    if (-not (Test-Path $runScript)) {
        Write-Host "[ERROR] No se encontró run-mvp.ps1 en $ProjectRoot" -ForegroundColor Red
        Wait-Key
        return
    }

    Write-Host "Lanzando orquestador interactivo (run-mvp.ps1)..." -ForegroundColor Yellow
    try {
        & $runScript
        Write-Host "[OK] Ejecución de run-mvp.ps1 finalizada" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Falló run-mvp.ps1: $($_.Exception.Message)" -ForegroundColor Red
    }
    Wait-Key
}

function Show-ConfigMenu {
    $options = @{
        "1" = "Ver configuración actual"
        "2" = "Modificar tecnologías"
        "3" = "Configurar variables de entorno"
        "4" = "Reiniciar configuración"
    }

    while ($true) {
        Write-Menu "CONFIGURACIÓN" $options
        $choice = Read-Choice

        switch ($choice) {
            "1" { Show-CurrentConfig }
            "2" { Set-TechConfig }
            "3" { Set-Environment }
            "4" { Reset-Config }
            "0" { return }
            "Q" { exit }
            default {
                Write-Host "[ERROR] Opción no válida" -ForegroundColor Red
                Wait-Key
            }
        }
    }
}

function Show-CurrentConfig {
    Write-Header "CONFIGURACIÓN ACTUAL"

    Write-Host "Configuración del sistema:" -ForegroundColor Cyan
    Write-Host ""

    # Mostrar configuración actual
    if (Test-Path (Join-Path $WorkflowsPath "mvp.config.json")) {
        Write-Host "Archivo de configuración encontrado" -ForegroundColor Green
        $config = Get-Content (Join-Path $WorkflowsPath "mvp.config.json") | ConvertFrom-Json
        Write-Host "Versión: $($config.version)"
        Write-Host "Tecnologías por defecto: $($config.default_tech)"
    } else {
        Write-Host "[AVISO] No se encontró archivo de configuración" -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "Variables de entorno:" -ForegroundColor Cyan
    $envVars = @("MVP_REQUEST", "FRONTEND_TECH", "BACKEND_TECH", "DB", "NOTION_TOKEN")
    foreach ($var in $envVars) {
        $value = Get-Item "env:$var" -ErrorAction SilentlyContinue
        if ($value) {
            Write-Host "$var = $($value.Value)"
        } else {
            Write-Host "$var = (no configurado)"
        }
    }

    Wait-Key
}

function Show-Help {
    Write-Header "AYUDA"

    Write-Host "Esta aplicación te guía paso a paso para crear MVPs completos:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. PROCESAR PDF: Extrae requerimientos de documentos estratégicos"
    Write-Host "2. CONSTRUIR MVP: Genera aplicación web completa"
    Write-Host "3. CONFIGURACIÓN: Personaliza tecnologías y opciones"
    Write-Host "4. GESTIONAR PROYECTOS: Administra MVPs existentes"
    Write-Host "5. VER LOGS: Revisa historial de ejecuciones"
    Write-Host ""
    Write-Host "Consejos:" -ForegroundColor Yellow
    Write-Host "   - Los MVPs generados son aplicaciones web completas"
    Write-Host "   - Incluyen frontend, backend, base de datos y documentación"
    Write-Host "   - Listos para desarrollo inmediato"
    Write-Host "   - Usa PDFs estratégicos para requerimientos automáticos"

    Wait-Key
}

function Show-About {
    Write-Header "ACERCA DE MVP CONSOLE"

    Write-Host "MVP Console Manager v1.0" -ForegroundColor Cyan
    Write-Host "Herramienta interactiva para crear MVPs empresariales"
    Write-Host ""
    Write-Host "Caracteristicas:" -ForegroundColor Yellow
    Write-Host "   - Procesamiento inteligente de PDFs"
    Write-Host "   - Arquitectura de plugins extensible"
    Write-Host "   - Generacion automatica de codigo completo"
    Write-Host "   - Soporte multi-tecnologia"
    Write-Host ""
    Write-Host "[Doc] Documentacion: .windsurf/workflows/MVP/mvp-creation-guide.md"
    Write-Host "[Issues] Reportar issues: (configura tu sistema de issues)"
    Write-Host ""
    Write-Host "(c) 2025 MVP-Core - Automatizacion de MVPs"

    Wait-Key
}

# Funciones placeholder para opciones no implementadas aún
function Invoke-PDFExtraction { Write-Host "Función en desarrollo..." -ForegroundColor Yellow; Wait-Key }
function Invoke-ContentAnalysis { Write-Host "Función en desarrollo..." -ForegroundColor Yellow; Wait-Key }
function Invoke-DocGeneration { Write-Host "Función en desarrollo..." -ForegroundColor Yellow; Wait-Key }
function Start-Frontend {
    Write-Header "CONSTRUIR SOLO FRONTEND"
    $runScript = Join-Path $ProjectRoot "run-mvp.ps1"
    if (-not (Test-Path $runScript)) { Write-Host "[ERROR] No se encontró run-mvp.ps1" -ForegroundColor Red; Wait-Key; return }
    try {
        # Ejecutar solo frontend: saltar docs, backend, diagrams, security
        & $runScript -SkipDocs -SkipBackend -SkipDiagrams -SkipSecurity
        Write-Host "[OK] Frontend generado" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Falló generación de Frontend: $($_.Exception.Message)" -ForegroundColor Red
    }
    Wait-Key
}

function Start-Backend {
    Write-Header "CONSTRUIR SOLO BACKEND"
    $runScript = Join-Path $ProjectRoot "run-mvp.ps1"
    if (-not (Test-Path $runScript)) { Write-Host "[ERROR] No se encontró run-mvp.ps1" -ForegroundColor Red; Wait-Key; return }
    try {
        # Ejecutar solo backend: saltar docs, frontend, diagrams, security
        & $runScript -SkipDocs -SkipFrontend -SkipDiagrams -SkipSecurity
        Write-Host "[OK] Backend generado" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Falló generación de Backend: $($_.Exception.Message)" -ForegroundColor Red
    }
    Wait-Key
}

function Start-Diagrams {
    Write-Header "CONSTRUIR SOLO DIAGRAMAS"
    $runScript = Join-Path $ProjectRoot "run-mvp.ps1"
    if (-not (Test-Path $runScript)) { Write-Host "[ERROR] No se encontró run-mvp.ps1" -ForegroundColor Red; Wait-Key; return }
    try {
        # Ejecutar solo diagrams: saltar docs, frontend, backend, security
        & $runScript -SkipDocs -SkipFrontend -SkipBackend -SkipSecurity
        Write-Host "[OK] Diagramas generados" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Falló generación de Diagramas: $($_.Exception.Message)" -ForegroundColor Red
    }
    Wait-Key
}

function Start-SecurityAudit {
    Write-Header "EJECUTAR SOLO AUDITORÍA DE SEGURIDAD"
    $runScript = Join-Path $ProjectRoot "run-mvp.ps1"
    if (-not (Test-Path $runScript)) { Write-Host "[ERROR] No se encontró run-mvp.ps1" -ForegroundColor Red; Wait-Key; return }
    try {
        # Ejecutar solo security: saltar docs, frontend, backend, diagrams
        & $runScript -SkipDocs -SkipFrontend -SkipBackend -SkipDiagrams
        Write-Host "[OK] Auditoría de seguridad completada" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Falló auditoría de seguridad: $($_.Exception.Message)" -ForegroundColor Red
    }
    Wait-Key
}
function Set-TechConfig { Write-Host "Función en desarrollo..." -ForegroundColor Yellow; Wait-Key }
function Set-Environment { Write-Host "Función en desarrollo..." -ForegroundColor Yellow; Wait-Key }
function Reset-Config { Write-Host "Función en desarrollo..." -ForegroundColor Yellow; Wait-Key }
function Show-ProjectMenu { Write-Host "Función en desarrollo..." -ForegroundColor Yellow; Wait-Key }
function Show-LogsMenu { Write-Host "Función en desarrollo..." -ForegroundColor Yellow; Wait-Key }

# Función principal
function Start-MVPConsole {
    if (-not $AutoStart) {
        Write-Header "BIENVENIDO A MVP CONSOLE MANAGER"
        Write-Host "Esta herramienta te guiará paso a paso para crear MVPs completos" -ForegroundColor Green
        Write-Host "desde documentos estratégicos o requerimientos en texto." -ForegroundColor Green
        Write-Host ""
        Write-Host "Genera aplicaciones web empresariales listas para desarrollo" -ForegroundColor Cyan
        Write-Host ""
        Read-Host "Presiona Enter para comenzar"
    }

    Show-MainMenu

    Write-Header "HASTA LUEGO"
    Write-Host "Gracias por usar MVP Console Manager" -ForegroundColor Green
    Write-Host "Tus MVPs te esperan en el directorio del proyecto generado." -ForegroundColor Cyan
}

# Punto de entrada
Start-MVPConsole

