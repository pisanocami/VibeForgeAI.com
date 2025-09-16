---
description: Abre una URL en el Windsurf Browser, analiza su contenido y estructura, y propone mejoras de código.
---

### Paso 1: Obtener la URL
Pide al usuario la URL de la página que necesita ser analizada completamente.

### Paso 2: Navegación y captura inicial
Usa `mcp8_puppeteer_navigate` para abrir la URL y `mcp8_puppeteer_screenshot` para capturar el estado inicial.

### Paso 3: Análisis técnico completo
Ejecuta múltiples análisis usando `mcp8_puppeteer_evaluate`:
- **Performance**: Métricas de Web Vitals (LCP, FID, CLS)
- **SEO**: Meta tags, estructura de headings, alt texts
- **Accesibilidad**: Contraste de colores, ARIA labels, navegación por teclado
- **Seguridad**: Headers de seguridad, enlaces externos
- **Estructura**: Análisis del DOM, componentes detectados

### Paso 4: Análisis de código fuente
Busca archivos relacionados en el proyecto:
- Componentes React correspondientes
- Estilos CSS/Tailwind
- Archivos de configuración
- APIs utilizadas

### Paso 5: Generar reporte completo
Crea un informe detallado con:
- Screenshot de la página
- Puntuación en cada categoría (1-10)
- Lista priorizada de problemas encontrados
- Recomendaciones específicas con código de ejemplo
- Plan de implementación paso a paso

### Paso 6: Implementar mejoras
Con aprobación del usuario, aplicar las mejoras más críticas:
- Optimizaciones de performance
- Correcciones de accesibilidad
- Mejoras de SEO
- Refactorización de código
