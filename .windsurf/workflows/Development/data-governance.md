---
description: Canonical — Data Governance (schema, lineage, retention, privacy)
category: engineering
stability: stable
---

## Objetivo
Establecer gobierno de datos: esquemas, linaje, retención y privacidad por tenant/país.

## Entradas
- Políticas por región
- Esquemas y catálogos

## Preflight
// turbo
- Crear `project-logs/data-governance/`
- Checklist de privacidad

## Pasos
1) Esquemas versionados
2) Linaje y data contracts
3) Retención y borrado seguro
4) Accesos y auditoría

## Artefactos
- `project-logs/data-governance/policies.md`
- Diagramas y contratos

## Aceptación
- Auditoría básica sin hallazgos críticos
- Trazabilidad de datasets clave

## Guardrails
- PII minimization
- Accesos mínimos necesarios

## Troubleshooting
- Incidentes: playbooks y reportes
- Desalineo de esquema: migraciones
