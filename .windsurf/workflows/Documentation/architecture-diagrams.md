---
description: Documentation — Architecture Diagrams (system, data flow, component relationships)
category: documentation
stability: stable
---

# Documentation — Architecture Diagrams

Genera diagramas visuales completos de la arquitectura del sistema usando Mermaid, incluyendo estructura del proyecto, flujo de datos y relaciones entre componentes.

Related: `/documentation/component-docs`, `/documentation/api-docs`, `/documentation/data-flow-diagrams`

## Objetivo
Crear documentación visual completa de la arquitectura con:
- Diagrama de estructura del proyecto
- Arquitectura de componentes React
- Flujo de datos y estado
- Arquitectura de API y servicios
- Relaciones entre módulos

## Entradas
- Estructura del proyecto: `src/`, `public/`, `scripts/`
- Archivos de configuración: `package.json`, `vite.config.ts`, etc.
- Documentos existentes: `ARCHITECTURE.md`, `API.md`

## Preflight (Windows PowerShell) — seguro para auto‑ejecutar
// turbo
```powershell
$paths = @('docs/diagrams','docs/architecture','project-logs/diagrams')
$paths | ForEach-Object { if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ | Out-Null } }
```

## Pasos

### 1) Análisis de Arquitectura del Proyecto
Escanea la estructura completa para identificar:
- Arquitectura general (Vite + React + TypeScript)
- Estructura de carpetas y módulos
- Dependencias principales
- Configuraciones críticas

### 2) Diagrama de Estructura del Proyecto
Genera diagrama jerárquico completo:
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

    B2 --> B21[brand/ - Brand Assets]
    B2 --> B22[favicon.ico]
    B2 --> B23[robots.txt]
```

### 3) Diagrama de Arquitectura de Componentes
Muestra jerarquía y relaciones entre componentes:
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

    Contexts --> Auth[AuthContext]
    Contexts --> Messaging[MessagingContext]
    Contexts --> Notification[NotificationContext]

    Dashboard --> Analytics[Analytics Components]
    Projects --> ProjectList[ProjectList Component]
    Projects --> ProjectCard[ProjectCard Component]
```

### 4) Diagrama de Flujo de Datos
Ilustra cómo fluyen los datos en la aplicación:
```mermaid
flowchart TD
    User[👤 User] --> UI[🎨 UI Components]
    UI --> Actions[⚡ Actions/Events]
    Actions --> Context[📱 React Context]
    Context --> API[🌐 API Calls]
    API --> Backend[⚙️ Backend Services]
    Backend --> Database[(💾 Database)]

    Database --> Backend
    Backend --> API
    API --> Context
    Context --> UI
    UI --> User

    Context -.-> LocalStorage[(💻 Local Storage)]
    Context -.-> SessionStorage[(📋 Session Storage)]
```

### 5) Diagrama de Arquitectura de Estado
Muestra gestión de estado global:
```mermaid
stateDiagram-v2
    [*] --> Idle

    Idle --> Loading : User Action
    Loading --> Success : API Success
    Loading --> Error : API Error

    Success --> Idle : Reset
    Error --> Idle : Retry/Reset

    note right of Loading
        Show loading spinner
        Disable interactions
    end note

    note right of Success
        Update UI with data
        Show success message
    end note

    note right of Error
        Show error message
        Enable retry option
    end note
```

### 6) Diagrama de Dependencias
Muestra relaciones entre módulos y paquetes:
```mermaid
graph TD
    subgraph "Core Dependencies"
        React[React 18+]
        TypeScript[TypeScript]
        Vite[Vite]
    end

    subgraph "UI Libraries"
        TailwindCSS[Tailwind CSS]
        ShadcnUI[Shadcn/ui]
        Lucide[Lucide Icons]
    end

    subgraph "State Management"
        ReactContext[React Context]
        Zustand[Zustand]
    end

    subgraph "HTTP Client"
        Axios[Axios]
        Fetch[Native Fetch]
    end

    subgraph "Forms & Validation"
        ReactHookForm[React Hook Form]
        Zod[Zod]
    end

    React --> TypeScript
    React --> Vite
    TailwindCSS --> ShadcnUI
    ShadcnUI --> Lucide
    React --> ReactContext
    ReactContext --> Zustand
    React --> Axios
    Axios --> Fetch
    React --> ReactHookForm
    ReactHookForm --> Zod
```

## Artefactos
- `docs/diagrams/project-structure.md` — Estructura del proyecto
- `docs/diagrams/component-architecture.md` — Arquitectura de componentes
- `docs/diagrams/data-flow.md` — Flujo de datos
- `docs/diagrams/state-management.md` — Gestión de estado
- `docs/diagrams/dependencies.md` — Dependencias del proyecto
- `docs/architecture/README.md` — Documento principal de arquitectura
- `project-logs/diagrams/architecture-analysis.json` — Análisis técnico

## Status JSON (ejemplo)
```json
{
  "diagramsGenerated": 5,
  "totalComponents": 74,
  "architectureLayers": 4,
  "dataFlowsMapped": 12,
  "dependenciesAnalyzed": 15,
  "status": "completed",
  "artifacts": [
    "docs/diagrams/project-structure.md",
    "docs/diagrams/component-architecture.md",
    "docs/diagrams/data-flow.md"
  ],
  "timestamp": "${ISO_TIMESTAMP}"
}
```

## Aceptación (Done)
- Diagramas Mermaid funcionales y legibles
- Cobertura completa de la arquitectura
- Relaciones claras entre componentes
- Flujo de datos documentado
- Dependencias mapeadas

## Dry‑run
- `--dryRun` genera previews sin crear archivos
- Valida sintaxis Mermaid antes de guardar
