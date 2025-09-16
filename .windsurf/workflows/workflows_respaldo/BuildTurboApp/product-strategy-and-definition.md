---
description: Canonical — Product Strategy & Definition (from free-form input to PRD, MVP, roadmap, metrics)
category: po-fullstack
stability: stable
---

# /product-strategy — Product Strategy & Definition

Convierte un input libre (ideas, objetivos, notas, briefs) en una definición de producto impecable y ejecutable: visión, problema/mercado, diferenciadores, PRD, MVP, roadmap, pricing y métricas.

## Objetivo
Definir el producto más exitoso, innovador y perfecto para su mercado/segmento, maximizando impacto de negocio, viabilidad técnica y velocidad a PMF.

## Entradas
- Input libre (texto/links): visión, metas, usuarios, contexto
- Timebox deseado (ej.: 2h/1d/1w)
- Target de mercado/segmento (si se conoce)

## Variables y convenciones
- `project_name`: Nombre legible del proyecto (ej.: "Acme Insights")
- `project_slug`: Slug de proyecto en kebab-case (ej.: `acme-insights`)
- `timestamp`: Marca temporal `yyyy-mm-dd_hhmm` para versionado de artefactos
- `quarter`: Formato `YYYY-QN` (ej.: `2025-Q1`)

Convenciones de salida:
- Directorio raíz de documentación por proyecto: `docs/{project_slug}/product/`
- Subcarpetas temáticas: `brand/`, `discovery/`, `personas/`, `competition/`, `market/`, `ai/`, `value-prop/`, `prd/`, `roadmap/`, `metrics/`, `pricing/`, `gtm/`, `risks/`, `plan/`, `stack/`
- Nombrado de archivos: `{topic}/{artifact}-{timestamp}.md` o `{topic}/{artifact}-{quarter}.md`

## Preflight
// turbo
- Crear directorio base del proyecto: `docs/{project_slug}/` con subcarpetas mínimas:
  - `product/`, `orchestrator/logs/`, `status/`
- Crear estructura base `docs/{project_slug}/product/` con subcarpetas:
  - `brand/`, `discovery/`, `personas/`, `competition/`, `market/`, `ai/`, `value-prop/`, `prd/`, `roadmap/`, `metrics/`, `pricing/`, `gtm/`, `risks/`, `plan/`, `stack/`
- Guardar `docs/{project_slug}/product/discovery/intake-{timestamp}.md` con el input original

## Paso 0 — Brand & Vision (Identidad y dirección)
- Definir esencia de marca: propósito, valores, tono y principios de diseño
- Declarar visión (3–5 años) y misión (qué hacemos hoy para acercarnos)
- Aterrizar pilares de marca en promesas de producto (UX, soporte, performance, confianza)
- Artefactos:
  - `docs/{project_slug}/product/brand/brand-vision-{timestamp}.md`
  - `docs/{project_slug}/product/brand/brand-tokens-{timestamp}.md` (si ya hay tokens/temas)

## Paso 1 — Destilación del input (Contexto → Hipótesis)
- Resumir en 10–12 bullets: objetivos, dolor, usuarios, restricciones
- Formular hipótesis clave (problema/solución/impacto)
- Artefacto: `docs/{project_slug}/product/discovery/context-{timestamp}.md`

## Paso 2 — Cliente/mercado (Personas & JTBD)
- Definir 2–3 personas arquetipo y sus Jobs-To-Be-Done
- Mapear escenarios críticos y criterios de éxito
- Artefacto: `docs/{project_slug}/product/personas/personas-jtbd-{timestamp}.md`

## Paso 3 — Competencia y diferenciación
- Identificar 5+ competidores/alternativas (incluye DIY/No‑hacer)
- Análisis profundo:
  - Comparativa de propuestas de valor, pricing, segmentos
  - Moats: datos, ecosistema, distribución, switching costs, regulación
  - TAM/SAM/SOM por vertical/país, barreras de entrada
  - Riesgos de sustitución y lock-in de incumbentes
- Tabla de features vs. valor. Extraer 3–5 diferenciadores únicos (defensables)
- Artefactos:
  - `docs/{project_slug}/product/competition/competitive-{timestamp}.md`
  - `docs/{project_slug}/product/market/market-sizing-{timestamp}.md`

## Paso 3b — Estrategia de IA (Aplicación y roadmap)
- Casos de uso IA por etapa del ciclo de valor (ingestión → análisis → decisión → acción → aprendizaje)
- Enfoque de grounding y gobernanza: datos, evaluación, privacidad, explicabilidad
- Build vs. buy para componentes (LLM, vectores, feature store, evaluación)
- Roadmap IA: V0 (heurísticas + reglas) → V1 (ML supervisado) → V2 (RL/online learning)
- Guardrails: no decisiones 100% automáticas en fase inicial; circuit breakers; canary
- Artefacto: `docs/{project_slug}/product/ai/ai-strategy-{timestamp}.md`

## Paso 4 — Propuesta de valor y narrativa
- Propuesta de valor en 1 frase y 3 bullets de soporte
- Storytelling de antes/después y outcomes
- Artefacto: `docs/{project_slug}/product/value-prop/value-prop-{timestamp}.md`

## Paso 5 — Diseño del producto (Solución → PRD)
- Arquitectura funcional (módulos, flujos, permisos)
- Requisitos (funcionales, no funcionales, data, privacidad)
- Criterios de aceptación por epic
- Artefacto: `docs/{project_slug}/product/prd/prd-{timestamp}.md`

## Paso 5b — Stack técnico recomendado (DX y plataforma)
- Adoptar por defecto:
  - Frontend: React 18 + Vite (DX rápida), React Router v7, Tailwind CSS + shadcn/ui
  - Backend/API: Node/TypeScript (a definir) con preferencias por rendimiento y DX
  - Base de datos: PostgreSQL (Neon o local) via Drizzle ORM
  - AI: Google Gemini (principal) y opcional OpenAI si está configurado
- Decisiones de arquitectura y justificación (trade-offs, performance, seguridad)
- Artefacto: `docs/{project_slug}/product/stack/stack-{timestamp}.md`

## Paso 6 — MVP y versiónes (V0 → V1 → V2)
- Definir MVP (alcance mínimo lovable), métricas de éxito y riesgos
- V1/V2 con incrementos claros y gates de calidad
- Artefacto: `docs/{project_slug}/product/roadmap/mvp-roadmap-{timestamp}.md`

## Paso 7 — Roadmap y priorización
- Backlog por epics → historias → milestones
- Priorización (RICE/Value vs Effort) y dependencias
- Artefacto: `docs/{project_slug}/product/roadmap/roadmap-{quarter}.md`

## Paso 8 — Métricas y North Star
- Elegir North Star Metric y 4–6 input metrics
- Definir instrumentación (eventos, funnels, cohortes)
- Artefacto: `docs/{project_slug}/product/metrics/metrics-{timestamp}.md`

## Paso 9 — Pricing & Packaging (si aplica)
- Segmentos/tiers, valor vs coste, anclaje competitivo
- Estrategia de pruebas (free/trial/usage‑based)
- Artefacto: `docs/{project_slug}/product/pricing/pricing-{timestamp}.md`

## Paso 10 — Go-To-Market y Experimentos
- ICP, canales, mensajes y assets mínimos
- Plan de experimentación (A/B, smoke tests, waits‑list)
- Artefacto: `docs/{project_slug}/product/gtm/gtm-{timestamp}.md`

## Paso 11 — Riesgos y validación
- Riesgos (técnicos, legales, mercado) + mitigaciones
- Plan de validación: entrevistas, prototipos, concierge, beta
- Artefacto: `docs/{project_slug}/product/risks/risks-validation-{timestamp}.md`

## Paso 12 — Hand‑off a ejecución
- Crear plan de sprint inicial con `/orchestrator/brain.md` y `/orchestrator/roadmap-execution.md`
- Enlazar workflows técnicos: `engineering/*`, `ai/*`, `analytics/*`, `ux-ui/*`, `latam/*`
- Artefacto: `docs/{project_slug}/product/plan/plan-{yyyy-mm-dd}.md`

## Publicación final en Notion (OBLIGATORIO, cumpliendo Regla 1)
- Usar el workflow `/create-dynamic-root` para crear SIEMPRE una nueva página raíz en cada ejecución y obtener su ID dinámicamente (nunca IDs codificados ni previos).
- Publicar como subpáginas, al menos, estos artefactos: `discovery/intake-*`, `brand/brand-vision-*`, `prd/prd-*`, `roadmap/roadmap-*`, `metrics/metrics-*`, `stack/stack-*`.
- Registrar las URLs resultantes en el índice del proyecto y referenciarlas desde los `.md` locales.

## Aceptación
- PRD completo con criterios de aceptación por epic
- MVP definido con métricas de éxito y riesgos
- Roadmap y métricas North Star documentados
- Artefactos creados en `docs/{project_slug}/product/`

## Guardrails
- Validar privacidad y compliance (si hay datos sensibles)
- Evitar scope creep: mantener MVP lovable y medible
- Diseñar para multi-tenant y escalabilidad desde V1 si aplica

## Quality Gates recomendados
- Integrar `/ci-quality-gates` para validar tipos, tests, dependencias y artefactos antes de cerrar cada fase clave (PRD, MVP, Roadmap).
- Usar `/release-cut` para cortes de versión reproducibles de la documentación del producto.

## Templates recomendados
- PRD: Epics → Historias → Aceptación → Dependencias → Métricas → Riesgos
- Lean Canvas: Problema, Segmentos, Propuesta, Solución, Canales, Ingresos, Costes, Métricas, Ventaja
- Métricas: North Star + input metrics + plan de instrumentación

## Integraciones con otros workflows
- Orchestrator: `orchestrator/brain.md`, `orchestrator/roadmap-execution.md`
- Engineering: `engineering/design-and-styling.md`, `engineering/analytics-engine.md`, `engineering/data-pipeline.md`
- UX/UI: `ux-ui/mejorar-ux-ui.md`, `ux-ui/client-portal.md`, `ux-ui/white-label-branding.md`
- AI/Analytics: `ai/attribution-engine.md`, `ai/performance-prediction.md`, `analytics/predictive-analytics-suite.md`
