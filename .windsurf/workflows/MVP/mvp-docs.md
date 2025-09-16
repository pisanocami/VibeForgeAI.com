---
description: MVP — Documentación base (PRD, arquitectura, API) con publicación opcional en Notion
auto_execution_mode: 3
---

# /mvp-docs — Documentación base del MVP

Genera la documentación esencial del MVP: estrategia y PRD, API docs y diagramas de arquitectura. Opcionalmente, publica en Notion cumpliendo la Regla 1 (crear SIEMPRE una nueva página raíz dinámica por ejecución).

Related: `/product-strategy-and-definition`, `/api-docs`, `/architecture-diagrams`, `/create-dynamic-root`

## Objetivo
- PRD y documentación estratégica mínimas para alinear alcance del MVP
- Documentación de API y endpoints clave
- Diagramas de arquitectura y flujo de datos (alto nivel)
- Opción de publicación a Notion respetando la Regla 1

## Entradas
- Contexto del producto/idea inicial
- Lista de features del MVP (borrador)
- Stack tentativo (si existe)

## Preflight (Windows PowerShell) — seguro para auto‑ejecutar
// turbo
```powershell
$paths = @('docs/mvp','project-logs/mvp','project-logs/mvp/logs')
$paths | ForEach-Object { if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ | Out-Null } }
$log = "project-logs/mvp/logs/run-$(Get-Date -Format yyyyMMdd-HHmmss).md"
"# /mvp-docs run $(Get-Date)" | Out-File -Encoding UTF8 -FilePath $log
"- Preflight OK" | Add-Content $log
```

## Pasos

### 1) Base estratégica y PRD
// turbo
- Ejecuta `/product-strategy-and-definition` para generar los artefactos de base en `docs/{project_slug}/product/` (si no hay slug aún, usar `docs/mvp/` temporalmente).
- Registra rutas y timestamp en `project-logs/mvp/logs/`.

### 2) API Docs (REST/GraphQL)
// turbo
- Ejecuta `/api-docs` y enfoca en los endpoints mínimos del MVP.
- Artefactos esperados:
  - `docs/mvp/api/README.md`
  - `docs/mvp/api/examples/*.http`

### 3) Diagramas esenciales
// turbo
- Ejecuta `/architecture-diagrams` para tener vistas de alto nivel (estructura, flujo de datos, dependencias).
- Guarda copias bajo `docs/mvp/diagrams/`.

### 4) Component/Patterns docs (opcional)
// turbo
- Ejecuta `/component-docs` y `/patterns-docs` si hay UI definida.

### 5) Publicación en Notion (opcional, cumpliendo Regla 1)
// turbo
- Ejecuta `/create-dynamic-root` para crear SIEMPRE una nueva raíz Notion y obtener dinámicamente `root_page_id`.
- Publica como subpáginas: PRD, API y Diagramas bajo esa raíz.
- Registra URLs y mapping local→Notion en `project-logs/mvp/logs/run-*.md`.

## Artefactos
- `docs/mvp/` con:
  - `prd/` y documentos de estrategia base
  - `api/` con endpoints y ejemplos
  - `diagrams/` con Mermaid y/o PNG/SVG
- `project-logs/mvp/logs/run-*.md` con bitácora

## Aceptación (Done)
- PRD mínimo definido y versionado
- API mínima documentada
- 2+ diagramas de arquitectura presentes
- Si se publicó en Notion: raíz creada dinámicamente y links registrados

## Dry‑run
- Ejecutar pasos sin escribir archivos, validando inputs y rutas.