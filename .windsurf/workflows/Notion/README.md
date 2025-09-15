---
description: Notion Workflows — Cómo funcionan, qué hacen y cómo usarlos
---

# Notion Workflows — Guía de Uso y Funcionamiento

Esta carpeta (`.windsurf/workflows/Notion/`) contiene una serie de workflows estandarizados para automatizar operaciones en Notion durante el desarrollo. Están diseñados para ser seguros, reproducibles y alineados con las Reglas Globales de Windsurf, en especial con la Regla 1 de Creación Dinámica de Página Raíz.

La guía explica:
- Qué hace cada workflow
- Cómo ejecutarlos (slash-commands o lectura directa del workflow)
- Variables de entorno requeridas
- Consideraciones de seguridad y errores
- Flujo recomendado (de principio a fin)


## Principios clave (Reglas Globales)

- Creación dinámica de raíz: Ningún workflow debe depender de IDs fijos. En cada ejecución se crea una nueva página raíz de Notion y se usa su ID de forma dinámica.
- Documentación: Cada workflow incluye descripción y pasos claros.
- Manejo robusto de errores: Mensajes claros, validaciones de precondiciones y salidas seguras.


## Variables de Entorno requeridas

Configura estas variables antes de usar los workflows:

- NOTION_TOKEN: Token de la integración de Notion con permisos adecuados (lectura/escritura).
- NOTION_WORKSPACE_ID: Identificador del workspace donde se crearán las páginas. Los workflows crean una nueva página raíz en cada ejecución usando este ID.
- DRY_RUN (opcional): "true" para simular acciones sin efectuar cambios.
- LOG_LEVEL (opcional): "info" | "debug" | "warn" | "error". Por defecto: "info".

Notas:
- No se deben hardcodear IDs de páginas ni suponer contexto previo. Si un workflow requiere un padre, él mismo debe crear la nueva raíz.
- Si tu entorno de Notion requiere un parent.page_id en lugar de workspace, el workflow debe crearlo primero y luego encadenar operaciones.


## Workflows disponibles (archivos en esta carpeta)

- create-dynamic-root.md
  - Crea una página raíz nueva en el workspace especificado por NOTION_WORKSPACE_ID.
  - Devuelve y/o persiste el ID de esa raíz para que workflows posteriores creen subpáginas bajo ella.

- env-setup.md
  - Valida que existan NOTION_TOKEN y NOTION_WORKSPACE_ID.
  - Verifica permisos básicos de la integración.

- index.md
  - Índice navegable de workflows de Notion. Úsalo para descubrir o revisar rápidamente.

- status.md
  - Snapshot del estado actual: tokens, entorno, últimos IDs registrados y verificaciones mínimas.

- seed-portal-structure.md
  - Crea la estructura estándar de subpáginas de portal bajo la raíz dinámica (p. ej., Documentación, Backlog, Specs, etc.).

- backfill-subpages.md
  - Asegura que existan ciertas subpáginas estándar bajo la raíz dinámica. Crea solo lo que falte, sin duplicar.

- sync-links.md
  - Sincroniza IDs/links de Notion en archivos del repositorio para mantener consistencia.

- rollback.md
  - Limpia/archiva páginas creadas por una corrida anterior si necesitas revertir.


## Cómo ejecutarlos

Hay dos formas principales:

1) Slash-commands en Windsurf
- Usa los siguientes comandos (si tu índice global de slash-commands los expone):
  - /env-setup
  - /status
  - /index
  - /create-dynamic-root
  - /seed-portal-structure
  - /backfill-subpages
  - /sync-links
  - /rollback
- Estos comandos abren y ejecutan los pasos definidos en cada workflow. Algunos pasos marcados con `// turbo` pueden auto-ejecutarse (solo si son seguros), el resto solicitarán confirmación.

2) Apertura manual del workflow
- Abre el archivo `.windsurf/workflows/Notion/<workflow>.md`.
- Sigue los pasos en orden. Cuando un paso requiera ejecutar un comando, utiliza el panel de comandos de Windsurf (se pedirá confirmación antes de ejecutar acciones con efectos en tu entorno).


## Flujo recomendado de principio a fin

1. env-setup.md
- Verifica que NOTION_TOKEN y NOTION_WORKSPACE_ID estén correctamente definidos.

2. create-dynamic-root.md
- Crea una nueva página raíz en Notion para esta corrida. Guarda el ID dinámicamente.

3. seed-portal-structure.md
- Genera la estructura base de subpáginas bajo la nueva raíz.

4. backfill-subpages.md
- Asegura que ninguna subpágina estándar falte; crea solo lo faltante.

5. sync-links.md
- Propaga y sincroniza los IDs y enlaces generados hacia donde corresponda en el repo.

6. status.md
- Toma un snapshot de validación: tokens, IDs y consistencia.

7. rollback.md (opcional)
- Si necesitas revertir/archivar lo creado en una corrida de prueba, ejecútalo de forma segura.


## Seguridad y buenas prácticas

- Safe-by-default: Los pasos potencialmente peligrosos (que crean, actualizan o archivan páginas) deben pedir confirmación. Evita ejecuciones automáticas sin revisión.
- No hardcodear IDs: Cumple la Regla 1. Cada corrida crea su propia raíz.
- DRY_RUN primero: Ante dudas, usa DRY_RUN=true para ensayar.
- Logs claros: Ajusta LOG_LEVEL a "debug" si necesitas trazar.


## Manejo de errores

- Validación temprana: `env-setup.md` debe fallar de forma clara si faltan variables.
- Mensajes útiles: Cada paso debe reportar el contexto (qué va a crear, dónde y por qué).
- Reintentos idempotentes: `backfill-subpages.md` debe poder ejecutarse múltiples veces sin duplicar.
- Rollback seguro: `rollback.md` debe archivar o limpiar solo lo creado por la ejecución identificada.


## Preguntas frecuentes (FAQ)

- ¿Puedo usar una página padre existente en lugar de crear una nueva raíz? No. Por política, cada ejecución crea una raíz nueva; esto asegura independencia, trazabilidad y evita colisiones.
- ¿Cómo sé cuál es la raíz creada? `create-dynamic-root.md` registra el ID y/o lo imprime en salida para que los siguientes pasos lo utilicen.
- ¿Qué permisos necesita NOTION_TOKEN? Debe poder crear y leer páginas en el workspace objetivo.


## Soporte

Si encuentras un comportamiento inesperado o deseas ampliar la automatización, abre un issue interno del proyecto y adjunta:
- Logs (con LOG_LEVEL=debug si es posible)
- Variables de entorno usadas (sin incluir secretos en texto plano)
- Pasos ejecutados y workflows involucrados

Con esto podremos diagnosticar rápidamente y proponer mejoras.
