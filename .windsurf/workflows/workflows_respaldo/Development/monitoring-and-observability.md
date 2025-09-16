---
description: Canonical — Monitoring & Observability (SLOs, tracing, dashboards)
category: engineering
stability: stable
---

## Objetivo
Instrumentar métricas, logs y traces con SLOs y dashboards de producto.

## Entradas
- Servicios y endpoints clave
- Metas de SLO

## Preflight
// turbo
- Crear `project-logs/observability/`
- Configurar exportadores y OTEL

## Pasos
1) Métricas por servicio
2) Tracing distribuido
3) Dashboards y alertas (SLO)
4) Postmortems y runbooks

## Artefactos
- `project-logs/observability/dashboards.md`
- Alertas exportadas

## Aceptación
- SLOs vigilados y alertas activas
- Trazas en rutas críticas

## Guardrails
- Privacidad en logs
- Cotas de costo en storage

## Troubleshooting
- Ruido: ajustar severidades
- Faltan trazas: instrumentación
