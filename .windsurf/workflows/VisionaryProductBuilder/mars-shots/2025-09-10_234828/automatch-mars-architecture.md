# AutoMatch — Mars Architecture

## AI‑First Architecture
- Ingesta: Git/CI/Observabilidad (opt‑in, privacidad)
- Feature pipeline: métricas de calidad, latencia, costo, incidentes
- Modelo de matching: ranking multi‑objetivo (skill fit, reliability, cost‑awareness)
- API y UI: recomendaciones, explicabilidad, consent management
- Observabilidad: trazas y auditoría de decisiones

## Escalabilidad
Serverless + colas + storage barato; partitioning por empresa/tenant.

## Moats
Telemetría propietaria + feedback loops performance→matching.
