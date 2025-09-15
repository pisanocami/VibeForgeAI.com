---
description: Crea la estructura base por proyecto bajo docs/{project_slug}/ y deja artefactos iniciales.
category: project-management
stability: stable
---

# /create-project-base — Base de proyecto en docs/{project_slug}

## Variables
- `project_name`: Nombre legible del proyecto (ej.: "Acme Insights")
- `project_slug`: Slug kebab-case (ej.: `acme-insights`)
- `timestamp`: `yyyy-mm-dd_hhmm`
- `today`: `yyyy-mm-dd`

## Preflight
// turbo
- Crear directorio base: `docs/{project_slug}/`
- Crear subcarpetas mínimas:
  - `product/`
  - `orchestrator/logs/`
  - `status/`
- Inicializar status:
  - `docs/{project_slug}/status/status-{today}.json`
  - `docs/{project_slug}/status/latest.json`
- Crear índice inicial del proyecto:
  - `docs/{project_slug}/README.md` (usar plantilla `/.windsurf/templates/product/readme-index-template.md`)

## Estructura de producto (vacía, lista para poblar)
// turbo
- Crear subcarpetas de producto si no existen:
  - `brand/`, `discovery/`, `personas/`, `competition/`, `market/`, `ai/`, `value-prop/`, `prd/`, `roadmap/`, `metrics/`, `pricing/`, `gtm/`, `risks/`, `plan/`, `stack/`
- Crear placeholders `.gitkeep` en cada subcarpeta para asegurar versionado.

## Logs
// turbo
- Crear `docs/{project_slug}/orchestrator/logs/run-{timestamp}.md` con encabezado:
  - Contexto, Acciones, Artefactos creados, Próximos pasos.

## Siguiente
- Ejecutar `/product-strategy-and-definition` para poblar los artefactos del producto.
- Ejecutar `/orchestrator` para análisis, gates y publicación final en Notion.
