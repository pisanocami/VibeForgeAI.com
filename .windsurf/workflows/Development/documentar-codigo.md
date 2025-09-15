---
description: Canonical — Documentar Código (JSDoc/TSDoc)
category: engineering
stability: stable
---

> This is the CANONICAL version of `documentar-codigo`. The legacy file remains in `.windsurf/workflows/documentar-codigo.md` with a pointer here.

---

<!-- Begin canonical content (copied from .windsurf/workflows/documentar-codigo.md) -->
---
description: Genera documentación para funciones o componentes existentes.
---

### Paso 1: Obtener el archivo a documentar
Pide al usuario la ruta del archivo que contiene el código que necesita ser documentado.

### Paso 2: Analizar el código fuente
Lee el archivo e identifica las funciones, clases y componentes que no tienen comentarios de documentación (JSDoc/TSDoc).

### Paso 3: Generar la documentación
Para cada elemento sin documentación, genera un bloque de comentarios que explique:
-   El propósito general del elemento.
-   Una descripción para cada parámetro (`@param`).
-   Lo que retorna la función (`@returns`).

### Paso 4: Aplicar la documentación al archivo
Utiliza una herramienta de edición de código para insertar los bloques de documentación generados justo encima de las declaraciones correspondientes en el archivo original.

### Paso 5: Revisión final
Muestra al usuario los cambios realizados y confirma que la documentación es correcta y clara.
<!-- End canonical content -->