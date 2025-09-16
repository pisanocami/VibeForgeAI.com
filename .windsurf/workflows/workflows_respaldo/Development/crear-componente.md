---
description: Canonical — Crear Componente React (plantilla básica)
category: engineering
stability: stable
---

> This is the CANONICAL version of `crear-componente`. The legacy file remains in `.windsurf/workflows/crear-componente.md` with a pointer here.

---

<!-- Begin canonical content (copied from .windsurf/workflows/crear-componente.md) -->
---
description: Crea un nuevo componente de React con una plantilla básica.
---

### Paso 1: Obtener detalles del componente
Pide al usuario el nombre del componente (ej. `MiBoton`) y la ruta donde debe ser creado (ej. `client/src/components/ui`).

### Paso 2: Crear el archivo del componente
Usa la herramienta `write_to_file` para crear el archivo `.tsx` en la ruta especificada. Incluye una plantilla básica de un componente funcional de React.

### Ejemplo de plantilla:
```tsx
import React from 'react';

interface [ComponentName]Props {
  // Define tus props aquí
}

const [ComponentName]: React.FC<[ComponentName]Props> = ({}) => {
  return (
    <div>
      {/* Contenido de tu componente */
      <h1>[ComponentName]</h1>
    </div>
  );
};

export default [ComponentName];
```

### Paso 3: (Opcional) Crear archivos adicionales
Pregunta al usuario si también desea crear un archivo de estilos (`.css`) o un archivo de pruebas (`.test.tsx`) para el componente. Si la respuesta es afirmativa, créalos con contenido básico.
<!-- End canonical content -->