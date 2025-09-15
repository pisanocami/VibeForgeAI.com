---
description: Canonical — Insight Narratives (LLM + templates)
category: analytics
stability: beta
---

## Objetivo
Generar narrativas claras en lenguaje natural a partir de métricas y predicciones.

## Entradas
- Resúmenes de performance y tendencias
- Recomendaciones priorizadas

## Preflight
// turbo
- Crear `project-logs/analytics/narratives/`
- Definir templates y slots

## Pasos
1) Plantillas por vertical
2) Contexto estructurado (JSON)
3) LLM con guardrails y post-procesado
4) Export a portal/reportes

## Artefactos
- `project-logs/analytics/narratives/examples.md`
- Templates versionadas

## Aceptación
- Coherencia factual (spot checks)
- Tono/estilo por marca/tenant

## Guardrails
- No incluir PII en prompts
- Validación factual y límites de longitud

## Troubleshooting
- Alucinaciones: grounding y penalizaciones
- Variación de estilo: ajustar templates
