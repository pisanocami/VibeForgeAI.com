---
description: Canonical — Predictive Analytics Suite (churn, LTV, market trends)
category: analytics
stability: beta
---

## Objetivo
Entregar un set de analítica predictiva (churn, LTV, tendencias, competitividad).

## Entradas
- Datos de clientes, cohortes, ventas
- Señales de mercado

## Preflight
// turbo
- Crear `project-logs/analytics/predictive/`
- Definir esquemas y ventanas

## Pasos
1) Churn y LTV
2) Tendencias de mercado
3) Gaps competitivos
4) Orquestación de insights

## Artefactos
- `project-logs/analytics/predictive/report.md`
- Dashboards de resultados

## Aceptación
- KPIs de precisión dentro de meta
- Insights accionables por vertical

## Guardrails
- Privacidad y compliance por región
- No mezclar tenants

## Troubleshooting
- Data leakage: validación temporal
- Escasez de etiquetas: weak supervision
