# 📚 Workflows de Documentación - AI VIBESHIFT

Sistema completo de workflows para documentar automáticamente todo el repositorio con diagramas y mejores prácticas.

## 🎯 Workflows Disponibles

### Core Documentation Workflows

| Workflow | Comando | Descripción | Tiempo Estimado |
|----------|---------|-------------|-----------------|
| **Component Docs** | `/documentation/component-docs` | Documenta componentes React con diagramas | 5-10 min |
| **Architecture Diagrams** | `/documentation/architecture-diagrams` | Diagramas de arquitectura del sistema | 3-5 min |
| **API Docs** | `/documentation/api-docs` | Documentación de endpoints y tipos | 5-8 min |
| **Data Flow Diagrams** | `/documentation/data-flow-diagrams` | Flujos de datos y estado | 4-6 min |
| **Patterns Docs** | `/documentation/patterns-docs` | Patrones de diseño y mejores prácticas | 6-10 min |

## 🚀 Combinaciones de Workflows

### 🔥 **Documentación Completa del Proyecto**
*Para cuando quieres documentar TODO desde cero*

# Ejecutar todos los workflows en secuencia
# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow component-docs
.\scripts\run-documentation.ps1 -Workflow architecture-diagrams
.\scripts\run-documentation.ps1 -Workflow api-docs
.\scripts\run-documentation.ps1 -Workflow data-flow-diagrams
.\scripts\run-documentation.ps1 -Workflow patterns-docs

# O usar el workflow maestro
.\scripts\run-documentation.ps1 -Workflow full-project-docs
```

**Resultado:** Documentación completa en `docs/` + diagramas en `docs/diagrams/`

---

### 🎨 **Solo Arquitectura y Diseño**
*Para entender la estructura del proyecto rápidamente*

# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow architecture-diagrams
.\scripts\run-documentation.ps1 -Workflow component-docs
.\scripts\run-documentation.ps1 -Workflow patterns-docs
```

**Resultado:** Arquitectura visual + componentes + patrones de diseño

---

### 🔌 **APIs y Backend**
*Para documentar solo la capa de datos y APIs*

# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow api-docs
.\scripts\run-documentation.ps1 -Workflow data-flow-diagrams
.\scripts\run-documentation.ps1 -Workflow architecture-diagrams
```

**Resultado:** APIs completas + flujos de datos + arquitectura backend

---

### ⚡ **Onboarding de Nuevo Desarrollador**
*Para que un nuevo dev entienda el proyecto rápidamente*

# Ejecutar todos los workflows en secuencia
# Paso 1: Arquitectura general
.\scripts\run-documentation.ps1 -Workflow architecture-diagrams

# Paso 2: Cómo están hechos los componentes
.\scripts\run-documentation.ps1 -Workflow component-docs

# Paso 3: Patrones y mejores prácticas
.\scripts\run-documentation.ps1 -Workflow patterns-docs

# Paso 4: APIs disponibles
.\scripts\run-documentation.ps1 -Workflow api-docs
```

**Resultado:** Guía completa de onboarding con ejemplos

---

### 🔧 **Mantenimiento y Refactoring**
*Para preparar un refactor o mantenimiento*

# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow patterns-docs
.\scripts\run-documentation.ps1 -Workflow data-flow-diagrams
.\scripts\run-documentation.ps1 -Workflow component-docs
```

**Resultado:** Análisis de código smells + flujos de datos + componentes problemáticos

---

### 📊 **Auditoría de Calidad**
*Para revisar la calidad del código y documentación*

# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow patterns-docs
.\scripts\run-documentation.ps1 -Workflow architecture-diagrams
.\scripts\run-documentation.ps1 -Workflow api-docs
```

**Resultado:** Reporte de calidad con métricas y recomendaciones

---

### 🏗️ **Nuevo Feature Planning**
*Para planificar una nueva funcionalidad*

# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow architecture-diagrams
.\scripts\run-documentation.ps1 -Workflow data-flow-diagrams
.\scripts\run-documentation.ps1 -Workflow component-docs
```

**Resultado:** Arquitectura actual + impacto en flujos + componentes afectados

---

## 📁 Estructura Generada

```
docs/
├── components/
│   ├── [ComponentName].md          # Docs individuales
│   └── README.md                   # Índice de componentes
├── diagrams/
│   ├── project-structure.md        # Arquitectura general
│   ├── component-architecture.md   # Arquitectura componentes
│   ├── data-flow.md               # Flujo de datos
│   └── dependencies.md            # Dependencias
├── api/
│   ├── [endpoint].md              # Docs de endpoints
│   └── README.md                  # Índice de APIs
├── patterns/
│   ├── component-patterns.md      # Patrones de componentes
│   ├── state-patterns.md          # Patrones de estado
│   └── architecture-patterns.md   # Patrones arquitectura
└── best-practices/
    ├── coding-standards.md        # Estándares de código
    └── development-guide.md       # Guía de desarrollo

project-logs/
├── docs/
│   ├── component-analysis.json    # Análisis de componentes
│   ├── architecture-analysis.json # Análisis arquitectura
│   └── patterns-analysis.json     # Análisis de patrones
└── diagrams/
    ├── component-architecture.md  # Diagramas Mermaid
    └── data-flow-diagrams.md      # Diagramas de flujo
```

## 🔧 Cómo Ejecutar Workflows

### Opción 1: Comando Directo
# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow component-docs
```

### Opción 2: Con Parámetros
# Ejecutar todos los workflows en secuencia
/documentation/component-docs --dryRun
/documentation/component-docs --output=custom-folder
```

### Opción 3: Workflow Maestro
# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow full-project-docs
```

## 📊 Métricas Generadas

Cada workflow genera métricas JSON:

```json
{
  "totalComponents": 74,
  "documentedComponents": 45,
  "complexComponents": 12,
  "diagramsGenerated": 8,
  "status": "completed",
  "timestamp": "2025-09-13T00:27:04-03:00"
}
```

## 🎯 Casos de Uso Específicos

### Para Code Reviews
# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow patterns-docs
```
*Verifica que el código sigue los patrones establecidos*

### Para Pull Requests
# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow component-docs
```
*Documenta nuevos componentes antes del merge*

### Para Sprint Planning
# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow architecture-diagrams
.\scripts\run-documentation.ps1 -Workflow data-flow-diagrams
```
*Entiende el impacto de nuevas features*

### Para Technical Debt
# Ejecutar todos los workflows en secuencia
.\scripts\run-documentation.ps1 -Workflow patterns-docs
.\scripts\run-documentation.ps1 -Workflow api-docs
```
*Identifica áreas que necesitan refactoring*

## 🚨 Troubleshooting

### Error: "Workflow no encontrado"
- Asegúrate de estar en el directorio raíz del proyecto
- Verifica que los archivos `.windsurf/workflows/Documentation/` existen

### Error: "Permisos insuficientes"
- Ejecuta como administrador si es necesario
- Verifica permisos de escritura en `docs/` y `project-logs/`

### Error: "Dependencias faltantes"
# Ejecutar todos los workflows en secuencia
npm install -g @mermaid-js/mermaid-cli
npm install -g typedoc
```

## 🎉 Próximos Pasos

1. **Ejecuta una combinación** según tu necesidad actual
2. **Revisa los artefactos generados** en `docs/`
3. **Valida los diagramas** y ajusta según necesites
4. **Integra en CI/CD** para documentación automática

---

*¿Qué combinación necesitas ejecutar ahora mismo?*
