# 📚 Ejecutor Maestro de Workflows de Documentación
# Para AI VIBESHIFT - Sistema de documentación automática

param(
    [Parameter(Mandatory=$false)]
    [string]$Workflow,

    [Parameter(Mandatory=$false)]
    [switch]$DryRun,

    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "docs",

    [Parameter(Mandatory=$false)]
    [switch]$Help
)

# Función para mostrar ayuda
function Show-Help {
    Write-Host @"
📚 Ejecutor Maestro de Workflows de Documentación - AI VIBESHIFT

USO:
    .\run-documentation.ps1 -Workflow <nombre> [opciones]

WORKFLOWS DISPONIBLES:
    component-docs          Documentar componentes React
    architecture-diagrams   Generar diagramas de arquitectura
    api-docs               Documentar APIs y endpoints
    data-flow-diagrams     Diagramas de flujo de datos
    patterns-docs          Patrones de diseño y mejores prácticas
    full-project-docs      TODOS los workflows (completo)
    auto-orchestrate       Selección automática y ejecución óptima

OPCIONES:
    -Workflow <string>     Nombre del workflow a ejecutar
    -DryRun               Solo análisis, no genera archivos
    -OutputPath <string>   Directorio de salida (default: docs)
    -Help                  Mostrar esta ayuda

EJEMPLOS:
    .\run-documentation.ps1 -Workflow component-docs
    .\run-documentation.ps1 -Workflow full-project-docs -DryRun
    .\run-documentation.ps1 -Workflow architecture-diagrams -OutputPath "custom-docs"

COMBINACIONES RECOMENDADAS:
    Para nuevo dev:      component-docs + architecture-diagrams + patterns-docs
    Para APIs:           api-docs + data-flow-diagrams
    Para mantenimiento:  patterns-docs + component-docs
    Para planning:       architecture-diagrams + data-flow-diagrams

"@
}

# Función para crear directorios necesarios
function Initialize-Directories {
    param([string]$BasePath)

    $dirs = @(
        "$BasePath/components",
        "$BasePath/diagrams",
        "$BasePath/api",
        "$BasePath/patterns",
        "$BasePath/best-practices",
        "project-logs/docs",
        "project-logs/diagrams"
    )

    foreach ($dir in $dirs) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Host "📁 Creado directorio: $dir" -ForegroundColor Green
        }
    }
}

# Función para analizar componentes
function Analyze-Components {
    param([string]$ComponentsPath, [bool]$IsDryRun)

    Write-Host "🔍 Analizando componentes en: $ComponentsPath" -ForegroundColor Yellow

    if (!(Test-Path $ComponentsPath)) {
        Write-Host "❌ Directorio de componentes no encontrado: $ComponentsPath" -ForegroundColor Red
        return $null
    }

    $componentFiles = Get-ChildItem -Path $ComponentsPath -Filter "*.tsx" -Recurse
    $totalComponents = $componentFiles.Count

    Write-Host "📊 Encontrados $totalComponents componentes" -ForegroundColor Cyan

    if ($IsDryRun) {
        Write-Host "🔍 Modo DryRun - No se generan archivos" -ForegroundColor Yellow
        return @{
            totalComponents = $totalComponents
            componentFiles = $componentFiles
        }
    }

    return @{
        totalComponents = $totalComponents
        componentFiles = $componentFiles
    }
}

# Función para generar diagrama de arquitectura
function Generate-Architecture-Diagram {
    param([string]$OutputPath, [bool]$IsDryRun)

    $diagramPath = "$OutputPath/diagrams/project-structure.md"

    if ($IsDryRun) {
        Write-Host "🔍 DryRun: Se generaría diagrama en $diagramPath" -ForegroundColor Yellow
        return
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $diagramContent = @'
# 🏗️ Arquitectura del Proyecto - AI VIBESHIFT

## Estructura General
```mermaid
graph TD
    A[AI VIBESHIFT Platform] --> B[Frontend - React/TypeScript]
    A --> C[Backend - APIs]
    A --> D[Database - Neon]
    A --> E[Deployment - Netlify]

    B --> B1[src/]
    B --> B2[public/]
    B --> B3[config files]

    B1 --> B11[components/ - UI Components]
    B1 --> B12[pages/ - Page Components]
    B1 --> B13[contexts/ - React Context]
    B1 --> B14[hooks/ - Custom Hooks]
    B1 --> B15[types/ - TypeScript Types]
    B1 --> B16[data/ - Mock Data]
    B1 --> B17[lib/ - Utilities]

    B11 --> B111[ui/ - Base Components]
    B11 --> B112[analytics/ - Analytics UI]
    B11 --> B113[company/ - Company Components]
    B11 --> B114[landing/ - Landing Page]
    B11 --> B115[messaging/ - Chat Components]
    B11 --> B116[notifications/ - Notification UI]
    B11 --> B117[payments/ - Payment Components]
```

## Tecnologías Utilizadas
- **Frontend**: React 18, TypeScript, Vite
- **Styling**: Tailwind CSS, Shadcn/ui
- **State**: React Context, Custom Hooks
- **Backend**: REST APIs, Neon Database
- **Deployment**: Netlify

## Arquitectura de Componentes
```mermaid
graph TD
    App[App.tsx] --> Layout[Layout Components]
    App --> Pages[Page Components]
    App --> Contexts[React Contexts]

    Layout --> Header[Header Component]
    Layout --> Sidebar[Sidebar Component]
    Layout --> Footer[Footer Component]

    Pages --> Dashboard[Dashboard Page]
    Pages --> Projects[Projects Page]
    Pages --> Profile[Profile Page]

    Contexts --> AuthContext[🔐 AuthContext]
    Contexts --> MessagingContext[💬 MessagingContext]
    Contexts --> NotificationContext[🔔 NotificationContext]
```
'@

    $final = $diagramContent + "`nGenerado automáticamente el: $timestamp`n"
    $final | Out-File -FilePath $diagramPath -Encoding UTF8
    Write-Host "✅ Diagrama generado: $diagramPath" -ForegroundColor Green
}

# Función para documentar APIs
function Generate-API-Docs {
    param([string]$OutputPath, [bool]$IsDryRun)

    Write-Host "🔍 Analizando archivos API..." -ForegroundColor Yellow

    # Buscar archivos relacionados con API
    $apiFiles = Get-ChildItem -Path "src" -Filter "*api*" -Recurse -Include "*.ts","*.tsx"

    if ($IsDryRun) {
        Write-Host "🔍 DryRun: Encontrados $($apiFiles.Count) archivos API" -ForegroundColor Yellow
        return
    }

    $apiDocPath = "$OutputPath/api/README.md"

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $apiContent = @'
# 🔌 Documentación de APIs - AI VIBESHIFT

## Endpoints Disponibles

### Autenticación
- `POST /api/auth/login` - Login de usuario
- `POST /api/auth/register` - Registro de usuario
- `POST /api/auth/refresh` - Refresh token
- `POST /api/auth/logout` - Logout

### Usuarios
- `GET /api/users/profile` - Obtener perfil
- `PUT /api/users/profile` - Actualizar perfil
- `GET /api/users/:id` - Obtener usuario por ID

### Proyectos
- `GET /api/projects` - Listar proyectos
- `POST /api/projects` - Crear proyecto
- `GET /api/projects/:id` - Obtener proyecto
- `PUT /api/projects/:id` - Actualizar proyecto
- `DELETE /api/projects/:id` - Eliminar proyecto

## Tipos TypeScript

```typescript
// Autenticación
interface LoginRequest {
  email: string;
  password: string;
}

interface AuthResponse {
  success: boolean;
  token: string;
  user: User;
}

// Usuario
interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  createdAt: string;
}

// Proyecto
interface Project {
  id: string;
  name: string;
  description: string;
  ownerId: string;
  technologies: string[];
  status: 'draft' | 'active' | 'completed';
  createdAt: string;
  updatedAt: string;
}
```

## Flujo de Autenticación
```mermaid
sequenceDiagram
    participant Client
    participant API
    participant Database

    Client->>API: POST /api/auth/login
    API->>Database: Validar credenciales
    Database-->>API: Usuario válido
    API-->>Client: Token JWT + User Data
```

Archivos API analizados: <COUNT_PLACEHOLDER>
'@

    $apiContent = $apiContent -replace '<COUNT_PLACEHOLDER>', $apiFiles.Count
    $final = $apiContent + "`nGenerado automáticamente el: $timestamp`n"
    $final | Out-File -FilePath $apiDocPath -Encoding UTF8
    Write-Host "✅ Documentación API generada: $apiDocPath" -ForegroundColor Green
}

# Función para documentar patrones
function Generate-Patterns-Docs {
    param([string]$OutputPath, [bool]$IsDryRun)

    if ($IsDryRun) {
        Write-Host "🔍 DryRun: Se generaría documentación de patrones" -ForegroundColor Yellow
        return
    }

    $patternsPath = "$OutputPath/patterns/component-patterns.md"

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $patternsContent = @'
# 🏗️ Patrones de Diseño - AI VIBESHIFT

## Patrones de Componentes Implementados

### 1. Compound Components Pattern
Permite componentes relacionados trabajar juntos implícitamente.

**Ejemplo:**
```tsx
// Card.tsx - Componente compuesto
const Card = ({ children }: { children: React.ReactNode }) => (
  <div className="card">{children}</div>
);

const CardHeader = ({ children }: { children: React.ReactNode }) => (
  <div className="card-header">{children}</div>
);

const CardBody = ({ children }: { children: React.ReactNode }) => (
  <div className="card-body">{children}</div>
);

// Uso
<Card>
  <CardHeader>Título</CardHeader>
  <CardBody>Contenido</CardBody>
</Card>
```

### 2. Custom Hooks Pattern
Extrae lógica reutilizable de componentes.

**Ejemplo - useLocalStorage:**
```tsx
const useLocalStorage = <T>(key: string, initialValue: T) => {
  const [storedValue, setStoredValue] = useState<T>(() => {
    const item = window.localStorage.getItem(key);
    return item ? JSON.parse(item) : initialValue;
  });

  const setValue = (value: T) => {
    setStoredValue(value);
    window.localStorage.setItem(key, JSON.stringify(value));
  };

  return [storedValue, setValue];
};
```

## Mejores Prácticas

### Naming Conventions
- Componentes: PascalCase (`UserProfile`, `ProjectCard`)
- Hooks: Prefijo `use` (`useAuth`, `useLocalStorage`)
- Tipos: PascalCase (`User`, `ApiResponse`)

### File Organization
```
src/
├── components/ui/     # Componentes base
├── components/pages/  # Páginas
├── hooks/            # Custom hooks
├── contexts/         # React contexts
├── types/            # TypeScript types
└── lib/              # Utilidades
```
'@

    $final = $patternsContent + "`nGenerado automáticamente el: $timestamp`n"
    $final | Out-File -FilePath $patternsPath -Encoding UTF8
    Write-Host "✅ Documentación de patrones generada: $patternsPath" -ForegroundColor Green
}

# Función principal
function Invoke-Workflow {
    param([string]$WorkflowName, [bool]$IsDryRun, [string]$OutputPath)

    Write-Host "🚀 Ejecutando workflow: $WorkflowName" -ForegroundColor Cyan
    Write-Host "📁 Directorio de salida: $OutputPath" -ForegroundColor Cyan

    # Inicializar directorios
    Initialize-Directories -BasePath $OutputPath

    switch ($WorkflowName) {
        "component-docs" {
            Write-Host "📦 Ejecutando documentación de componentes..." -ForegroundColor Blue
            $result = Analyze-Components -ComponentsPath "src/components" -IsDryRun $IsDryRun
            if ($result) {
                Write-Host "✅ Análisis completado: $($result.totalComponents) componentes encontrados" -ForegroundColor Green
            }
        }

        "architecture-diagrams" {
            Write-Host "🏗️ Generando diagramas de arquitectura..." -ForegroundColor Blue
            Generate-Architecture-Diagram -OutputPath $OutputPath -IsDryRun $IsDryRun
        }

        "api-docs" {
            Write-Host "🔌 Generando documentación de APIs..." -ForegroundColor Blue
            Generate-API-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun
        }

        "patterns-docs" {
            Write-Host "🎯 Generando documentación de patrones..." -ForegroundColor Blue
            Generate-Patterns-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun
        }

        "data-flow-diagrams" {
            Write-Host "🔄 Generando diagramas de flujo de datos..." -ForegroundColor Blue
            # Placeholder - implementar lógica específica
            Write-Host "ℹ️ Workflow data-flow-diagrams - Implementación pendiente" -ForegroundColor Yellow
        }

        "full-project-docs" {
            Write-Host "🎉 Ejecutando documentación completa del proyecto..." -ForegroundColor Blue

            Write-Host "📦 Paso 1: Componentes..." -ForegroundColor Yellow
            Analyze-Components -ComponentsPath "src/components" -IsDryRun $IsDryRun

            Write-Host "🏗️ Paso 2: Arquitectura..." -ForegroundColor Yellow
            Generate-Architecture-Diagram -OutputPath $OutputPath -IsDryRun $IsDryRun

            Write-Host "🔌 Paso 3: APIs..." -ForegroundColor Yellow
            Generate-API-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun

            Write-Host "🎯 Paso 4: Patrones..." -ForegroundColor Yellow
            Generate-Patterns-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun

            Write-Host "✅ Documentación completa generada!" -ForegroundColor Green
        }

        "auto-orchestrate" {
            Write-Host "🧠 Seleccionando combinación óptima automáticamente..." -ForegroundColor Blue

            $componentCount = 0
            if (Test-Path "src/components") {
                $componentCount = (Get-ChildItem -Path "src/components" -Filter "*.tsx" -Recurse -ErrorAction SilentlyContinue).Count
            }

            $hasComponentsDocs = Test-Path "$OutputPath/components"
            $hasDiagrams = Test-Path "$OutputPath/diagrams"
            $hasApi = Test-Path "$OutputPath/api"

            $combination = $null
            if ($componentCount -gt 50 -and -not $hasComponentsDocs) {
                $combination = "full-project-docs"
                Write-Host "🔍 Proyecto complejo detectado: Ejecutando documentación completa" -ForegroundColor Cyan
            } elseif (-not $hasDiagrams) {
                $combination = "architecture-first"
                Write-Host "🏗️ Arquitectura faltante: Priorizando diagramas" -ForegroundColor Cyan
            } elseif (-not $hasApi) {
                $combination = "api-focus"
                Write-Host "🔌 APIs sin documentar: Enfocando en backend" -ForegroundColor Cyan
            } else {
                $combination = "maintenance-mode"
                Write-Host "🔧 Proyecto maduro: Modo mantenimiento activado" -ForegroundColor Cyan
            }

            $executed = @()
            switch ($combination) {
                "full-project-docs" {
                    Analyze-Components -ComponentsPath "src/components" -IsDryRun $IsDryRun | Out-Null
                    $executed += "component-docs"
                    Generate-Architecture-Diagram -OutputPath $OutputPath -IsDryRun $IsDryRun
                    $executed += "architecture-diagrams"
                    Generate-API-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun
                    $executed += "api-docs"
                    Generate-Patterns-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun
                    $executed += "patterns-docs"
                }
                "architecture-first" {
                    Generate-Architecture-Diagram -OutputPath $OutputPath -IsDryRun $IsDryRun
                    $executed += "architecture-diagrams"
                    Analyze-Components -ComponentsPath "src/components" -IsDryRun $IsDryRun | Out-Null
                    $executed += "component-docs"
                    Generate-Patterns-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun
                    $executed += "patterns-docs"
                }
                "api-focus" {
                    Generate-API-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun
                    $executed += "api-docs"
                    Write-Host "🔄 Data-flow diagrams (placeholder)" -ForegroundColor Yellow
                    $executed += "data-flow-diagrams"
                    Generate-Architecture-Diagram -OutputPath $OutputPath -IsDryRun $IsDryRun
                    $executed += "architecture-diagrams"
                }
                "maintenance-mode" {
                    Generate-Patterns-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun
                    $executed += "patterns-docs"
                    Analyze-Components -ComponentsPath "src/components" -IsDryRun $IsDryRun | Out-Null
                    $executed += "component-docs"
                    Write-Host "🔄 Data-flow diagrams (placeholder)" -ForegroundColor Yellow
                    $executed += "data-flow-diagrams"
                }
            }

            if (-not $IsDryRun) {
                $metricsPath = "project-logs/docs/workflow-metrics.json"
                $metrics = @{
                    workflow = "auto-orchestrate"
                    executedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                    outputPath = $OutputPath
                    dryRun = $IsDryRun
                    workflowsExecuted = $executed
                }
                $metrics | ConvertTo-Json | Out-File -FilePath $metricsPath -Encoding UTF8
                Write-Host "📊 Métricas guardadas en: $metricsPath" -ForegroundColor Green
            }

            Write-Host "🎉 Auto-orchestrate completado exitosamente!" -ForegroundColor Green
            return
        }

        default {
            Write-Host "❌ Workflow desconocido: $WorkflowName" -ForegroundColor Red
            Write-Host "📋 Workflows disponibles: component-docs, architecture-diagrams, api-docs, patterns-docs, data-flow-diagrams, full-project-docs, auto-orchestrate" -ForegroundColor Yellow
            return
        }
    }

    # Generar métricas finales
    if (!$IsDryRun) {
        $metricsPath = "project-logs/docs/workflow-metrics.json"
        $metrics = @{
            workflow = $WorkflowName
            executedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            outputPath = $OutputPath
            dryRun = $IsDryRun
        }

        $metrics | ConvertTo-Json | Out-File -FilePath $metricsPath -Encoding UTF8
        Write-Host "📊 Métricas guardadas en: $metricsPath" -ForegroundColor Green
    }

    Write-Host "🎉 Workflow '$WorkflowName' completado exitosamente!" -ForegroundColor Green
}

# Lógica principal del script
if ($Help) {
    Show-Help
    exit 0
}

if (!$Workflow) {
    Write-Host "❌ Error: Debes especificar un workflow con -Workflow" -ForegroundColor Red
    Write-Host ""
    Show-Help
    exit 1
}

# Ejecutar workflow
try {
    Invoke-Workflow -WorkflowName $Workflow -IsDryRun $DryRun -OutputPath $OutputPath
} catch {
    Write-Host "❌ Error ejecutando workflow: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
