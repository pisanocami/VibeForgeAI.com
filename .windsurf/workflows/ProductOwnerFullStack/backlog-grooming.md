---
description: Backlog Grooming & Story Mapping para convertir PRD en épicas e historias listas para delivery
---

# /backlog-grooming

## Objetivo
Transformar un PRD breve en épicas e historias con criterios de aceptación claros, estimaciones y dependencias.

## Entradas
- `docs/prd/{feature}.md`
- Timebox y capacity del sprint

## Pasos
1) Extraer épicas e historias
- Derivar épicas a partir de outcomes del PRD
- Redactar historias (Como <rol> quiero <objetivo> para <beneficio>) con DoD

2) Criterios de aceptación y riesgos
- Definir criterios medibles por historia
- Anotar riesgos y supuestos (enlace a `knowledge/decisions.md`)

3) Estimación y priorización
- Estimar esfuerzo (S/M/L o puntos)
- Priorizar por valor vs esfuerzo y dependencias

4) Plan de sprint
- Seleccionar historias que entren en el timebox
- Añadir checkpoints (lint, tsc, tests, perf)

5) Persistencia del plan
- Crear/actualizar `project-logs/plan-{yyyy-mm-dd}.md` con:
  - Resumen del objetivo
  - Épicas e historias con aceptación
  - Dependencias y riesgos
  - Checklist de validación

## Aceptación
- `project-logs/plan-{yyyy-mm-dd}.md` actualizado con épicas, historias y aceptación
- Historias priorizadas y estimadas
- Riesgos y dependencias registrados

## Notas
- Mantén historias pequeñas y shippables. Evita épicas disfrazadas de historias.
