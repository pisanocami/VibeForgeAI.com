---
description: MVP — Backend seleccionable (Express+Drizzle por defecto; Fastify/Nest/Hono; opcional FastAPI)
auto_execution_mode: 3
---

# /mvp-backend — Backend del MVP (selección de tecnología)

Provisiona un backend enterprise-grade con autenticación Clerk, multi-tenant architecture y AI integration. Por defecto usa Node.js + Express + Drizzle + Zod + Clerk + Neon/Postgres + Google Gemini. Alternativas: Fastify, NestJS, Hono (Node) u opcional FastAPI (Python).

Related: `/crear-endpoint-api`, `/analizar-endpoints`, `/revisar-seguridad`

## Inputs (selección)
- `BACKEND_TECH`: `express-drizzle` (default) | `fastify` | `nest` | `hono` | `fastapi`
- `DB`: `neon-postgres` (default) | `sqlite` | `mongodb`
- `TARGET_DIR`: `server` (default)

## Preflight (Windows PowerShell) — compatible con nueva estructura de directorios
// turbo
```powershell
$PROJECT_ROOT = if ($env:PROJECT_ROOT) { $env:PROJECT_ROOT } else { (Get-Location).Path }
$TARGET_DIR = if ($env:TARGET_DIR) { $env:TARGET_DIR } else { (Join-Path $PROJECT_ROOT 'server') }
if (!(Test-Path $TARGET_DIR)) { 
  New-Item -ItemType Directory -Path $TARGET_DIR -Force | Out-Null 
  Write-Host "[mvp-backend] Created server directory: $TARGET_DIR"
}
```

## Intake libre (AutoParse)
// turbo
```powershell
$PROJECT_ROOT = if ($env:PROJECT_ROOT) { $env:PROJECT_ROOT } else { (Get-Location).Path }
$cfgPath = Join-Path $PROJECT_ROOT 'project-logs/mvp/intake/latest.json'
$BACKEND_TECH = $env:BACKEND_TECH
$DB = $env:DB
$TARGET_DIR = if ($env:TARGET_DIR) { $env:TARGET_DIR } else { (Join-Path $PROJECT_ROOT 'server') }

if (Test-Path $cfgPath) {
  try {
    $cfg = Get-Content $cfgPath | ConvertFrom-Json
    if (-not $BACKEND_TECH -and $cfg.backend_tech) { $BACKEND_TECH = $cfg.backend_tech }
    if (-not $DB -and $cfg.db) { $DB = $cfg.db }
  } catch { Write-Host "[mvp-backend] No se pudo leer $cfgPath: $($_.Exception.Message)" }
} else {
  $req = $env:MVP_REQUEST
  $reqPath = Join-Path $PROJECT_ROOT 'docs/mvp/REQUEST.txt'
  if (-not $req -and (Test-Path $reqPath)) { $req = Get-Content -Raw $reqPath }
  if ($req) {
    $lower = $req.ToLower()
    if ($lower -match 'fastapi|python') { $BACKEND_TECH = 'fastapi' }
    elseif ($lower -match 'express|drizzle|enterprise|portal|clerk') { $BACKEND_TECH = 'express-drizzle' }
    elseif ($lower -match 'nest') { $BACKEND_TECH = 'nest' }
    elseif ($lower -match 'hono|edge|serverless') { $BACKEND_TECH = 'hono' }
    elseif ($lower -match 'fastify') { $BACKEND_TECH = 'fastify' }
    else { if (-not $BACKEND_TECH) { $BACKEND_TECH = 'express-drizzle' } }

    if ($lower -match 'mongo') { $DB = 'mongodb' }
    elseif ($lower -match 'sqlite') { $DB = 'sqlite' }
    elseif ($lower -match 'postgres|neon') { $DB = 'neon-postgres' }
  }
}

if (-not $BACKEND_TECH) { $BACKEND_TECH = 'express-drizzle' }
if (-not $DB) { $DB = 'neon-postgres' }

Write-Host "[mvp-backend] BACKEND_TECH=$BACKEND_TECH DB=$DB TARGET_DIR=$TARGET_DIR"
```

> Nota: Los pasos siguientes usarán los valores inferidos: `BACKEND_TECH`, `DB` y `TARGET_DIR`.

## Opción A — Express + Drizzle + Clerk (Enterprise Portal - default)
// turbo
```powershell
$PROJECT_ROOT = if ($env:PROJECT_ROOT) { $env:PROJECT_ROOT } else { (Get-Location).Path }
$TARGET_DIR = if ($env:TARGET_DIR) { $env:TARGET_DIR } else { (Join-Path $PROJECT_ROOT 'server') }
if (!(Test-Path $TARGET_DIR)) { New-Item -ItemType Directory -Path $TARGET_DIR -Force | Out-Null }
Set-Location $TARGET_DIR
Write-Host "[mvp-backend] Setting up Express + Drizzle backend in $(Get-Location)"

npm init -y
npm install express cors helmet morgan dotenv zod express-rate-limit compression
npm install drizzle-orm postgres @neondatabase/serverless
npm install @clerk/clerk-sdk-node @clerk/backend
npm install @google/generative-ai
npm install bcryptjs jsonwebtoken @types/bcryptjs @types/jsonwebtoken
npm install -D typescript tsx @types/express @types/cors @types/morgan @types/compression
npm install -D drizzle-kit @types/node vitest @types/supertest supertest

# Initialize TypeScript
npx tsc --init --yes

# Initialize Drizzle
mkdir -p src/db src/routes src/middleware src/services src/types
npx drizzle-kit init

Write-Host "[mvp-backend] Backend dependencies installed and configured"
```

### Schema de Base de Datos Multi-Tenant
```typescript
// shared/schema.ts
import { pgTable, text, integer, timestamp, uuid, boolean } from 'drizzle-orm/pg-core';
import { createInsertSchema, createSelectSchema } from 'drizzle-zod';

export const organizations = pgTable('organizations', {
  id: uuid('id').primaryKey().defaultRandom(),
  name: text('name').notNull(),
  domain: text('domain').unique(),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const users = pgTable('users', {
  id: uuid('id').primaryKey().defaultRandom(),
  clerkId: text('clerk_id').unique().notNull(),
  organizationId: uuid('organization_id').references(() => organizations.id),
  email: text('email').notNull(),
  role: text('role').$type<'ADMIN' | 'USER'>().default('USER'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const reports = pgTable('reports', {
  id: uuid('id').primaryKey().defaultRandom(),
  organizationId: uuid('organization_id').references(() => organizations.id),
  title: text('title').notNull(),
  content: text('content'),
  status: text('status').$type<'DRAFT' | 'PUBLISHED' | 'ARCHIVED'>().default('DRAFT'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const aiAnalysis = pgTable('ai_analysis', {
  id: uuid('id').primaryKey().defaultRandom(),
  reportId: uuid('report_id').references(() => reports.id),
  content: text('content').notNull(),
  provider: text('provider').$type<'GEMINI' | 'OPENAI'>().default('GEMINI'),
  createdAt: timestamp('created_at').defaultNow(),
});

export const helpArticles = pgTable('help_articles', {
  id: uuid('id').primaryKey().defaultRandom(),
  title: text('title').notNull(),
  content: text('content').notNull(),
  category: text('category'),
  isPublished: boolean('is_published').default(true),
  viewCount: integer('view_count').default(0),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});
```

### Configuración de Clerk Authentication
```typescript
// server/src/middleware/auth.ts
import { ClerkExpressRequireAuth } from '@clerk/clerk-sdk-node';

export const requireAuth = ClerkExpressRequireAuth({
  onError: (error) => {
    console.error('Auth error:', error);
    throw error;
  }
});

export const requireAdmin = (req: any, res: any, next: any) => {
  if (req.auth?.user?.role !== 'ADMIN') {
    return res.status(403).json({ error: 'Admin access required' });
  }
  next();
};
```

### Servicio de AI con Google Gemini
```typescript
// server/src/services/aiService.ts
import { GoogleGenerativeAI } from '@google/generative-ai';

const genAI = new GoogleGenerativeAI(process.env.GOOGLE_GEMINI_API_KEY!);

export class AIService {
  async analyzeReport(content: string): Promise<string> {
    const model = genAI.getGenerativeModel({ model: 'gemini-pro' });
    const prompt = `Analyze this marketing report and provide insights:\n\n${content}`;
    
    const result = await model.generateContent(prompt);
    return result.response.text();
  }
}
```

### Estructura del proyecto
```
server/
  src/
    db/
      index.ts        # Drizzle configuration
      schema.ts       # Database schema
    middleware/
      auth.ts         # Clerk authentication
      cors.ts         # CORS configuration
      rateLimit.ts    # Rate limiting
    routes/
      organizations.ts
      users.ts
      reports.ts
      aiAnalysis.ts
      help.ts
    services/
      aiService.ts    # Google Gemini integration
      emailService.ts # Email notifications
    types/
      index.ts        # TypeScript types
    index.ts          # Express app entry point
    routes.ts         # Route aggregation
  drizzle.config.ts
  package.json
  tsconfig.json
```

### Variables de entorno
```bash
# .env
DATABASE_URL=postgresql://user:password@localhost:5432/force_of_nature
CLERK_SECRET_KEY=sk_test_...
GOOGLE_GEMINI_API_KEY=your_gemini_key
NODE_ENV=development
PORT=5000
FRONTEND_URL=http://localhost:3000
```

## Opción B — Express
// turbo
```powershell
$PROJECT_ROOT = if ($env:PROJECT_ROOT) { $env:PROJECT_ROOT } else { (Get-Location).Path }
$TARGET_DIR = if ($env:TARGET_DIR) { $env:TARGET_DIR } else { (Join-Path $PROJECT_ROOT 'apps/back') }
if (!(Test-Path $TARGET_DIR)) { New-Item -ItemType Directory -Path $TARGET_DIR -Force | Out-Null }
Set-Location $TARGET_DIR
npm init -y
npm i express cors zod bcryptjs jose @neondatabase/serverless dotenv
npm i -D tsx typescript @types/express @types/node @types/bcryptjs
npx tsc --init
```
- Crea `src/index.ts` con CORS, rutas `/auth/*` y validación con Zod.

## Opción C — NestJS
// turbo
```powershell
npm i -g @nestjs/cli
cd apps
nest new back
```
- Añade módulo `auth` con endpoints básicos.

## Opción D — Hono (Edge/Serverless-friendly)
// turbo
```powershell
cd apps/back
npm init -y
npm i hono zod jose dotenv @neondatabase/serverless
npm i -D tsx typescript @types/node
npx tsc --init
```

## Opción E — FastAPI (Python, opcional)
// turbo
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

## Artefactos (actualizado para nueva estructura)
- ✅ `server/` con scaffold Express + Drizzle + Clerk
- ✅ `package.json` con dependencias enterprise instaladas
- ✅ `src/` estructura organizada (db, routes, middleware, services, types)
- ✅ `drizzle.config.ts` y `tsconfig.json` configurados
- ✅ Schema multi-tenant creado
- ✅ Scripts `dev` y `start` configurados
- ✅ Compatible con directorio de proyecto creado por mvp-builder

## Aceptación (Done)
- ✅ API levanta en local y responde `/auth/*` y `/api/*`
- ✅ Backend configurado con Clerk authentication
- ✅ Base de datos Drizzle configurada
- ✅ Estructura de proyecto organizada dentro del directorio del proyecto
- ✅ Integración lista con frontend Vite