---
description: Meta-workflow que orquesta todos los workflows especializados para construir una app completa desde la idea inicial.
---

### Paso 0: Setup de estructura del proyecto (Monorepo opcional)
Antes de iniciar, crear la estructura base del proyecto para separar apps y paquetes compartidos.

Estructura sugerida:
```
projectx-platform/
├─ apps/
│  ├─ ui/                 # Frontend (React + Vite + Tailwind)
│  └─ api/                # Backend/API (a definir)
├─ packages/
│  └─ shared/             # Módulos compartidos (tipos, utils)
├─ infra/                 # Infra/DevOps (CI, IaC, Docker, etc.)
└─ docs/                  # Documentación y runbooks
```

PowerShell (Windows):
```
$root = "C:\\Users\\admin\\OneDrive\\Escritorio\\project_x"
New-Item -ItemType Directory -Force -Path `
  "$root\\projectx-platform", `
  "$root\\projectx-platform\\apps\\ui", `
  "$root\\projectx-platform\\apps\\api", `
  "$root\\projectx-platform\\packages\\shared", `
  "$root\\projectx-platform\\infra", `
  "$root\\projectx-platform\\docs" | Out-Null
```

Nota: no es necesario mover el código existente inmediatamente. Puedes trabajar en `apps/ui` y planificar la migración del directorio actual (`projectx-ui/`) más adelante.

### Paso 1: Análisis inicial y decisión de path
Ejecutar `/ai-project-manager` para:
- Analizar complejidad del proyecto
- Determinar timeline óptimo
- Seleccionar path de desarrollo (Rapid vs Master)

### Paso 2: Strategic Intelligence
Ejecutar `/vibe-coder-intelligence` para:
- Investigación de mercado
- Análisis competitivo
- Identificación de oportunidades
- Definición de diferenciadores

### Paso 3: Desarrollo según path seleccionado
- Si Rapid Path: Ejecutar `/vibe-coder-rapid`
- Si Master Path: Ejecutar `/vibe-coder-master`
- Si Hybrid: Combinar ambos enfoques

### Paso 4: Optimización y calidad
Ejecutar workflows especializados:
- `/optimizar-bundle` para performance
- `/revisar-seguridad` para vulnerabilidades
- `/escribir-prueba` para testing

### Paso 5: Validación UX/UI
- `/analizar-performance` para métricas
- Revisión de accesibilidad
- Testing de usabilidad

### Paso 6: Deploy y documentación
- Setup de CI/CD
- `/analizar-performance` - Optimizar velocidad
- `/revisar-seguridad` - Audit de vulnerabilidades
- `/optimizar-bundle` - Reducir tamaño
- `/refactor-componente` - Limpiar código

### Paso 6: Validación UX/UI
Usar workflows de análisis:
- `/agent` - Análisis técnico completo con Puppeteer
- `/mejorar-ux-ui` - Mejoras de interfaz
- `/websitedebug` - Debug de problemas

### Paso 7: Deploy y Monitoreo
Finalización automática:
- Deploy a producción
- Setup de métricas de success
- Documentación final del proyecto
- Handoff al cliente/equipo

### Lógica de Decisión Automática:
```
IF (complejidad_alta AND timeline > 3_días) 
  THEN ejecutar Master Path
ELSE 
  ejecutar Rapid Path

IF (errores_detectados) 
  THEN ejecutar workflows de debug

IF (performance_score < 80) 
  THEN ejecutar optimización

IF (security_issues > 0) 
  THEN ejecutar audit de seguridad
```
