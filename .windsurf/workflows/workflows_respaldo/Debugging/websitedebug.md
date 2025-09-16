---
description: Abre una URL, captura los logs de la consola para depurar y pregunta los siguientes pasos.
---

### Paso 1: Obtener la URL
Pide al usuario la URL de la página que se necesita depurar.

### Paso 2: Navegar con Puppeteer
Usa `mcp8_puppeteer_navigate` para abrir la URL especificada.

### Paso 3: Capturar screenshot
Utiliza `mcp8_puppeteer_screenshot` para tomar una captura de pantalla de la página actual.

### Paso 4: Extraer logs de consola
Usa `mcp8_puppeteer_evaluate` para ejecutar JavaScript que capture todos los mensajes de consola:
```javascript
console.log(JSON.stringify({
  errors: window.__errors || [],
  warnings: window.__warnings || [],
  logs: window.__logs || []
}));
```

### Paso 5: Analizar elementos de la página
Utiliza `mcp8_puppeteer_evaluate` para extraer información del DOM y detectar posibles problemas.

### Paso 6: Presentar análisis y preguntar
Muestra al usuario:
- Screenshot de la página
- Logs de consola encontrados
- Posibles problemas detectados
- Pregunta qué acción específica quiere tomar

### Paso 7: Ejecutar acciones de depuración
Basado en la respuesta del usuario, usar herramientas como:
- `mcp8_puppeteer_click` para interactuar con elementos
- `mcp8_puppeteer_fill` para llenar formularios
- `mcp8_puppeteer_evaluate` para ejecutar código de depuración
