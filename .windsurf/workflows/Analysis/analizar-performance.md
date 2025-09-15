---
description: Analiza el rendimiento de una página y sugiere optimizaciones.
---

### Paso 1: Obtener la URL
Pide al usuario la URL de la página que necesita ser analizada.

### Paso 2: Abrir la página con Puppeteer
Usa `mcp8_puppeteer_navigate` para abrir la URL.

### Paso 3: Realizar el análisis de rendimiento
Utiliza `mcp8_puppeteer_evaluate` para ejecutar scripts que recopilen métricas clave de rendimiento:
-   First Contentful Paint (FCP)
-   Largest Contentful Paint (LCP)
-   Time to Interactive (TTI)
-   Tamaño total de la página y de los assets (imágenes, JS, CSS)
-   Tiempo de carga de recursos usando `performance.getEntriesByType('resource')`

### Paso 4: Identificar cuellos de botella
Analiza los resultados para encontrar los principales problemas de rendimiento. Esto podría incluir:
-   Imágenes sin optimizar.
-   Bloques de JavaScript que tardan en ejecutarse.
-   CSS que bloquea el renderizado.
-   Falta de carga diferida (lazy loading) para imágenes o componentes.

### Paso 5: Proponer soluciones
Basado en el análisis, proporciona un informe claro con los problemas encontrados y sugiere soluciones concretas y accionables, como:
-   Comprimir imágenes usando una herramienta.
-   Dividir el código (code splitting) con `React.lazy()`.
-   Optimizar el CSS crítico.
-   Aplicar `loading="lazy"` a las imágenes.
