---
description: Índice de Workflows para Product Owner + Fullstack
---

# PO + Fullstack — Índice de Workflows

Usa esta guía para elegir rápidamente el workflow adecuado según tu objetivo.

## Descubrimiento y Plan
- /product-discovery-lite → convertir oportunidades en PRD breves con hipótesis y KPIs.
- /backlog-grooming → transformar PRD en épicas/historias listas para sprint.

## Calidad, Delivery y Releases
- /ci-quality-gates → pipeline CI con tipos, tests, deps y artefactos de logs.
- /release-cut → corte de versión con changelog, tag y smoke test.
- /secrets-and-env-governance → gobernanza de secretos y .env.

## Cómo se integran con el orquestador
- Planea con `/orchestrator-plan`, ejecuta con `/orchestrator-control`, y monitorea con `/orchestrator-status`.
- Los artefactos viven en `project-logs/` y `docs/` para trazabilidad.

## Rutas relacionadas
- `workflows/orchestrator.md` — orquestación maestra.
- `workflows/agent.md` y `workflows/websitedebug.md` — análisis y debug con navegador.
- `workflows/redisenar-pagina-ux.md` y `workflows/design-and-styling.md` — UX/UI.
