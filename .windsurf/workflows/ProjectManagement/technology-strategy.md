---
description: Strategy — Technology Strategy (world‑class architecture, stack, quality, security, scalability)
category: strategy
stability: stable
---

## Objetivo
Diseñar la mejor estrategia tecnológica posible para cualquier idea: principios, arquitectura de referencia, decisiones de stack, calidad, seguridad, escalabilidad, observabilidad y costos, con entregables accionables.

## Entradas
- Input libre del producto/idea y requerimientos (SLAs, compliance, data)
- Timebox (opcional) y restricciones técnicas/financieras

## Preflight
// turbo
- Crear `project-logs/tech/`
- Guardar `project-logs/tech/intake-{timestamp}.md` (resumen técnico del input)

## Paso 1 — Principios y metas técnicas
- Principios: privacidad-by-design, multi-tenant seguro, modularidad, DX/UX excelentes, testabilidad, costo/valor
- Metas: SLOs (latencia/uptime), TTFV, portabilidad cloud, accesibilidad AA en frontend
- Artefacto: `project-logs/tech/principles-{timestamp}.md`

## Paso 2 — Arquitectura de referencia (blueprint)
- Capas: Ingesta/ELT, almacenamiento (OLTP+OLAP+cache+search), servicios (domain services), APIs (GraphQL/REST), clientes (web/mobile), jobs/ML
- Patrón: microservicios pragmáticos con contratos claros, colas/eventos para acoplamiento débil
- Datos: contratos de datos, linaje, retención, RLS si aplica
- Artefacto: `project-logs/tech/architecture-{timestamp}.md`

## Paso 3 — Decisiones de stack (razonadas)
- Backend: Node/TypeScript, frameworks HTTP (Hono/Express), ORM (Prisma), colas (SQS/Kafka)
- Data: Postgres (OLTP), ClickHouse (OLAP), Redis (cache), Elasticsearch (search)
- Frontend: React/Next.js + Tailwind/shadcn; WebSocket para realtime
- ML: Python/TypeScript con MLflow/Weights & Biases, feature store básico
- Infra: AWS/GCP, Kubernetes, Terraform, GitHub Actions
- Artefacto: `project-logs/tech/stack-decisions-{timestamp}.md`

## Paso 4 — Calidad y pipelines (CI/CD + gates)
- Lint/types/tests/coverage, build reproducible, canary y rollback
- Control de artefactos: test logs, coverage, bundles, SBOM
- Artefacto: `project-logs/tech/quality-gates-{timestamp}.md`

## Paso 5 — Seguridad y privacidad
- AuthN/AuthZ, RLS, secretos, cifrado en tránsito/descanso, CSP/headers
- Amenazas y mitigaciones (OWASP Top 10), DLP mínima, PII minimization
- Artefacto: `project-logs/tech/security-{timestamp}.md`

## Paso 6 — Escalabilidad y resiliencia
- Auto‑scaling, particionado/sharding cuando aplique, backpressure
- DR/BCP: RPO/RTO, backups y pruebas de restauración
- Artefacto: `project-logs/tech/scalability-resilience-{timestamp}.md`

## Paso 7 — Observabilidad y costos
- Métricas, logs, tracing con OpenTelemetry + paneles (DataDog/New Relic)
- Budgets/alerts, rightsizing, costos por servicio/tenant
- Artefactos: `project-logs/tech/observability-{timestamp}.md`, `project-logs/tech/costs-{timestamp}.md`

## Paso 8 — Roadmap técnico
- Fases: M0 fundaciones → M1 MVP → M2 escalado/IA → M3 optimización de costos
- Dependencias y riesgos técnicos
- Artefacto: `project-logs/tech/roadmap-{timestamp}.md`

## Aceptación
- Blueprint arquitectónico y stack justificado
- Gates de calidad definidos y pipeline descrito
- Plan de seguridad/privacidad, observabilidad y costos documentados

## Guardrails
- No sobre‑ingenierizar: empezar simple, medir, iterar
- Preferir estándares abiertos y componentes con comunidad fuerte
- Diseñar para reversibilidad y feature flags
