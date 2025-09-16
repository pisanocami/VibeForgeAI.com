param([hashtable]$Context)

Write-Host "[docs] Plugin ejecutado" -ForegroundColor Cyan
if ($null -ne $Context) {
  Write-Host ("Contexto: " + ($Context | ConvertTo-Json -Compress)) -ForegroundColor DarkGray
}

$outDir = $Context.output_dir
if (-not $outDir) { throw "[docs] 'output_dir' no definido en Context" }
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

# Crear README.md básico
$readme = @()
$readme += "# MVP — $(($Context.request) -replace '[\r\n]+',' ')"
$readme += ""
$readme += "Generado por MVP Console."
$readme += ""
$readme += "## Tech"
$readme += "- Frontend: $($Context.frontend_tech)"
$readme += "- Backend: $($Context.backend_tech)"
$readme += "- UI: $($Context.ui_libs)"
$readme += "- DB: $($Context.db)"
$readmeText = ($readme -join "`r`n")
Set-Content -LiteralPath (Join-Path $outDir 'README.md') -Value $readmeText -Encoding UTF8

# .gitignore básico
$gi = @("node_modules/","dist/",".venv/","__pycache__/",".env",".DS_Store") -join "`r`n"
Set-Content -LiteralPath (Join-Path $outDir '.gitignore') -Value $gi -Encoding UTF8

Write-Host "[docs] Archivos de documentación creados en $outDir" -ForegroundColor Green
