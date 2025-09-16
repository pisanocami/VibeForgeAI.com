---
description: Analiza los endpoints de una API usando herramientas de línea de comandos.
---

### Paso 1: Obtener la URL base
Pide al usuario la URL base de la API que desea analizar (ej: http://localhost:3001/api).

### Paso 2: Escanear endpoints comunes
Usa `run_command` con `httpie` o `curl` para probar endpoints comunes:
```bash
http GET {url}/healthz
http GET {url}/api/status
http GET {url}/api/version
```

### Paso 3: Analizar archivos de rutas
Busca archivos de configuración de rutas en el proyecto:
- `**/routes/*.ts`
- `**/api/**/*.ts`
- `**/controllers/*.ts`

### Paso 4: Extraer patrones de rutas
De los archivos encontrados, extrae patrones de rutas y sus métodos HTTP.

### Paso 5: Probar endpoints
Para cada endpoint encontrado, realiza una petición de prueba y documenta la respuesta.

### Paso 6: Generar documentación
Crea un archivo `API_DOCS.md` con la documentación de los endpoints encontrados.

### Herramientas recomendadas:
- `httpie`: Para probar endpoints
- `jq`: Para parsear respuestas JSON
- `rg` (ripgrep): Para buscar patrones en el código
