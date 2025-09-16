---
description: Genera pruebas unitarias o de integración para una función o componente.
---

### Paso 1: Identificar el objetivo de la prueba
Pide al usuario la ruta del archivo y el nombre de la función o componente que se va a probar.

### Paso 2: Analizar el código fuente
Lee el archivo proporcionado y analiza la lógica de la función o componente seleccionado. Identifica sus props, su estado, los hooks que utiliza y lo que retorna.

### Paso 3: Generar el archivo de prueba
Crea un nuevo archivo de prueba (ej. `[nombre].test.tsx`) en la misma carpeta o en una carpeta `__tests__`. Utiliza la sintaxis de `vitest` para escribir los casos de prueba.

### Paso 4: Escribir casos de prueba básicos
Genera pruebas para los escenarios más comunes:
-   Renderizado inicial del componente sin errores.
-   Verificación de que las props se renderizan correctamente.
-   Simulación de eventos de usuario (clics, escritura) y comprobación del resultado esperado.

### Paso 5: Sugerir casos de prueba adicionales
Propón al usuario casos de prueba más complejos o para situaciones límite (edge cases) que podrían ser relevantes, como props inválidas, respuestas de API fallidas, etc.
