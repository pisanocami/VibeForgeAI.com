param([hashtable]$Context)

Write-Host "[backend] Plugin ejecutado" -ForegroundColor Cyan
if ($null -ne $Context) {
  Write-Host ("Contexto: " + ($Context | ConvertTo-Json -Compress)) -ForegroundColor DarkGray
}

$rootOut = $Context.output_dir
if (-not $rootOut) { throw "[backend] 'output_dir' no definido en Context" }
$outDir = Join-Path $rootOut 'server'
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$backend = ($Context.backend_tech | ForEach-Object { $_.ToString().ToLower() })
switch ($backend) {
  'fastapi' {
    # requirements.txt
    $req = @("fastapi==0.111.0","uvicorn==0.30.0") -join "`r`n"
    Set-Content -LiteralPath (Join-Path $outDir 'requirements.txt') -Value $req -Encoding UTF8

    # main.py
    $py = @'
from fastapi import FastAPI

app = FastAPI(title="MVP Server", version="0.1.0")

@app.get("/")
def root():
    return {"status": "ok", "service": "mvp-server"}

@app.get("/health")
def health():
    return {"ok": True}

# Run: uvicorn main:app --reload --host 0.0.0.0 --port 8000
'@
    Set-Content -LiteralPath (Join-Path $outDir 'main.py') -Value $py -Encoding UTF8

    # README
    $readme = @()
    $readme += "# MVP Server (FastAPI)"
    $readme += ""
    $readme += "## Setup"
    $readme += "python -m venv .venv"
    $readme += "./.venv/Scripts/activate   # Windows"
    $readme += "pip install -r requirements.txt"
    $readme += ""
    $readme += "## Run"
    $readme += "uvicorn main:app --reload --host 0.0.0.0 --port 8000"
    Set-Content -LiteralPath (Join-Path $outDir 'README.md') -Value ($readme -join "`r`n") -Encoding UTF8

    Write-Host "[backend] FastAPI generado en $outDir" -ForegroundColor Green
  }
  default {
    $md = "# Backend placeholder`r`nSeleccionaste: $backend. Agrega implementaciones específicas."
    Set-Content -LiteralPath (Join-Path $outDir 'README.md') -Value $md -Encoding UTF8
    Write-Host "[backend] Placeholder creado para backend '$backend' en $outDir" -ForegroundColor Yellow
  }
}
