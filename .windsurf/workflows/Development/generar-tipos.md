---
description: Canonical — Generación y Organización de Tipos TypeScript (APIs, DB, Componentes)
category: engineering
stability: stable
---

> This is the CANONICAL version of `generar-tipos`. Prefer this path. The legacy file remains in `workflows/generar-tipos.md` with a pointer here.

---

<!-- Begin canonical content (copied from workflows/generar-tipos.md) -->
---
description: Genera tipos TypeScript automáticamente para APIs, esquemas de base de datos o interfaces.
---

### Paso 1: Identificar fuente de datos
Pregunta al usuario qué tipos necesita generar:
- Respuestas de API (desde OpenAPI/Swagger)
- Esquemas de base de datos (desde Drizzle/Prisma)
- Interfaces de componentes
- Tipos de estado global

### Paso 2: Analizar estructura existente
Busca archivos relevantes:
- Esquemas en `shared/schema.ts`
- Definiciones de API
- Modelos de base de datos
- Interfaces existentes

### Paso 3: Generar tipos automáticamente
Según la fuente:
- **Para APIs**: Usar herramientas como `openapi-typescript`
- **Para DB**: Extraer tipos de esquemas Drizzle
- **Para componentes**: Generar interfaces de props
- **Para estado**: Crear tipos para stores/context

### Paso 4: Crear archivos de tipos
Generar archivos organizados:
```typescript
// types/api.ts - Tipos de API
// types/database.ts - Tipos de DB
// types/components.ts - Props de componentes
// types/global.ts - Tipos globales
```

### Paso 5: Actualizar imports
Actualizar archivos existentes para usar los nuevos tipos:
- Reemplazar `any` con tipos específicos
- Añadir tipado a funciones
- Mejorar intellisense

### Paso 6: Validar tipos
- Ejecutar `tsc --noEmit` para verificar
- Comprobar que no hay errores de tipos
- Sugerir mejoras adicionales

---

## Objetivo
Estandarizar la generación y organización de tipos TypeScript desde diversas fuentes (APIs, DB, componentes) y aplicarlos al código existente con seguridad.

## Entradas
- Fuente de verdad (OpenAPI/Swagger, esquemas Drizzle/Prisma, interfaces existentes)
- Rutas destino para `types/` (ej.: `types/api.ts`, `types/database.ts`, `types/components.ts`, `types/global.ts`)

## Preflight
// turbo
- Crear carpeta `types/` si no existe
- Verificar herramientas necesarias (`openapi-typescript`, etc.)

## Artefactos esperados
- Archivos en `types/*` generados/actualizados
- `project-logs/types-report.md` con resumen de cambios (opcional)

## Aceptación
- Tipos generados sin errores de `tsc --noEmit`
- Reemplazo de `any` por tipos específicos en áreas objetivo
- Imports actualizados y linter sin errores relativos a tipos

## Guardrails
- No sobrescribir tipos manuales críticos sin respaldo
- Mantener separación entre tipos generados y manuales

## Troubleshooting
- Si fallan generadores: fijar versión compatible o usar `--compatibility` del generador
- Si aparecen conflictos de nombres: namespacing en archivos `types/*`
<!-- End canonical content -->