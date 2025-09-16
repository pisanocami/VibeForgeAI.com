---
description: MVP — Backend seleccionable (Fastify+TS por defecto; Express/Nest/Hono; opcional FastAPI)
category: mvp
stability: experimental
---

# /mvp-backend — Backend del MVP (selección de tecnología)

Provisiona un backend mínimo seguro con autenticación básica. Por defecto usa Node.js + Fastify + TypeScript + Zod + JWT (`jose`) + Neon/Postgres. Alternativas: Express, NestJS, Hono (Node) u opcional FastAPI (Python).

Related: `/crear-endpoint-api`, `/analizar-endpoints`, `/revisar-seguridad`

## Inputs (selección)
- `BACKEND_TECH`: `fastify` (default) | `express` | `nest` | `hono` | `fastapi`
- `DB`: `neon-postgres` (default) | `sqlite` | `mongodb`
- `TARGET_DIR`: `apps/back` (default)

## Preflight (Windows PowerShell) — seguro para auto‑ejecutar
// turbo
```powershell
$target = 'apps/back'
if (!(Test-Path $target)) { New-Item -ItemType Directory -Path $target | Out-Null }
```

## Intake libre (AutoParse)
// turbo
```powershell
$cfgPath = 'project-logs/mvp/intake/latest.json'
$BACKEND_TECH = $env:BACKEND_TECH
$DB = $env:DB
$TARGET_DIR = if ($env:TARGET_DIR) { $env:TARGET_DIR } else { 'apps/back' }

if (Test-Path $cfgPath) {
  try {
    $cfg = Get-Content $cfgPath | ConvertFrom-Json
    if (-not $BACKEND_TECH -and $cfg.backend_tech) { $BACKEND_TECH = $cfg.backend_tech }
    if (-not $DB -and $cfg.db) { $DB = $cfg.db }
  } catch { Write-Host "[mvp-backend] No se pudo leer $cfgPath: $($_.Exception.Message)" }
} else {
  $req = $env:MVP_REQUEST
  $reqPath = "docs/mvp/REQUEST.txt"
  if (-not $req -and (Test-Path $reqPath)) { $req = Get-Content -Raw $reqPath }
  if ($req) {
    $lower = $req.ToLower()
    if ($lower -match 'fastapi|python') { $BACKEND_TECH = 'fastapi' }
    elseif ($lower -match 'express') { $BACKEND_TECH = 'express' }
    elseif ($lower -match 'nest') { $BACKEND_TECH = 'nest' }
    elseif ($lower -match 'hono|edge|serverless') { $BACKEND_TECH = 'hono' }
    else { if (-not $BACKEND_TECH) { $BACKEND_TECH = 'fastify' } }

    if ($lower -match 'mongo') { $DB = 'mongodb' }
    elseif ($lower -match 'sqlite') { $DB = 'sqlite' }
    elseif ($lower -match 'postgres|neon') { $DB = 'neon-postgres' }
  }
}

if (-not $BACKEND_TECH) { $BACKEND_TECH = 'fastify' }
if (-not $DB) { $DB = 'neon-postgres' }

Write-Host "[mvp-backend] BACKEND_TECH=$BACKEND_TECH DB=$DB TARGET_DIR=$TARGET_DIR"
```

> Nota: Los pasos siguientes usarán los valores inferidos: `BACKEND_TECH`, `DB` y `TARGET_DIR`.

## Opción A — Fastify + TypeScript (default)
```powershell
cd apps/back
npm init -y
npm i fastify fastify-cors zod bcryptjs jose @neondatabase/serverless dotenv
npm i -D tsx typescript @types/node @types/bcryptjs
npx tsc --init
```
Estructura sugerida:
```
src/
  index.ts
  env.ts
  db.ts
  auth.ts
  routes/
    auth.ts
```
- Implementa `/auth/register`, `/auth/login`, `/auth/me` (similares al workflow de Vite+React App).

## Opción B — Express
```powershell
cd apps/back
npm init -y
npm i express cors zod bcryptjs jose @neondatabase/serverless dotenv
npm i -D tsx typescript @types/express @types/node @types/bcryptjs
npx tsc --init
```
- Crea `src/index.ts` con CORS, rutas `/auth/*` y validación con Zod.

## Opción C — NestJS
```powershell
npm i -g @nestjs/cli
cd apps
nest new back
```
- Añade módulo `auth` con endpoints básicos.

## Opción D — Hono (Edge/Serverless-friendly)
```powershell
cd apps/back
npm init -y
npm i hono zod jose dotenv @neondatabase/serverless
npm i -D tsx typescript @types/node
npx tsc --init
```

## Opción E — FastAPI (Python, opcional)
```powershell
# Windows
py -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install fastapi uvicorn pydantic bcrypt python-jose
```
- `main.py` con rutas `/auth/*` y validación.

## Seguridad y Config
- `.env` con `DATABASE_URL`, `JWT_SECRET`, `PORT`.
- CORS abierto en desarrollo, restringido en producción.
- Validación de entrada con Zod/Pydantic.

## Artefactos
- `apps/back/` con scaffold elegido
- Scripts `dev` y `start` configurados

## Aceptación (Done)
- API levanta en local y responde `/auth/*`
- Validación de inputs y manejo de errores básico
