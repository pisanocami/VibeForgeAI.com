---
description: Añade un nuevo endpoint a la API del backend.
---

### Paso 1: Recopilar información del endpoint
Pide al usuario la siguiente información:
- La ruta del endpoint (ej. `/api/users`).
- El método HTTP (GET, POST, PUT, DELETE, etc.).
- El archivo de rutas donde se debe añadir (ej. `server/routes/ai.ts`).

### Paso 2: Leer el archivo de rutas
Lee el contenido del archivo de rutas especificado para entender cómo están estructurados los endpoints existentes.

### Paso 3: Generar el código del nuevo endpoint
Crea un bloque de código para el nuevo endpoint usando la sintaxis del router que se esté utilizando (Hono).

### Paso 4: Añadir el endpoint al archivo
Usa una herramienta de edición de código para insertar el nuevo bloque de código en el archivo de rutas, preferiblemente cerca de otros endpoints relacionados.

### Paso 5: Confirmar la creación
Informa al usuario que el endpoint ha sido añadido y muéstrale la ubicación del nuevo código.
