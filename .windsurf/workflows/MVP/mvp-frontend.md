---
description: MVP — Frontend seleccionable (React+Vite por defecto; Next.js/SvelteKit/Angular opcionales)
category: mvp
stability: experimental
---

# /mvp-frontend — Frontend del MVP (selección de tecnología)

Provisiona un frontend moderno para el MVP. Por defecto usa React 18 + Vite + TypeScript + React Router v7 + Tailwind + shadcn/ui. Alternativas: Next.js, SvelteKit o Angular.

Related: `/build-perfect-vite-react-app`, `/design-and-styling`, `/mejorar-ux-ui`

## Inputs (selección)
- `FRONTEND_TECH`: `react-vite` (default) | `nextjs` | `sveltekit` | `angular`
- `UI_LIBS`: `tailwind+shadcn` (default) | `tailwind` | `none`
- `TARGET_DIR`: `apps/front` (default) | otro

## Preflight (Windows PowerShell) — seguro para auto‑ejecutar
// turbo
```powershell
$target = 'apps/front'
if (!(Test-Path $target)) { New-Item -ItemType Directory -Path $target | Out-Null }
```

## Paths sugeridos
- Monorepo: `apps/front/`
- Repo single: raíz del repo

## Intake libre (AutoParse)
// turbo
```powershell
$cfgPath = 'project-logs/mvp/intake/latest.json'
$FRONTEND_TECH = $env:FRONTEND_TECH
$UI_LIBS = $env:UI_LIBS
$TARGET_DIR = if ($env:TARGET_DIR) { $env:TARGET_DIR } else { 'apps/front' }

if (Test-Path $cfgPath) {
  try {
    $cfg = Get-Content $cfgPath | ConvertFrom-Json
    if (-not $FRONTEND_TECH -and $cfg.frontend_tech) { $FRONTEND_TECH = $cfg.frontend_tech }
    if (-not $UI_LIBS -and $cfg.ui_libs) { $UI_LIBS = $cfg.ui_libs }
  } catch { Write-Host "[mvp-frontend] No se pudo leer $cfgPath: $($_.Exception.Message)" }
} else {
  $req = $env:MVP_REQUEST
  $reqPath = "docs/mvp/REQUEST.txt"
  if (-not $req -and (Test-Path $reqPath)) { $req = Get-Content -Raw $reqPath }
  if ($req) {
    $lower = $req.ToLower()
    if ($lower -match 'next') { $FRONTEND_TECH = 'nextjs' }
    elseif ($lower -match 'svelte') { $FRONTEND_TECH = 'sveltekit' }
    elseif ($lower -match 'angular') { $FRONTEND_TECH = 'angular' }
    else { if (-not $FRONTEND_TECH) { $FRONTEND_TECH = 'react-vite' } }

    if ($lower -match 'shadcn') { $UI_LIBS = 'tailwind+shadcn' }
    elseif ($lower -match 'tailwind') { $UI_LIBS = 'tailwind' }
    elseif ($lower -match 'chakra|mui|bootstrap') { $UI_LIBS = 'none' }
  }
}

if (-not $FRONTEND_TECH) { $FRONTEND_TECH = 'react-vite' }
if (-not $UI_LIBS) { $UI_LIBS = 'tailwind+shadcn' }

Write-Host "[mvp-frontend] FRONTEND_TECH=$FRONTEND_TECH UI_LIBS=$UI_LIBS TARGET_DIR=$TARGET_DIR"
```

> Nota: Los pasos siguientes usarán los valores inferidos: `FRONTEND_TECH`, `UI_LIBS` y `TARGET_DIR`.

## Opción A — React + Vite (default)
1) Ejecuta `/build-perfect-vite-react-app` y adapta la salida a `apps/front` si corresponde.
2) Instala libs UI si se eligió `tailwind+shadcn`.
3) Crea páginas base: Home, Login, Register, Dashboard y protección de rutas.

## Opción B — Next.js
```powershell
# Windows PowerShell
cd apps
npx create-next-app@latest front --typescript --eslint --app --tailwind
```
- Añade rutas: `/login`, `/dashboard`.
- Añade layout compartido y provider de estado si aplica.

## Opción C — SvelteKit
```powershell
cd apps
npm create svelte@latest front
cd front
npm i
```
- Configura rutas + stores básicos.

## Opción D — Angular
```powershell
npm i -g @angular/cli
ng new front --directory apps/front --routing --style css
```

## Integración UI
- Tailwind: `npm i -D tailwindcss postcss autoprefixer && npx tailwindcss init -p` y configura `content`.
- shadcn/ui (React): seguir guía oficial e instalar componentes base.

## Artefactos
- `apps/front/` con scaffold y páginas mínimas
- `README.md` con scripts de desarrollo

## Aceptación (Done)
- App arranca con `npm run dev` (o equivalente)
- Rutas básicas funcionando
- Estilos base listos (si se eligió Tailwind)
