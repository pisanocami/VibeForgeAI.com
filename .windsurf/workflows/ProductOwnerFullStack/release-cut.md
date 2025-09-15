---
description: Release Management & Changelog para cortes de versión reproducibles y trazables
---

# /release-cut

## Objetivo
Cortar una versión con checklist de verificación, changelog claro y capacidad de rollback rápido.

## Entradas
- Versión objetivo (vX.Y.Z)
- Notas de cambios (PRs/commits relevantes)

## Pasos
1) Prechecks de calidad
- Ejecutar `npx tsc --noEmit` y guardar a `project-logs/ts-diagnostics.txt`
- Ejecutar tests `npm test --silent` (si existen) y guardar resultado
- Ejecutar `npx depcheck` y `npx ts-prune`, guardar en `project-logs/`

2) Changelog
- Actualizar `CHANGELOG.md` con sección `## vX.Y.Z - {yyyy-mm-dd}`
- Resumir cambios por tipo: Added/Changed/Fixed/Security

3) Tag y empaquetado
- Crear tag `release/vX.Y.Z`
- Adjuntar artefactos de `project-logs/` al corte (si hay CI)

4) Smoke test
- Lista mínima de rutas/acciones críticas y resultado en `project-logs/release-vX.Y.Z.md`

5) Anuncio y handoff
- Resumen y links (PRs, docs) en `project-logs/release-vX.Y.Z.md`

## Aceptación
- `CHANGELOG.md` actualizado
- Tag `release/vX.Y.Z` creado
- `project-logs/release-vX.Y.Z.md` con checklist y resultado
- Prechecks (tsc/tests/depcheck/ts-prune) adjuntos en `project-logs/`

## Notas
- Si smoke test falla, revertir a snapshot con `/orchestrator-rollback`.
