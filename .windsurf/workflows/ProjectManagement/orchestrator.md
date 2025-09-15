---
description: Sistema de orquestación inteligente que coordina automáticamente todos los workflows para desarrollo completo.
---

### Paso 0: Crear estructura del proyecto (OBLIGATORIO, AutoRun)
// turbo
Crear automáticamente la estructura estandarizada del proyecto ANTES de orquestar cualquier workflow.
Estructura creada:

    Estructura sugerida (flexible según necesidades del proyecto):
    ```
    projectx-platform/
    ├─ apps/
    │  ├─ front/              # Frontend (React + Vite + Tailwind)
    │  └─ back/               # Backend/API (a definir)
    ├─ packages/
    │  └─ shared/             # Módulos compartidos (tipos, utils)
    ├─ infra/                 # Infra/DevOps (CI, IaC, Docker, etc.)
    └─ docs/                  # Documentación y runbooks
    ```

PowerShell (Windows):
```
    # Se ejecuta automáticamente (AutoRun)
    $root = "C:\\Users\\admin\\OneDrive\\Escritorio"
    $name = "{project_slug}-platform"  # parametrizado por proyecto
    New-Item -ItemType Directory -Force -Path `
      "$root\\$name", `
      "$root\\$name\\apps\\front", `
      "$root\\$name\\apps\\back", `
      "$root\\$name\\packages\\shared", `
      "$root\\$name\\infra", `
      "$root\\$name\\docs" | Out-Null

    # Sembrar .gitkeep en subcarpetas clave
    $paths = @(
      "$root\\$name\\apps\\front",
      "$root\\$name\\apps\\back",
      "$root\\$name\\packages\\shared",
      "$root\\$name\\infra",
      "$root\\$name\\docs"
    )
    foreach ($p in $paths) { New-Item -ItemType File -Force -Path (Join-Path $p ".gitkeep") | Out-Null }

    # Crear README inicial en la carpeta docs del monorepo
    $readmePath = Join-Path -Path "$root\\$name\\docs" -ChildPath "README.md"
    @"
    # {project_slug}-platform — Documentación

    Este monorepo contiene la plataforma del proyecto {project_name}.

    - Frontend: apps/front
    - Backend: apps/back
    - Paquetes compartidos: packages/shared
    - Infraestructura: infra

    Documentación detallada del producto: ver repo actual en `docs/{project_slug}/`.
    "@ | Out-File -Encoding UTF8 -FilePath $readmePath
    ```

    #### Estructura extensible por proyecto
    - Esta estructura es base. Según el proyecto, el orquestador puede crear carpetas adicionales (p. ej.: `e2e/`, `scripts/`, `datasets/`, `ml/`, `serverless/`, `design/`).
    - Opcional: definir una lista de carpetas extra en `docs/{project_slug}/orchestrator/project-structure.json` para que el AutoRun cree automáticamente dichas rutas.
    - Todas las creaciones quedan registradas en `docs/{project_slug}/orchestrator/logs/run-{timestamp}.md`.

    Ejemplo de `project-structure.json`:
    ```json
    {
      "extra_dirs": [
        "apps/front/src/features",
        "apps/back/src/modules",
        "e2e",
        "scripts",
        "design"
      ]
    }
    ```

    PowerShell (AutoRun) para crear directorios extra si el JSON existe:
    ```powershell
    $projectSlug = "{project_slug}" # reemplazar en runtime
    $jsonPath = Join-Path -Path (Resolve-Path ".") -ChildPath "docs/$projectSlug/orchestrator/project-structure.json"
    if (Test-Path $jsonPath) {
      try {
        $cfg = Get-Content $jsonPath | ConvertFrom-Json
        if ($cfg.extra_dirs) {
          $repoRoot = Resolve-Path "."
          $platformName = "$projectSlug-platform"
          $platformRoot = Join-Path -Path $repoRoot -ChildPath $platformName
          foreach ($rel in $cfg.extra_dirs) {
            $full = Join-Path -Path $platformRoot -ChildPath $rel
            New-Item -ItemType Directory -Force -Path $full | Out-Null
            New-Item -ItemType File -Force -Path (Join-Path $full ".gitkeep") | Out-Null
          }
        }
      } catch {
        Write-Host "[orchestrator] No se pudo leer project-structure.json: $($_.Exception.Message)"
      }
    }
    ```

### Paso 0.1: Estrategia de Producto inicial (OBLIGATORIO)
Ejecutar `/product-strategy-and-definition` para generar la base de documentación en `docs/{project_slug}/product/`:
- `discovery/intake-{timestamp}.md`, `brand/brand-vision-{timestamp}.md`, `prd/prd-{timestamp}.md`, `roadmap/roadmap-{quarter}.md`, etc.
- Registrar en log: artefactos creados y rutas.

### Paso 1: Intake y análisis
Sin solicitar input al usuario. Consumir artefactos más recientes de `docs/{project_slug}/product/discovery/` y `docs/{project_slug}/product/prd/`. Ejecutar:
- Análisis de complejidad automático
- Estimación de recursos necesarios
- Identificación de workflows requeridos
- Creación de roadmap de ejecución
- Registrar métricas y decisiones en `docs/{project_slug}/orchestrator/logs/run-{timestamp}.md`
- Preferencias tecnológicas por defecto (usar siempre que aplique):
  - Frontend: React 18 + Vite, React Router v7, Tailwind + shadcn/ui
  - Datos: PostgreSQL (Neon/local) vía Drizzle ORM
  - AI: Google Gemini (primario) y opcional OpenAI si hay configuración

### Paso 2: Orquestación inteligente
Coordinar la ejecución de workflows en el orden óptimo:
- Workflows paralelos cuando sea posible
- Dependencias respetadas
- Monitoreo de progreso en tiempo real
- Ajustes automáticos según resultados
- Todas las salidas deben escribirse bajo `docs/{project_slug}/...` y registrarse en log.

### Paso 3: Quality gates
Implementar checkpoints automáticos:
- Validación de código
- Testing automatizado
- Performance benchmarks
- Security scanning
- Si un gate falla, registrar detalle y activar workflow de recuperación correspondiente.

### Paso 4: Optimización continua
- Análisis de métricas de desarrollo
- Identificación de bottlenecks
- Sugerencias de mejora
- Learning para futuros proyectos
- Publicar `{docs_base}/orchestrator/logs/summary-{yyyy-mm-dd}.md` con hallazgos y acciones.

### Paso 5: Delivery y handoff
- Preparación de entregables
- Documentación automática
- Setup de monitoreo
- Transferencia de conocimiento
- Consolidar enlaces a artefactos clave del producto bajo `{docs_base}/product/`.

### Preflight
    // turbo
    - Detectar `docs_base` automáticamente:
      - Si existe `docs/{project_slug}/` usarlo como `docs_base`.
      - En caso contrario, si existe `docs/projects/{project_slug}/` usarlo como `docs_base`.
      - Si no existe ninguno, crear `docs/{project_slug}/` como `docs_base` por defecto.
    - Crear subcarpetas mínimas en `{docs_base}/`:
      - `product/` (si aplica), `orchestrator/logs/`, `status/`
    - Crear estructura base adicional si falta:
      - `{docs_base}/product/` con subcarpetas definidas por `/product-strategy`
    - Iniciar log: `{docs_base}/orchestrator/logs/run-{timestamp}.md`

### Publicación final en Notion (OBLIGATORIO, cumpliendo Regla 1)
// turbo
- Ejecutar `/create-dynamic-root` para crear SIEMPRE una nueva página raíz del proyecto en Notion y obtener su `root_page_id` dinámicamente (no usar IDs codificados ni previos).
- Publicar como subpáginas los artefactos clave ya generados en `{docs_base}/product/`:
  - `discovery/intake-*`, `brand/brand-vision-*`, `prd/prd-*`, `roadmap/roadmap-*`, `metrics/metrics-*`, `stack/stack-*`.
- Escribir un índice en Notion que enlace a todas las subpáginas y refleje el TOC de `{docs_base}/product/`.
- Guardar en `{docs_base}/orchestrator/logs/run-{timestamp}.md` la URL de la raíz y de cada subpágina creada.
- Actualizar `{docs_base}/status/latest.json` con:
  - Fecha/hora, paths locales, URLs Notion, métricas resumen y resultado de quality gates.

**ORQUESTACIÓN TASK MANAGER:**
1. AI-PM → Intelligence → Master Path (paralelo)
2. Arquitectura + Desarrollo (secuencial)
3. AI Features + Testing (paralelo)
4. Optimización + Deploy (secuencial)
Resultado: 8 workflows coordinados, 0 conflictos, entrega en tiempo

### Matriz de Decisión Automática

#### Análisis Inicial (Siempre ejecutar)
1. `/product-strategy-and-definition` - Base estratégica y PRD (autorun)
2. `/vibe-coder-intelligence` - Strategic Intelligence Process
3. Evaluar complejidad, timeline y recursos

#### Path Selection Logic
```
COMPLEXITY_SCORE = 
  (features_count * 2) + 
  (integrations_needed * 3) + 
  (custom_ui_requirements * 2) + 
  (backend_complexity * 4)

IF COMPLEXITY_SCORE > 15 OR timeline > 72h:
  EXECUTE Master Path
ELSE:
  EXECUTE Rapid Path
```

#### Master Path Workflow Chain
1. `/product-strategy-and-definition` - Foundation docs (autorun + logs)
2. `/vibe-coder-master` - Comprehensive development
3. `/generar-tipos` - Type system setup
4. `/crear-componente` (x5-10) - Core components
5. `/crear-endpoint-api` (x3-8) - Backend APIs
6. `/escribir-prueba` (x3-5) - Test coverage
7. `/documentar-codigo` - Documentation
8. `/revisar-seguridad` - Security audit
9. `/optimizar-bundle` - Performance optimization
10. `/agent` - Complete technical analysis
11. `/mejorar-ux-ui` - UI/UX refinement

#### Rapid Path Workflow Chain
1. `/product-strategy-and-definition` - Foundation docs (autorun + logs)
2. `/vibe-coder-rapid` - Fast prototyping
3. `/crear-componente` (x2-4) - Essential components
4. `/crear-endpoint-api` (x1-3) - Core APIs
5. `/websitedebug` - Quick debugging
6. `/analizar-performance` - Basic optimization

#### Quality Gates (Auto-triggered)
- IF performance_score < 70: Execute `/analizar-performance`
- IF security_issues > 0: Execute `/revisar-seguridad`
- IF bundle_size > 2MB: Execute `/optimizar-bundle`
- IF component_complexity > 200_lines: Execute `/refactor-componente`
- IF test_coverage < 60%: Execute `/escribir-prueba`
- Todos los triggers deben loguearse con contexto en `docs/{project_slug}/orchestrator/logs/run-{timestamp}.md`.

#### Error Recovery Workflows
- Console errors detected: `/browserdebug` or `/websitedebug`
- UI/UX issues found: `/mejorar-ux-ui`
- Performance problems: `/analizar-performance`
- API issues: `/analizar-endpoints`
- Anexar secciones de "Causa Raíz" y "Acciones" al log de la corrida.

#### Success Metrics Tracking
- Feature completion rate
- Performance scores (LCP, FID, CLS)
- Security audit results
- Test coverage percentage
- Bundle size optimization
- User experience scores
- Publicar snapshot de métricas en `docs/{project_slug}/orchestrator/logs/summary-{yyyy-mm-dd}.md`.
