# Atomic Deconstruction — Crisis de Talento IA (Aplicación)

- input_text: "Muchos devs expertos en aplicación de IA no encuentran trabajo y las empresas cada vez necesitan más"
- timestamp: 2025-09-10_234828
- moonshot_count_objetivo: 50+
- criterios: first_principles_score, disruption_potential, implementation_feasibility, garage_feasibility

## 1) Átomos del problema (First Principles)

- Demanda real vs headcount disponible
  - La demanda de IA existe, pero los puestos aprobados por finanzas/GC/seguridad son menos que la demanda latente.
- Asimetría de información
  - Empresas no tienen señal fiable de "aplicación de IA en producción"; devs no pueden demostrar impacto de forma estandarizada.
- Evaluación deficiente del talento aplicado
  - Procesos optimizados para CS genérico; no para shipping de sistemas LLM/RAG/evals/observabilidad.
- Riesgo/Compliance como cuello de botella
  - Datos sensibles, privacidad, auditoría de modelos, copyright: el freno está del lado legal/seguridad.
- Skills mismatch
  - Investigación vs aplicación; PoC vs producción; falta de LLMOps/MLOps/observabilidad/evaluaciones robustas.
- Fricción del funnel de hiring
  - CVs/ATS/entrevistas largas no predicen capacidad real de shipping aplicado.
- Timing y ciclos presupuestarios
  - Proyectos aparecen fuera del ciclo de headcount; freezes intermitentes.
- Geografía/husos horarios
  - Equipos distribuidos, pero requisitos de "on-site/overlap" reducen candidatos viables.
- Incentivos desalineados
  - Recruiters optimizan por cierre rápido; equipos por fit técnico-cultural-noise; candidatos por crecimiento.
- Job reqs mal especificados
  - Descripciones piden "SOTA + 10 años en todo"; poco enfoque en outcomes concretos.

## 2) Asunciones a eliminar

- "Necesitas título o X años exactos"
- "Hay que entrenar modelos desde cero" para aportar valor
- "Solo full-time, sin flexibilidad"
- "CV + entrevista blanca predicen performance"
- "On-site obligatorio" para trabajo de IA aplicada
- "POC = éxito" (sin métricas de negocio ni hardening)

## 3) Realidad física del sistema (constraints invariantes)

- Datos de negocio son la ventaja competitiva; acceso gobernado por seguridad/compliance.
- Valor proviene de integraciones robustas (ETL/RAG/func-calling/evals/observabilidad), no solo del modelo.
- Costes recurrentes (infra, inferencia, evals) impactan ROI; CFO necesita caso económico claro.
- Señales objetivas de habilidad aplicada son escasas si no se estandarizan (benchmarks de producto, SLAs, SLOs).

## 4) Hipótesis centrales

- Recurso realmente escaso: evidencia verificable de impacto en producción (evaluaciones, SLAs, ahorro/ingreso atribuible).
- Matching debe ocurrir a nivel de "loops de valor" (ingesta → orquestación → generación → herramientas → evals → monitoreo → feedback) y no a nivel de buzzwords.
- La evaluación debe ser con datos sintéticos/anonimizados + sandboxes auditables para demostrar capacidad sin riesgos legales.

## 5) Señales/Pruebas de capacidad aplicable

- Portafolios reproducibles: repos con pipelines + infra as code + suites de evals + métricas de negocio simuladas.
- Demos en sandboxes con datasets sintéticos que ejerciten: RAG robusto, grounding, tool-use, safety, observabilidad.
- Logs y traces (OpenTelemetry/LLMOps) demostrando confiabilidad y mejoras a través de iteraciones.

## 6) Métricas objetivo

- Time-to-hire < 72h con evidencia verificable.
- >80% de acierto en matching técnico (evaluado por panel técnico anónimo).
- PoC→Prod conversion > 60% en 30 días.
- Reducción de costo de evaluación en 10x.

## 7) Oportunidades de diseño (pre-moonshots)

- Estándares de portafolio aplicado + sandboxes seguros.
- Mercados de tareas/unidades de valor (micro-contratos con SLAs/evals).
- Evaluaciones automáticas de sistemas IA con scoring comparable entre candidatos.
- Rutas de talento basadas en "loops de valor" de IA y no en títulos.
