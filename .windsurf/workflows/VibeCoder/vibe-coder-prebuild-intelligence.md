---
description: Pre‑build Intelligence + Intake for Vibe‑Coder — gates coding until market and strategy artifacts exist
---

## Objetivo
Asegurar que antes de programar se capture input del usuario, se haga research competitivo, ideación y selección de MVP para que la interfaz ya nazca con el product/market fit y diferenciadores correctos.

## Artefactos que deben existir para pasar a desarrollo
- brief/intake estructurado (`docs/{project_slug}/intake.md`)
- análisis competitivo (`docs/{project_slug}/competitive.md`)
- lista priorizada de features MVP con criterios y puntajes (`docs/{project_slug}/mvp_priorities.md`)
- estrategia de posicionamiento y UVP (`docs/{project_slug}/strategy.md`)

Si cualquiera de estos artefactos falta o está vacío, NO se puede iniciar desarrollo UI.

## Pasos

1) Intake del usuario (brief)
- Capturar: problema, público objetivo, trabajos por hacer (JTBD), contextos de uso, diferenciadores deseados, restricciones, éxito esperado.
- Formato de salida: `docs/{project_slug}/intake.md`.

// turbo
2) Crear carpeta base de documentos
- Comando sugerido (Windows): `mkdir docs\\{project_slug}`

3) Research de mercado automatizado (inspirado en `vibe-coder-intelligence.md`)
- Buscar: competidores directos/indirectos, pricing, features clave, reviews, gaps.
- Fuentes: webs oficiales, comparadores, foros/reviews, GitHub, marketplaces.
- Salida: `docs/{project_slug}/competitive.md` con tabla comparativa (features, pricing, fortalezas, debilidades, oportunidades).

4) Ideación de mejoras
- Generar 10+ ideas de innovación: features faltantes, mejoras UX/UI, integraciones, modelos de negocio.
- Añadir columna de hipótesis/beneficio usuario.
- Agregar a `docs/{project_slug}/competitive.md` sección "Ideation".

5) Selección de MVP features (scoring)
- Criterios: Impacto, Complejidad, Tiempo, Diferenciación (1–5 cada uno).
- Calcular puntaje total y ordenar.
- Salida: `docs/{project_slug}/mvp_priorities.md` con top 5–8 para V1.

6) Strategy doc (posicionamiento y UVP)
- Market positioning, UVP, diferenciadores clave, pricing tentativo, riesgos, métricas de éxito.
- Salida: `docs/{project_slug}/strategy.md`.

7) Gate de calidad antes de UI
- Verificar existencia y no vacíos de los 4 archivos.
- Si OK: continuar con arquitectura de interfaz y wireframes.
- Si NO: retroalimentar y volver a completar artefactos.

## Plantillas rápidas

### `intake.md`
```
# Intake — {project_name}

## Problema principal
- 

## Público objetivo (ICP)
- 

## Contextos de uso / JTBD
- 

## Diferenciadores deseados
- 

## Restricciones (técnicas, legales, plazos)
- 

## Éxito (KPIs, outcomes)
- 
```

### `competitive.md`
```
# Competitive Analysis — {project_name}

## Competidores
| Competidor | Segmento | Pricing | Features clave | Fortalezas | Debilidades |
|---|---|---|---|---|---|

## Oportunidades / Gaps
- 

## Ideation (10+ ideas)
| Idea | Beneficio | Diferenciación |
|---|---|---|
```

### `mvp_priorities.md`
```
# MVP Prioritization — {project_name}

Criterios: Impacto (I), Complejidad (C), Tiempo (T), Diferenciación (D). 1–5 cada uno.

| Feature | I | C | T | D | Total |
|---|---:|---:|---:|---:|---:|

Top V1:
- 
```

### `strategy.md`
```
# Strategy — {project_name}

## Positioning & UVP
- 

## Diferenciadores clave
- 

## Roadmap (V1 → V2)
- 

## Go‑to‑Market (canales, mensaje, pricing tentativo)
- 

## Riesgos y mitigación
- 

## Métricas de éxito
- 
```

## Nota sobre Notion (Regla Global)
Si decides llevar estos artefactos a Notion de forma automática, crea SIEMPRE una página raíz dinámica en cada ejecución (sin IDs codificados), capta el ID recién creado y anida las subpáginas ahí. Nunca dependas de IDs previos.
