---
description: Abre una URL, captura los logs de la consola para depurar y pregunta los siguientes pasos.
---

### Paso 1: Obtener la URL
Pide al usuario la URL de la página que se necesita depurar.

### Paso 2: Abrir la página con Puppeteer
Usa `mcp8_puppeteer_navigate` para abrir la URL.

### Paso 3: Capturar los logs de la consola
Utiliza `mcp8_puppeteer_evaluate` con código JavaScript para obtener todos los mensajes, advertencias y errores de la consola del navegador.

### Paso 4: Analizar y preguntar
Presenta los logs capturados al usuario. Pregunta qué problema específico quiere resolver o qué acción quiere tomar basándose en esa información.

### Paso 5: Proceder con la depuración
Basado en la respuesta del usuario, inicia el proceso de depuración, que podría implicar:
-   Buscar el código fuente que genera el error.
-   Añadir más logs para un análisis más profundo.
-   Proponer una solución y aplicarla.
