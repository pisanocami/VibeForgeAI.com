---
description: Refactoriza un componente existente para mejorar su estructura, rendimiento y mantenibilidad.
---

### Paso 1: Identificar el componente
Pide al usuario la ruta del componente que necesita ser refactorizado.

### Paso 2: Analizar el componente actual
Lee el archivo y analiza:
- Complejidad del componente (líneas de código, responsabilidades)
- Props y su tipado
- Estado interno y efectos
- Dependencias y imports
- Patrones de renderizado

### Paso 3: Identificar problemas
Detecta problemas comunes:
- Componente demasiado grande (>200 líneas)
- Múltiples responsabilidades
- Props drilling
- Re-renders innecesarios
- Lógica compleja en el JSX
- Falta de memoización

### Paso 4: Proponer estrategia de refactoring
Sugiere mejoras específicas:
- Dividir en componentes más pequeños
- Extraer custom hooks
- Implementar React.memo o useMemo
- Optimizar estructura de props
- Mejorar nombres y organización

### Paso 5: Implementar refactoring
Con aprobación del usuario:
- Crear componentes hijos si es necesario
- Extraer lógica a custom hooks
- Aplicar optimizaciones de performance
- Actualizar tipos TypeScript
- Mantener funcionalidad existente

### Paso 6: Validar cambios
- Verificar que no se rompió funcionalidad
- Comprobar que las props siguen funcionando
- Sugerir pruebas para el componente refactorizado
