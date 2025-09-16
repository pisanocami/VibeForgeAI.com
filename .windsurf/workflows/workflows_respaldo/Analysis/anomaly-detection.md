---
description: Canonical — Anomaly Detection (rules, z-scores, alerts)
category: analytics
stability: stable
---

## Objetivo
Detectar anomalías en métricas clave (spend, clicks, CVR, CPA) y generar alertas con contexto.

## Entradas
- Métricas por canal/campaña
- Ventanas de referencia

## Preflight
// turbo
- Crear `project-logs/analytics/anomalies/`
- Definir thresholds y exclusiones

## Pasos
1) Reglas estadísticas
- Z-scores, IQR, STL

2) Agregaciones jerárquicas
- Por canal → campaña → adset → creative

3) Alertas
- Integración con observabilidad/notificaciones

## Artefactos
- `project-logs/analytics/anomalies/report.md`
- Registros de alertas

## Aceptación
- Tasa de falsos positivos aceptable
- Cobertura de métricas críticas

## Guardrails
- Horarios de silencio y deduplicación
- No alertar sin contexto/impacto

## Troubleshooting
- Ruido alto: suavizado y ventanas móviles
- Estacionalidad: descomposición STL
