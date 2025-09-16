# run-mvp.ps1 - Script Wrapper para Ejecutar Workflows MVP desde Raíz
# Ejecuta automáticamente el sistema MVP con configuración por defecto

param(
    [string]$Request = "Crear MVP completo desde PDF ejecutivo",
    [string]$PdfPath = "EXECUTIVE_README_STRATEGIC_EN_PRO.pdf",
    [switch]$SkipDocs,
    [switch]$SkipFrontend,
    [switch]$SkipBackend,
    [switch]$SkipDiagrams,
    [switch]$SkipSecurity
)

# --- Helpers de interacción ---
function Read-Select {
    param(
        [Parameter(Mandatory=$true)][string]$Label,
        [Parameter(Mandatory=$true)][string[]]$Options,
        [string]$Default = ""
    )
    Write-Host ""; Write-Host $Label -ForegroundColor Yellow
    for ($i = 0; $i -lt $Options.Count; $i++) { Write-Host ("  [{0}] {1}" -f ($i+1), $Options[$i]) }
    $prompt = ("Selecciona 1-{0}{1}: " -f $Options.Count, ($(if($Default){" (por defecto: $Default)"} else {""})))
    $sel = Read-Host $prompt
    if ([string]::IsNullOrWhiteSpace($sel)) { return $Default }
    if ($sel -as [int]) {
        $idx = [int]$sel - 1
        if ($idx -ge 0 -and $idx -lt $Options.Count) { return $Options[$idx] }
    }
    # Si usuario escribió texto, validar opción
    if ($Options -contains $sel) { return $sel }
    Write-Host "Selección inválida, usando valor por defecto: $Default" -ForegroundColor DarkYellow
    return $Default
}

function Read-MultiSelect {
    param(
        [Parameter(Mandatory=$true)][string]$Label,
        [Parameter(Mandatory=$true)][string[]]$Options,
        [string[]]$Default = @()
    )
    Write-Host ""; Write-Host $Label -ForegroundColor Yellow
    for ($i = 0; $i -lt $Options.Count; $i++) { Write-Host ("  [{0}] {1}" -f ($i+1), $Options[$i]) }
    $defText = if ($Default.Count -gt 0) { " (por defecto: " + ($Default -join ",") + ")" } else { "" }
    $sel = Read-Host ("Ingresa números separados por coma o nombres exactos{0}: " -f $defText)
    if ([string]::IsNullOrWhiteSpace($sel)) { return $Default }
    $parts = $sel -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    $result = @()
    foreach ($p in $parts) {
        if ($p -as [int]) {
            $idx = [int]$p - 1
            if ($idx -ge 0 -and $idx -lt $Options.Count) { $result += $Options[$idx] }
        } elseif ($Options -contains $p) {
            $result += $p
        }
    }
    if ($result.Count -eq 0 -and $Default.Count -gt 0) { return $Default }
    return ($result | Select-Object -Unique)
}

# Configuración inicial
$RootDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$WorkflowsDir = Join-Path $RootDir ".windsurf\workflows\MVP\core"

Write-Host "[START] Iniciando MVP Core desde $RootDir" -ForegroundColor Green
Write-Host "Solicitud: $Request" -ForegroundColor Cyan
Write-Host "PDF: $PdfPath" -ForegroundColor Cyan

try {
    # Verificar prerrequisitos
    if (!(Test-Path $WorkflowsDir)) {
        throw "Directorio de workflows no encontrado: $WorkflowsDir"
    }

    # Cambiar al directorio de workflows
    Push-Location $WorkflowsDir

    # Importar módulos del sistema
    . .\config-loader.ps1
    . .\plugin-manager.ps1
    . .\orchestrator.ps1

    # --- Entrada interactiva ---
    if (-not $PSBoundParameters.ContainsKey('Request') -or [string]::IsNullOrWhiteSpace($Request)) {
        $Request = Read-Host "Describe tu MVP (ej: 'React dashboard con FastAPI')"
        if ([string]::IsNullOrWhiteSpace($Request)) { $Request = "React dashboard con FastAPI" }
    }

    if (-not $PSBoundParameters.ContainsKey('PdfPath')) {
        $pdfInput = Read-Host "Ruta a PDF estratégico (opcional, Enter para omitir)"
        if (-not [string]::IsNullOrWhiteSpace($pdfInput)) { $PdfPath = $pdfInput } else { $PdfPath = "" }
    }

    # Selección de módulos
    $allModules = @("docs","frontend","backend","diagrams","security")
    $defaultModules = if ($PSBoundParameters.Keys | Where-Object { $_ -like 'Skip*' }) {
        # Si se pasaron switches Skip, respetar los que no estén en Skip*
        $tmp = @()
        if (!$SkipDocs) { $tmp += "docs" }
        if (!$SkipFrontend) { $tmp += "frontend" }
        if (!$SkipBackend) { $tmp += "backend" }
        if (!$SkipDiagrams) { $tmp += "diagrams" }
        if (!$SkipSecurity) { $tmp += "security" }
        $tmp
    } else { $allModules }
    $modules = Read-MultiSelect -Label "Selecciona módulos a ejecutar" -Options $allModules -Default $defaultModules
    if ($modules.Count -eq 0) { $modules = $allModules }

    # Selección de tecnologías
    $frontendChoice = Read-Select -Label "Selecciona tecnología de Frontend" -Options @('react-vite','nextjs','sveltekit','angular') -Default 'react-vite'
    $backendChoice  = Read-Select -Label "Selecciona tecnología de Backend" -Options @('fastify','express','nest','hono','fastapi') -Default 'fastify'
    $uiChoice       = Read-Select -Label "Selecciona librerías de UI" -Options @('tailwind+shadcn','tailwind','none') -Default 'tailwind+shadcn'
    $dbChoice       = Read-Select -Label "Selecciona base de datos" -Options @('neon-postgres','sqlite','mongodb') -Default 'neon-postgres'

    # --- Crear carpeta de proyecto projects/<slug> ---
    function New-SlugFromText([string]$text) {
        if ([string]::IsNullOrWhiteSpace($text)) { return (Get-Date -Format "yyyyMMdd-HHmmss") }
        $s = $text.ToLower()
        $s = ($s -replace "[^a-z0-9]+","-").Trim('-')
        if ([string]::IsNullOrWhiteSpace($s)) { $s = (Get-Date -Format "yyyyMMdd-HHmmss") }
        return $s
    }
    $slug = New-SlugFromText $Request
    $projectsRoot = Join-Path $RootDir "projects"
    if (!(Test-Path $projectsRoot)) { New-Item -ItemType Directory -Path $projectsRoot | Out-Null }
    $projectDir = Join-Path $projectsRoot $slug
    if (!(Test-Path $projectDir)) { New-Item -ItemType Directory -Path $projectDir | Out-Null }
    Write-Host ("[OUTPUT] Directorio del proyecto: {0}" -f $projectDir) -ForegroundColor Cyan

    # Preparar configuración
    $config = @{
        plugins = $modules
        request = $Request
        pdf_path = $PdfPath
        frontend_tech = $frontendChoice
        backend_tech = $backendChoice
        ui_libs = $uiChoice
        db = $dbChoice
        output_dir = $projectDir
    }

    # Ejecutar orquestador
    Write-Host "[CONFIG] Ejecutando orquestador con configuración:" -ForegroundColor Yellow
    $config | ConvertTo-Json -Depth 2 | Write-Host

    Start-MVPBuilder -Config $config

    Write-Host "[OK] MVP ejecutado exitosamente" -ForegroundColor Green
    Write-Host "[FOLDER] Revisa la carpeta generada para el proyecto" -ForegroundColor Cyan

} catch {
    Write-Host "[ERROR] Error ejecutando MVP: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Solución: Verifica que todos los archivos estén en su lugar" -ForegroundColor Yellow
} finally {
    Pop-Location
}

# Instrucciones finales
Write-Host ""
Write-Host "[NEXT] Próximos pasos:" -ForegroundColor Magenta
Write-Host "  1. Navega al directorio del proyecto creado" -ForegroundColor White
Write-Host "  2. Ejecuta 'npm install' en client/ y server/" -ForegroundColor White
Write-Host "  3. Ejecuta 'npm run dev' para iniciar desarrollo" -ForegroundColor White
Write-Host ""
Write-Host "[SUCCESS] ¡Listo para construir tu MVP!" -ForegroundColor Green
