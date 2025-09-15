---
description: Abre una URL en el Windsurf Browser, analiza su contenido y estructura, y propone mejoras de código.
---

### Paso 1: Obtener la URL
Pide al usuario la URL de la página que necesita ser mejorada.

### Paso 2: Abrir la página con Puppeteer
Usa `mcp8_puppeteer_navigate` para abrir la URL proporcionada por el usuario.

### Paso 3: Analizar el contenido de la página
Utiliza `mcp8_puppeteer_screenshot` para capturar una imagen de la página y `mcp8_puppeteer_evaluate` para extraer información del DOM y analizar la estructura HTML.

### Paso 4: Identificar áreas de mejora
Analiza el código y la estructura en busca de posibles mejoras. Esto puede incluir:
-   Refactorización de componentes.
-   Optimización de la performance.
-   Mejoras de accesibilidad (A11y).
-   Actualización de estilos para que coincidan con la identidad de marca (por ejemplo, los colores de Force of Nature).

### Paso 5: Proponer y aplicar cambios
Basado en el análisis, busca los archivos de código fuente relevantes en el proyecto. Propón los cambios de código necesarios al usuario y, con su aprobación, aplícalos usando las herramientas de edición de código.
