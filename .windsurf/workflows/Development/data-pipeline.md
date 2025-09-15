---
description: Canonical — Data Pipeline (connectors, schema, quality)
category: engineering
stability: stable
---

## Objetivo
Construir el framework de conectores y el pipeline ELT con esquema estándar y controles de calidad.

## Entradas
- Plataformas objetivo (top 10)
- Credenciales por entorno

## Preflight
// turbo
- Crear `project-logs/data-pipeline/`
- Validar límites de rate y cuotas

## Pasos
1) Marco de conectores
- SDK base (auth, retry, rate-limit)
- Paginación e incremental

2) Normalización
- Mapeo a esquema FON (facts/dims)
- Upsert idempotente

3) Calidad de datos
- Validaciones (nulls, ranges)
- Anomalías y linaje

## Artefactos
- `project-logs/data-pipeline/spec.md`
- `shared/schema/*.sql|ts`
- Registros de carga y métricas

## Aceptación
- 3 conectores productivos
- Cargas diarias sin errores críticos
- Esquema documentado y versionado

## Guardrails
- Backoff exponencial y circuit breaker
- Respeto de TOS y privacidad

## Troubleshooting
- 429/quotas: programar backfills
- Desalineo de esquema: versionar migraciones
