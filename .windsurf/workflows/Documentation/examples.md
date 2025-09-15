# 🚀 Ejemplos de Ejecución - Workflows de Documentación AI VIBESHIFT

Este archivo contiene ejemplos prácticos de cómo ejecutar los diferentes workflows de documentación.

## 📋 Prerrequisitos

1. Asegúrate de estar en el directorio raíz del proyecto:
```powershell
cd c:\Users\admin\OneDrive\Escritorio\VIBESHIFT-ai-forge-06
```

2. Verifica que el script existe:
```powershell
Test-Path .\.windsurf\workflows\Documentation\scripts\run-documentation.ps1
```

## 🔥 Ejemplo 1: Documentación Completa del Proyecto

*Cuando quieres documentar TODO desde cero*

```powershell
# Ejecutar documentación completa
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow full-project-docs
```

**Resultado esperado:**
- ✅ Análisis de 74+ componentes
- ✅ Diagramas de arquitectura generados
- ✅ Documentación de APIs completa
- ✅ Patrones de diseño documentados
- 📁 Archivos generados en `docs/` y `project-logs/`

---

## 🎨 Ejemplo 2: Solo Arquitectura (Rápido)

*Para entender la estructura del proyecto rápidamente*

```powershell
# Arquitectura del proyecto
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow architecture-diagrams

# Componentes principales
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow component-docs
```

**Resultado esperado:**
- 🏗️ Diagrama de estructura del proyecto
- 📦 Análisis de componentes por categorías
- 📊 Métricas de arquitectura

---

## 🔌 Ejemplo 3: APIs y Backend

*Para documentar solo la capa de datos y APIs*

```powershell
# Documentación de APIs
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow api-docs

# Flujos de datos
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow data-flow-diagrams

# Arquitectura backend
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow architecture-diagrams
```

**Resultado esperado:**
- 🔌 Endpoints documentados con ejemplos
- 🔄 Diagramas de flujo de autenticación
- 📊 Tipos TypeScript generados

---

## ⚡ Ejemplo 4: Onboarding de Nuevo Desarrollador

*Para que un nuevo dev entienda el proyecto rápidamente*

```powershell
# Paso 1: Arquitectura general
Write-Host "📚 Paso 1: Arquitectura del proyecto" -ForegroundColor Cyan
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow architecture-diagrams

# Paso 2: Cómo están hechos los componentes
Write-Host "🧩 Paso 2: Componentes del sistema" -ForegroundColor Cyan
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow component-docs

# Paso 3: Patrones y mejores prácticas
Write-Host "🎯 Paso 3: Patrones de diseño" -ForegroundColor Cyan
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow patterns-docs

# Paso 4: APIs disponibles
Write-Host "🔌 Paso 4: APIs del sistema" -ForegroundColor Cyan
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow api-docs
```

**Resultado esperado:**
- 📖 Guía completa de onboarding
- 🗺️ Mapa visual del proyecto
- 📋 Lista de convenciones y patrones
- 🔧 APIs listas para usar

---

## 🔧 Ejemplo 5: Mantenimiento y Refactoring

*Para preparar un refactor o mantenimiento*

```powershell
# Análisis de patrones actuales
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow patterns-docs

# Flujos de datos para identificar dependencias
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow data-flow-diagrams

# Componentes que podrían necesitar refactoring
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow component-docs
```

**Resultado esperado:**
- 🔍 Identificación de código smells
- 🔗 Mapa de dependencias entre componentes
- 📊 Reporte de componentes complejos

---

## 📊 Ejemplo 6: Auditoría de Calidad

*Para revisar la calidad del código y documentación*

```powershell
# Análisis de patrones y mejores prácticas
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow patterns-docs

# Arquitectura general
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow architecture-diagrams

# Cobertura de APIs
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow api-docs
```

**Resultado esperado:**
- 📈 Reporte de calidad con métricas
- ⚠️ Áreas que necesitan mejora
- ✅ Puntos fuertes identificados

---

## 🏗️ Ejemplo 7: Planning de Nueva Feature

*Para planificar una nueva funcionalidad*

```powershell
# Arquitectura actual
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow architecture-diagrams

# Flujos de datos existentes
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow data-flow-diagrams

# Componentes disponibles para reutilizar
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow component-docs
```

**Resultado esperado:**
- 🎯 Impacto estimado de la nueva feature
- 🔄 Puntos de integración identificados
- 🧩 Componentes reutilizables disponibles

---

## 🧪 Ejemplo 8: Modo Dry Run (Pruebas)

*Para probar sin generar archivos*

```powershell
# Probar todos los workflows sin generar archivos
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow component-docs -DryRun
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow architecture-diagrams -DryRun
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow api-docs -DryRun
```

**Resultado esperado:**
- 📋 Análisis completo sin modificar archivos
- 📊 Estadísticas de lo que se generaría
- ⚡ Ejecución rápida para testing

---

## 📁 Ejemplo 9: Salida Personalizada

*Para generar documentación en directorio específico*

```powershell
# Generar documentación en carpeta específica
.\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow full-project-docs -OutputPath "docs-auditoria"

# Verificar resultado
Get-ChildItem -Path "docs-auditoria" -Recurse
```

**Resultado esperado:**
- 📁 Documentación en directorio personalizado
- 📊 Estructura completa preservada
- 🔗 Rutas actualizadas automáticamente

---

## 🎯 Ejemplo 10: Automatización en CI/CD

*Para integrar en pipeline de CI/CD*

```powershell
# Script para CI/CD
$workflows = @(
    "component-docs",
    "architecture-diagrams",
    "api-docs",
    "patterns-docs"
)

foreach ($workflow in $workflows) {
    Write-Host "🚀 Ejecutando workflow: $workflow" -ForegroundColor Cyan
    & .\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow $workflow

    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Error en workflow: $workflow" -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ Todos los workflows completados exitosamente" -ForegroundColor Green
```

**Resultado esperado:**
- 🔄 Automatización completa en CI/CD
- 🚨 Fallo temprano si hay errores
- 📊 Reportes automáticos generados

---

## 📊 Verificación de Resultados

Después de ejecutar cualquier workflow, verifica los resultados:

```powershell
# Ver archivos generados
Get-ChildItem -Path "docs" -Recurse | Select-Object FullName, Length, LastWriteTime

# Ver métricas generadas
Get-Content -Path "project-logs/docs/workflow-metrics.json" | ConvertFrom-Json

# Ver diagramas generados
Get-ChildItem -Path "docs/diagrams" -Filter "*.md"
```

---

## 🚨 Solución de Problemas

### Error de permisos
```powershell
# Ejecutar como administrador si es necesario
Start-Process powershell -Verb RunAs -ArgumentList ".\.windsurf\workflows\Documentation\scripts\run-documentation.ps1 -Workflow component-docs"
```

### Error de dependencias
```powershell
# Instalar dependencias si faltan
npm install -g @mermaid-js/mermaid-cli
npm install -g typedoc
```

### Error de rutas
```powershell
# Verificar ubicación actual
Get-Location

# Cambiar al directorio correcto
Set-Location "c:\Users\admin\OneDrive\Escritorio\VIBESHIFT-ai-forge-06"
```

---

## 🎉 ¿Qué combinación necesitas ejecutar ahora?

Elige el ejemplo que mejor se ajuste a tu necesidad actual:

1. 🔥 **Documentación completa** - Para empezar desde cero
2. 🎨 **Solo arquitectura** - Para entender rápidamente
3. 🔌 **APIs y backend** - Para capa de datos
4. ⚡ **Onboarding** - Para nuevo desarrollador
5. 🔧 **Mantenimiento** - Para refactoring
6. 📊 **Auditoría** - Para calidad
7. 🏗️ **Planning** - Para nuevas features
8. 🧪 **Dry run** - Para testing
9. 📁 **Salida personalizada** - Para ubicaciones específicas
10. 🎯 **CI/CD** - Para automatización

¡Solo copia y pega el ejemplo que necesites! 🚀
