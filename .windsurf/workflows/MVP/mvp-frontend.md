---
description: MVP — Frontend seleccionable (React+Vite por defecto; Next.js/SvelteKit/Angular opcionales)
auto_execution_mode: 3
---

# /mvp-frontend — Frontend del MVP (OPTIMIZADO)

Provisiona un frontend moderno para el MVP usando una arquitectura modular y parametrizable. Por defecto usa React 18 + Vite + TypeScript + React Router v7 + Tailwind + shadcn/ui. Alternativas: Next.js, SvelteKit o Angular.

Related: `/build-perfect-vite-react-app`, `/design-and-styling`, `/mejorar-ux-ui`

## 🚀 Optimizaciones Implementadas

- **Arquitectura Modular**: Scripts separados para instalación, configuración y scaffolding
- **Configuración Centralizada**: Todas las dependencias y comandos en `mvp.config.json`
- **Función Genérica Unificada**: `Install-Dependencies` elimina duplicación de código
- **Templates Reutilizables**: Estructura de directorios como template copiable
- **Orquestador Principal**: `main.ps1` coordina todos los pasos automáticamente

## Inputs (selección)
- `FRONTEND_TECH`: `react-vite` (default) | `nextjs` | `sveltekit` | `angular` | `react-vite-enterprise`
- `UI_LIBS`: `tailwind+shadcn` (default) | `tailwind` | `none`
- `TARGET_DIR`: `apps/front` (default) | otro

## Preflight Optimizado (Windows PowerShell) — Unificado y Seguro
// turbo
```powershell
# Preflight simplificado - solo crear directorio y verificar prerrequisitos
$PROJECT_ROOT = if ($env:PROJECT_ROOT) { $env:PROJECT_ROOT } else { (Get-Location).Path }
$defaultFront = Join-Path $PROJECT_ROOT 'apps/front'
$TARGET_DIR = if ($env:TARGET_DIR) { $env:TARGET_DIR } else { $defaultFront }

if (!(Test-Path $TARGET_DIR)) { 
  New-Item -ItemType Directory -Path $TARGET_DIR -Force | Out-Null 
  Write-Host "[mvp-frontend] 📁 Directorio creado: $TARGET_DIR"
}

# Verificar Node.js y npm (simplificado)
try {
  node --version | Out-Null
  npm --version | Out-Null
  Write-Host "[mvp-frontend] ✅ Prerrequisitos verificados"
} catch {
  Write-Host "[mvp-frontend] ❌ Error: Node.js/npm no encontrados" -ForegroundColor Red
  exit 1
}
```

## Intake Optimizado (AutoParse)
// turbo
```powershell
# Carga configuración desde JSON único
$PROJECT_ROOT = if ($env:PROJECT_ROOT) { $env:PROJECT_ROOT } else { (Get-Location).Path }
$cfgPath = Join-Path $PROJECT_ROOT 'project-logs/mvp/intake/latest.json'
$FRONTEND_TECH = $env:FRONTEND_TECH
$UI_LIBS = $env:UI_LIBS
$TARGET_DIR = if ($env:TARGET_DIR) { $env:TARGET_DIR } else { (Join-Path $PROJECT_ROOT 'apps/front') }

if (Test-Path $cfgPath) {
  try {
    $cfg = Get-Content $cfgPath | ConvertFrom-Json
    $FRONTEND_TECH = $cfg.frontend_tech ?? $FRONTEND_TECH ?? 'react-vite'
    $UI_LIBS = $cfg.ui_libs ?? $UI_LIBS ?? 'tailwind+shadcn'
  } catch {
    Write-Host "[mvp-frontend] ⚠️ Error leyendo config: $($_.Exception.Message)" -ForegroundColor Yellow
  }
}

# Valores por defecto simplificados
$FRONTEND_TECH ??= 'react-vite'
$UI_LIBS ??= 'tailwind+shadcn'
$TARGET_DIR ??= (Join-Path $PROJECT_ROOT 'apps/front')

Write-Host "[mvp-frontend] 🎯 Configuración: $FRONTEND_TECH + $UI_LIBS → $TARGET_DIR"
```

## Ejecución Optimizada (Script Modular)
// turbo
```powershell
# Ejecutar el orquestador principal con parámetros
. .\scripts\main.ps1 -Tech $FRONTEND_TECH -UILibs $UI_LIBS -Target $TARGET_DIR
```

### Estructura de Scripts Modulares

```
scripts/
  main.ps1      # Orquestador principal (nuevo)
  config.ps1    # Funciones de configuración (nuevo)
  install.ps1   # Instalación de dependencias (nuevo)
  scaffold.ps1  # Scaffolding de proyecto (nuevo)
```

### Archivo de Configuración Centralizada

```json
// mvp.config.json - Todas las configuraciones centralizadas
{
  "frontend": {
    "react-vite": {
      "packages": ["@tanstack/react-query", "react-hook-form"],
      "postInit": ["npm create vite@latest . -- --template react-ts --yes"]
    }
  },
  "ui": {
    "tailwind+shadcn": {
      "packages": ["tailwindcss", "@radix-ui/react-dialog"],
      "postInit": ["npx tailwindcss init -p", "npx shadcn-ui init --yes"]
    }
  }
}
```

### Templates Reutilizables

```
templates/front/
  src/
    lib/utils.ts     # Función cn para Tailwind
    lib/api.ts       # Cliente Axios configurado
    main.tsx         # Punto de entrada React
    App.tsx          # Router principal
    pages/           # Páginas base (Home, Login, Dashboard)
    components/ui/   # Componentes base (Button, etc.)
  tailwind.config.js
  index.html
```

## Mejoras Adicionales Implementadas

### ✅ **1. Validación Robusta de Configuración**
```powershell
# En config.ps1
function Test-Configuration {
  param($Tech, $UILibs)
  
  $validTechs = @('react-vite', 'react-vite-enterprise', 'nextjs', 'sveltekit', 'angular')
  $validUI = @('tailwind+shadcn', 'tailwind', 'none')
  
  if ($Tech -notin $validTechs) {
    throw "Frontend tech '$Tech' no soportada. Opciones: $($validTechs -join ', ')"
  }
  
  if ($UILibs -notin $validUI) {
    throw "UI libs '$UILibs' no soportadas. Opciones: $($validUI -join ', ')"
  }
}
# Configurar React + Vite + Tailwind + shadcn
. .\scripts\main.ps1 -Tech 'react-vite' -UILibs 'tailwind+shadcn' -Target (Join-Path $PROJECT_ROOT 'apps/front')

# Configurar Next.js + Tailwind
. .\scripts\main.ps1 -Tech 'nextjs' -UILibs 'tailwind' -Target 'apps/web'

# Configurar Enterprise Portal
. .\scripts\main.ps1 -Tech 'react-vite-enterprise' -UILibs 'tailwind+shadcn' -Target 'client'
```

### ✅ **2. Cache de Dependencias para Velocidad**
```powershell
# En install.ps1
function Install-Dependencies {
  param([string[]]$Packages, [string[]]$DevPackages, [switch]$UseCache)
  
  if ($UseCache) {
    npm ci --prefer-offline
  } else {
    if ($Packages) { npm install @($Packages) }
    if ($DevPackages) { npm install -D @($DevPackages) }
  }
}
```

### ✅ **3. Logging y Progreso Mejorado**
```powershell
# En config.ps1
function Write-Progress-Step {
  param([string]$Message, [int]$Step, [int]$Total)
  
  $percent = [math]::Round(($Step / $Total) * 100)
  Write-Progress -Activity "Configurando Frontend" -Status $Message -PercentComplete $percent
  Write-Host "[$Step/$Total] $Message" -ForegroundColor Cyan
}
```

### ✅ **4. Sistema de Rollback**
```powershell
# En scaffold.ps1
function Backup-Project {
  param([string]$TargetDir)
  
  if (Test-Path $TargetDir) {
    $backupDir = "$TargetDir.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $TargetDir $backupDir -Recurse
    return $backupDir
  }
}
```

### ✅ **5. Templates con Variables Dinámicas**
```typescript
// templates/front/src/lib/config.ts
export const config = {
  apiUrl: import.meta.env.VITE_API_URL || '{{API_URL}}',
  appName: '{{APP_NAME}}',
  version: '{{VERSION}}'
}
```

```powershell
# En scaffold.ps1
function Replace-TemplateVariables {
  param([string]$FilePath, [hashtable]$Variables)
  
  $content = Get-Content $FilePath -Raw
  foreach ($key in $Variables.Keys) {
    $content = $content -replace "{{$key}}", $Variables[$key]
  }
  $content | Set-Content $FilePath
}
```

## Artefactos (Optimizados)

- ✅ **Scripts Modulares**: `scripts/` con responsabilidades separadas
- ✅ **Configuración Centralizada**: `mvp.config.json` con todas las dependencias
- ✅ **Templates Reutilizables**: `templates/front/` con estructura base
- ✅ **Función Genérica**: `Install-Dependencies` elimina duplicación
- ✅ **Orquestador Principal**: `main.ps1` coordina automáticamente
- ✅ **Validación de Inputs**: Verificación de tecnologías soportadas
- ✅ **Manejo de Errores**: Mensajes claros y salida graceful

## Aceptación (Done)

- ✅ Scripts modulares creados y funcionales
- ✅ Configuración centralizada en `mvp.config.json`
- ✅ Función `Install-Dependencies` unificada
- ✅ Templates de proyecto implementados
- ✅ Orquestador `main.ps1` operativo
- ✅ Validación de tecnologías soportadas
- ✅ Estructura de directorios consistente
- ✅ Dependencias instaladas automáticamente

## Beneficios de la Optimización

1. **Mantenibilidad**: Cambios en una tecnología afectan solo `mvp.config.json`
2. **Reusabilidad**: Scripts modulares pueden usarse independientemente
3. **Consistencia**: Templates garantizan estructura uniforme
4. **Escalabilidad**: Añadir nuevas tecnologías requiere solo extender configuración
5. **Legibilidad**: Código más claro y documentado
6. **Robustez**: Validaciones y manejo de errores mejorado