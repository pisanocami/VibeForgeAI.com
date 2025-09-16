---
description: MVP Workflows — Overview & Usage (AutoParse + Orchestrator)
auto_execution_mode: 3
---

# MVP Workflows — Guía Completa

Este directorio contiene workflows para construir un MVP de forma rápida y **orquestada con autorun**, con soporte de entrada libre en lenguaje natural.

## ✨ Características Principales

- **🔄 Autorun Mode**: Los workflows ejecutan automáticamente comandos sin pedir aprobación al usuario (mediante `// turbo`)
- **🧠 AutoParse**: Interpreta solicitudes en lenguaje natural para inferir tecnologías y módulos
- **🎯 Orquestador Inteligente**: Selecciona y ejecuta módulos según tu solicitud
- **📁 Multi-estructura**: Soporta tanto `apps/front|back` como `client|server`
- **🏗️ Creación de Directorios**: Crea automáticamente un directorio dedicado para cada proyecto MVP
- **⚡ Vite Template**: Utiliza Vite como base por defecto para proyectos frontend rápidos
- **🔒 Seguridad**: Cumple con Regla 1 de Notion (raíz dinámica por ejecución)
- **🔌 Arquitectura de Plugins Dinámicos**: Sistema modular y extensible de plugins especializados

Workflows incluidos:
- `/mvp-builder` — Orquestador inteligente que crea directorio del proyecto y ejecuta módulos automáticamente
- `/mvp-docs` — Documentación base (PRD, API Docs, Diagramas) con publicación opcional en Notion
- `/mvp-diagrams` — Diagramas esenciales (estructura, flujo, componentes, dependencias)
- `/mvp-frontend` — Frontend moderno (Vite + React + TypeScript por defecto; Next.js/SvelteKit/Angular)
- `/mvp-backend` — Backend enterprise (Express+Drizzle por defecto; Fastify/Nest/Hono; opcional FastAPI)
- `/mvp-security` — Auditorías rápidas de seguridad (deps, SAST opcional, secretos, a11y)
- `/mvp-from-pdf` — Genera documentación completa desde archivos PDF estratégicos

## 🔌 Arquitectura de Plugins Dinámicos

La nueva arquitectura refactoriza el sistema monolítico en un framework modular extensible:

### Estructura de Directorios
```
.windsurf/workflows/MVP/
├── core/                           # Motor central
│   ├── orchestrator.ps1           # Orquestador principal
│   ├── config-loader.ps1          # Carga unificada de configuración
│   └── plugin-manager.ps1         # Gestor de plugins
├── plugins/                        # Plugins especializados
│   ├── frontend/
│   │   ├── react-vite.ps1        # Scaffold React+Vite+Tailwind
│   │   ├── nextjs.ps1            # Scaffold Next.js
│   │   └── angular.ps1           # Scaffold Angular
│   ├── backend/
│   │   ├── fastify.ps1           # Scaffold Fastify+Drizzle
│   │   ├── express-drizzle.ps1   # Scaffold Express+Drizzle
│   │   └── nest.ps1              # Scaffold NestJS
│   └── integrations/
│       ├── neon-db.ps1           # Configuración Neon+esquemas
│       ├── clerk-auth.ps1        # Integración Clerk Auth
│       └── gemini-ai.ps1         # Integración Google Gemini AI
└── templates/                      # Templates dinámicos
    ├── base/                      # Templates básicos
    ├── enterprise/                # Templates enterprise
    └── saas/                      # Templates SaaS
```

### Beneficios
- **Modularidad**: Cada tecnología en su propio plugin independiente
- **Escalabilidad**: Añadir nuevas tecnologías sin modificar el core
- **Configuración Unificada**: Merge inteligente de múltiples fuentes (latest.json, mvp.config.json, env vars)
- **Ejecución Dinámica**: Plugins cargados y ejecutados según configuración
- **Mantenibilidad**: Separación clara entre motor y funcionalidades específicas

### Uso del Nuevo Sistema
```powershell
# Ejecutar desde el directorio core/
cd .windsurf/workflows/MVP/core/
. ./orchestrator.ps1
Start-MVPBuilder

# O con configuración específica
Start-MVPBuilder -Config @{
    plugins = @("docs", "frontend", "backend")
    frontend_tech = "react-vite"
    backend_tech = "fastify"
}
```

Los plugins existentes siguen funcionando, pero ahora se ejecutan a través del nuevo sistema modular.

## Quick Start (Actualizado)
1) **Desde PDF Ejecutivo** (Recomendado):
   ```powershell
   // turbo
   /mvp-from-pdf -PDF_PATH "c:\Users\admin\OneDrive\Escritorio\mvp-core\EXECUTIVE_README_STRATEGIC_EN_PRO.pdf" -OUTPUT_FORMAT "full-mvp"
   ```
   Luego ejecuta: `/mvp-builder`

2) **Desde Texto Libre** (elige una):
   - Variable de entorno (Windows PowerShell):
     ```powershell
     // turbo
     $env:MVP_REQUEST = "Landing con login y dashboard, Next.js con MongoDB. Sin backend separado (API Routes). Incluir auditoría de seguridad."
     ```
   - Archivo:
     ```powershell
     // turbo
     New-Item -ItemType Directory -Force -Path docs/mvp | Out-Null
     @"
     MVP: Front en React/Vite con Tailwind y shadcn; Backend Fastify; DB Postgres (Neon). Agregar diagramas.
     "@ | Out-File -Encoding UTF8 -FilePath docs/mvp/REQUEST.txt
     ```
   2) Ejecuta el orquestador: `/mvp-builder`
      - El orquestador **crea automáticamente un directorio del proyecto** (ej: `mvp-20240916-030506`)
      - Cambia al directorio del proyecto y ejecuta todos los módulos seleccionados
      - Guarda configuración en `project-logs/mvp/intake/latest.json`

3) Si necesitas solo una parte, ejecuta los workflows especializados.

## Prerrequisitos
- Node.js 18+ y npm
- Windows PowerShell (para ejecutar pasos `// turbo` **AutoRun**)
- Notion (solo si vas a publicar):
  - `NOTION_TOKEN` y `NOTION_WORKSPACE_PAGE_ID` configurados en tu entorno.
  - Ver `/.windsurf/workflows/Notion/create-dynamic-root.md` para detalles.
  - Plantilla de variables: `docs/mvp/env.example.ps1` (cópialo a `env.ps1` y cárgalo con `. .\env.ps1`).
- Opcional según tu selección:
  - Semgrep instalado si vas a correr SAST en `/mvp-security`
  - Python 3.x si eliges `fastapi` en `/mvp-backend`

Para ejemplos de solicitudes en lenguaje natural, revisa `docs/mvp/REQUEST.examples.txt`.

## Cómo se interpreta tu solicitud (AutoParse)
El sistema reconoce palabras clave para inferir:
- Módulos (SELECT): `docs`, `frontend`, `backend`, `diagrams`, `security`
  - docs/diagrams: “documentación”, “doc”, “diagrama/diagram”
  - security: “seguridad”, “OWASP”, “audit/auditor”
  - solo front/back: “solo front/only front”, “solo back/only back”
  - sin backend: “sin backend”, “estático/estatica/static”
- Frontend (FRONTEND_TECH):
  - `nextjs` (“next”), `sveltekit` (“svelte”), `angular` (“angular”), por defecto `react-vite`
- Backend (BACKEND_TECH):
  - `express-drizzle` ("express"/"drizzle"/"enterprise"/"portal"), `fastify`, `nest`, `hono` (edge/serverless), por defecto `express-drizzle`
  - `fastapi` ("fastapi"/"python")
- Base de datos (DB):
  - `mongodb` (“mongo”), `sqlite`, `neon-postgres` (“postgres”/“neon”)
- UI (UI_LIBS):
  - `tailwind+shadcn` (“shadcn”), `tailwind` (“tailwind”), `none` (“chakra/mui/bootstrap”)

Orden de precedencia:
1) `project-logs/mvp/intake/latest.json` (si existe)
2) Variables de entorno (p. ej. `FRONTEND_TECH`, `BACKEND_TECH`, `DB`, `UI_LIBS`)
3) `MVP_REQUEST` o `docs/mvp/REQUEST.txt`
4) Defaults: React+Vite, **Express+Drizzle**, Neon/Postgres, Tailwind+shadcn, SELECT=[docs, frontend, backend, diagrams]

Para reiniciar el parseo:
```powershell
// turbo
Remove-Item project-logs/mvp/intake/latest.json -ErrorAction SilentlyContinue
```

## Presets útiles
- Solo documentación: `SELECT = [docs, diagrams]`
- MVP mínimo ejecutable: `SELECT = [docs, frontend, backend, diagrams]`
- Hardening rápido: añade `security`

## Publicación en Notion (Regla 1)
- Los workflows publican en Notion creando SIEMPRE una nueva página raíz con `/create-dynamic-root`.
- No se usan IDs codificados ni de corridas previas. Los enlaces se registran en `project-logs/mvp/logs/run-*.md`.

## 🔄 Modo Autorun y // turbo

Los workflows incluyen anotaciones `// turbo` en pasos de ejecución automática:
- **Sin aprobación manual**: Comandos de instalación, configuración y setup se ejecutan automáticamente
- **Flujo optimizado**: Solo se piden decisiones estratégicas (módulos, tecnologías)
- **Ejecución confiable**: Los pasos marcados con `// turbo` corren sin intervención del usuario

### Ejemplo de ejecución autorun:
```powershell
# Este comando se ejecuta automáticamente (// turbo)
npm install express cors helmet morgan dotenv zod
```

## Estructura de artefactos (actualizada con directorios de proyecto)
Después de ejecutar `/mvp-builder`, se crea:

```
mi-proyecto-mvp/                    # Directorio del proyecto creado automáticamente
├── client/                         # Frontend Vite + React + TypeScript
│   ├── src/
│   │   ├── lib/
│   │   │   ├── api.ts           # Cliente API con TanStack Query
│   │   │   └── utils.ts          # Utilidades (cn, formatters)
│   │   ├── components/
│   │   ├── pages/
│   │   ├── hooks/
│   │   └── types/
│   ├── package.json
│   └── vite.config.ts
├── server/                         # Backend Express + Drizzle + Clerk
│   ├── src/
│   │   ├── db/
│   │   ├── routes/
│   │   ├── middleware/
│   │   └── services/
│   ├── package.json
│   └── drizzle.config.ts
├── docs/mvp/                       # Documentación PRD, API, diagramas
├── project-logs/mvp/               # Logs de ejecución y configuración
├── README.md                       # Documentación del proyecto generado
├── .gitignore                      # Git ignore generado automáticamente
└── .env.example                    # Variables de entorno ejemplo
```

## Troubleshooting
- “No respeta mi selección”: Define variables de override antes de ejecutar (`FRONTEND_TECH`, `BACKEND_TECH`, `DB`, `UI_LIBS`).
- “Cambios no toman efecto”: Borra `project-logs/mvp/intake/latest.json` y vuelve a ejecutar.
- “Semgrep no está instalado”: El paso SAST se salta si la herramienta no está disponible.
- “Quiero Next.js sin backend separado”: Usa “API Routes”, el parser quita `backend` del SELECT cuando detecta “sin backend/static”.

## Recomendaciones extra
- CI y quality gates: ejecutar `/ci-quality-gates`
- E2E: `/playwright-e2e`
- Unit tests: `/vitest-unit`
- Observabilidad: `/monitoring-and-observability`
- Deploy: `/ci-cd-pipeline`

## Criterios de aceptación (MVP completo - actualizado)
- ✅ **Directorio del proyecto creado** (ej: `mvp-20240916-030506`)
- ✅ Módulos seleccionados ejecutados dentro del directorio del proyecto
- ✅ Front y Back corriendo en local cuando aplica
- ✅ **Vite template configurado** como base del frontend
- ✅ Documentación básica generada (PRD, API, diagramas)
- ✅ Seguridad básica revisada (si se incluyó)
- ✅ README.md y .gitignore generados automáticamente
- ✅ (Opcional) Publicación en Notion con raíz creada dinámicamente

## Changelog
- **2025-09-16** — ✅ **Arquitectura de Plugins Dinámicos**: Refactorización completa del sistema en framework modular extensible con core/, plugins/ y templates/
- **2025-09-16** — ✅ **Creación automática de directorios de proyecto**: Cada MVP se crea en su propio directorio dedicado
- **2025-09-16** — ✅ **Vite template por defecto**: Frontend basado en Vite + React + TypeScript
- **2025-09-16** — Primera versión del paquete MVP con AutoParse + Orquestador
- **2025-09-16** — ✅ **Autorun Mode habilitado**: Añadidas anotaciones `// turbo` a todos los workflows para ejecución automática sin aprobación manual
- **2025-09-16** — ✅ **Backend Enterprise**: Express+Drizzle ahora es el backend por defecto con Clerk auth, Google Gemini AI y multi-tenant schema
- **2025-09-16** — ✅ **Frontend Moderno**: Soporte completo para React+Vite+Tailwind+shadcn con estructura optimizada
- **2025-09-16** — ✅ **Multi-estructura**: Soporte para `client/server` y `apps/front/back` según preferencia
- **2025-09-16** — ✅ **Orquestador Inteligente**: Detección automática de solicitudes enterprise/portal para stack completo