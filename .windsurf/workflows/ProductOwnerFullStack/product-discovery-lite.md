---
description: Product Discovery Ligero para convertir oportunidades en hipótesis validadas rápidamente
---

# /product-discovery-lite

## Objetivo
Convertir una oportunidad en una hipótesis validada y lista para delivery (problema → persona → valor → métrica).

## Entradas
- oportunidad (breve descripción)
- persona objetivo (quién/segmento)
- contexto/mercado (links, referencias)

## Pasos
1) Captura de contexto (Second Brain)
- Añade 3+ referencias en `knowledge/references.md` (competencia, benchmarks, feedback)
- Registra supuestos clave en `knowledge/decisions.md`

2) Definición de hipótesis y valor
- Define problema, Jobs-to-be-Done (JTBD) y valor esperado
- Redacta 3 user stories (formato: Como <rol> quiero <objetivo> para <beneficio>)

3) Riesgos y alternativas
- Lista riesgos top-3 (técnicos, legales, UX) y mitigaciones
- Alternativas consideradas (trade-offs)

4) Métricas de éxito y señal mínima
- Define 2–3 KPIs (ej.: activación, tiempo a valor, tasa de uso)
- Define señal mínima válida (SMV) para go/no-go

5) Artefacto PRD breve
- Crea `docs/prd/{feature}.md` con: problema, historias, KPIs, riesgos, alcance v1

## Aceptación
- `docs/prd/{feature}.md` creado con todos los apartados
- 3+ referencias en `knowledge/references.md`
- Decisión go/no-go registrada en `knowledge/decisions.md`

## Notas
- Mantén el PRD < 1 página; lo importante es decidir rápido con evidencias.
