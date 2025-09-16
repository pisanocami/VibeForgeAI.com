# Guía Completa para Crear MVPs

## 🎯 Visión General

Esta guía te lleva paso a paso para crear **Minimum Viable Products (MVPs)** completos usando los workflows automatizados de MVP-Core. Genera aplicaciones web empresariales listas para desarrollo desde documentos estratégicos o requerimientos en texto.

### ¿Qué Genera?

**NO** apps de consola simples, sino **aplicaciones web completas**:
- **Frontend**: React + Vite + TypeScript + Tailwind + shadcn/ui
- **Backend**: Fastify/Express + Drizzle ORM + PostgreSQL (Neon)
- **Docs**: PRD, API docs, diagramas de arquitectura
- **Infra**: Configuración de BD, variables de entorno, Docker-ready

### Arquitectura de Plugins

Usa arquitectura modular extensible:
- **Orquestador**: Coordina la ejecución
- **Plugins**: Módulos especializados (frontend, backend, integrations)
- **Templates**: Estructuras reutilizables
- **AutoParse**: Interpreta requerimientos en lenguaje natural

---

## 📋 Prerrequisitos

### Sistema
- **Node.js 18+** y **npm**
- **Windows PowerShell** (para ejecución automática)
- **Git** (opcional, para control de versiones)

### Servicios Externos (para features avanzadas)
- **Notion** (publicación de docs): `NOTION_TOKEN` + `NOTION_WORKSPACE_PAGE_ID`
- **Neon Postgres** (base de datos): Connection string
- **Clerk Auth** (autenticación): API keys
- **Google Gemini AI** (features IA): API key

### Configuración Inicial
```powershell
# Crear directorios base (automático en workflows)
New-Item -ItemType Directory -Force -Path docs/mvp, project-logs/mvp, temp/pdf-extraction

# Variables de entorno (opcional, crear .env)
$env:NOTION_TOKEN = "tu-token"
$env:DATABASE_URL = "postgresql://..."
```

---

## 🚀 Flujo de Creación de MVP

### Opción 1: Desde Documento Estratégico PDF (Recomendado)

#### Paso 1: Extraer Requerimientos del PDF
```powershell
# Entrada por PDF estratégico (recomendado)
$env:PDF_SOURCE = "c:\ruta\a\tu-documento.pdf"
.\n+\run-mvp.ps1
```

**Qué hace:**
- Crea un nuevo directorio de proyecto (`PROJECT_ROOT`) único por ejecución
- Extrae texto del PDF
- Analiza contenido con IA
- Genera documentación PRD dentro de `PROJECT_ROOT`
- Crea `[PROJECT_ROOT]/docs/mvp/REQUEST.txt` para el builder y exporta `PROJECT_ROOT`

#### Paso 2: Generar Código Completo
```powershell
# Ejecutar orquestador principal (wrapper de Windows)
.\n+\run-mvp.ps1
```

**Artefactos generados:**
```
tu-proyecto-mvp/
├── client/              # Frontend React+Vite
├── server/              # Backend Fastify+Drizzle
├── docs/mvp/            # Documentación completa
├── project-logs/        # Logs de ejecución
├── docker-compose.yml   # Configuración de servicios
└── README.md           # Guía del proyecto
```

### Opción 2: Desde Requerimientos en Texto

#### Paso 1: Definir Requerimientos
```powershell
# Variable de entorno
$env:MVP_REQUEST = "Landing page con autenticación, dashboard de usuario, API REST con PostgreSQL"

# O archivo
@"
MVP: Aplicación web con:
- Frontend React moderno
- Backend Node.js con Express
- Base de datos PostgreSQL
- Autenticación básica
"@ | Out-File -Encoding UTF8 -FilePath docs/mvp/REQUEST.txt
```

#### Paso 2: Configurar Tecnologías (Opcional)
```powershell
# Override automático
$env:FRONTEND_TECH = "react-vite"
$env:BACKEND_TECH = "fastify"
$env:DB = "neon-postgres"
$env:AUTH = "clerk"
```

#### Paso 3: Generar MVP
```powershell
./run-mvp.ps1
```

### Opción 3: Usando Arquitectura de Plugins (Avanzado)

#### Paso 1: Configurar Plugins
```powershell
# El orquestador nuevo permite control granular
cd .windsurf/workflows/MVP/core
. ./orchestrator.ps1

Start-MVPBuilder -Config @{
    plugins = @("docs", "frontend", "backend", "security")
    frontend_tech = "react-vite-enterprise"
    backend_tech = "express-drizzle"
    features = @("auth", "multi-tenant", "ai-integration")
}
```

---

## ⚙️ Tecnologías Soportadas

### Frontend
- **React + Vite** (por defecto): Modern stack con HMR
- **Next.js**: SSR/SSG para SEO
- **Angular**: Enterprise-grade framework
- **SvelteKit**: Performance optimizada

### Backend
- **Fastify** (por defecto): Alto performance, bajo overhead
- **Express + Drizzle**: Flexible con ORM moderno
- **NestJS**: Arquitectura enterprise
- **Hono**: Edge/serverless ready

### Base de Datos
- **Neon Postgres** (por defecto): Serverless, escalable
- **SQLite**: Desarrollo local rápido
- **MongoDB**: Documentos flexibles

### Integraciones
- **Clerk Auth**: Autenticación enterprise
- **Google Gemini AI**: Features inteligentes
- **Notion**: Documentación viva
- **Docker**: Containerización automática

---

## 🎛️ Control de Ejecución

### Módulos Seleccionables
```powershell
# Solo documentación
$env:SELECT = "docs,diagrams"

# MVP mínimo
$env:SELECT = "docs,frontend,backend"

# Full enterprise
$env:SELECT = "docs,frontend,backend,diagrams,security"
```

### Variables de Override
```powershell
# Forzar tecnologías específicas
$env:FRONTEND_TECH = "nextjs"
$env:BACKEND_TECH = "nest"
$env:DB = "mongodb"
$env:AUTH = "clerk"
$env:AI = "gemini"
```

### Modo AutoRun
Los workflows incluyen anotaciones `// turbo` para ejecución automática sin prompts manuales.

---

## 📁 Estructura Final del Proyecto

Después de ejecutar `/mvp-builder`:

```
mi-mvp-proyecto/
├── client/                         # Frontend Application
│   ├── src/
│   │   ├── components/            # UI Components (shadcn/ui)
│   │   ├── pages/                 # Application Pages
│   │   ├── hooks/                 # React Hooks
│   │   ├── lib/                   # Utilities & API Client
│   │   └── types/                 # TypeScript Definitions
│   ├── package.json
│   ├── vite.config.ts
│   ├── tailwind.config.js
│   └── index.html
│
├── server/                         # Backend API
│   ├── src/
│   │   ├── routes/                # API Endpoints
│   │   ├── plugins/               # Fastify Plugins
│   │   ├── lib/                   # Database & Utils
│   │   ├── schemas/               # Drizzle Schemas
│   │   └── services/              # Business Logic
│   ├── package.json
│   ├── drizzle.config.ts
│   └── tsconfig.json
│
├── docs/mvp/                       # Documentation
│   ├── prd/README.md              # Product Requirements
│   ├── api/README.md              # API Documentation
│   ├── diagrams/                  # Architecture Diagrams
│   └── REQUEST.txt                # Original Requirements
│
├── project-logs/mvp/               # Execution Logs
│   └── logs/
│       └── run-*.md               # Detailed Execution Logs
│
├── docker-compose.yml              # Local Development
├── .env.example                   # Environment Variables
├── .gitignore                     # Git Ignore
└── README.md                      # Project Documentation
```

---

## 🔧 Inicio y Desarrollo

### Primer Arranque
```powershell
cd mi-mvp-proyecto

# Instalar dependencias
cd client && npm install
cd ../server && npm install

# Configurar base de datos
cd server
npm run db:generate  # Generar migraciones
npm run db:migrate   # Aplicar a BD

# Iniciar desarrollo
npm run dev          # Backend (puerto 3001)
# En otra terminal:
cd ../client && npm run dev  # Frontend (puerto 5173)
```

### Variables de Entorno
```bash
# .env
DATABASE_URL=postgresql://user:pass@host:5432/db
CLERK_SECRET_KEY=sk_test_...
GOOGLE_AI_API_KEY=AIza...
NOTION_TOKEN=secret_...
```

---

## 🐛 Troubleshooting

### "Command not found"
```powershell
# Verificar que estás en el directorio correcto
cd c:\Users\admin\OneDrive\Escritorio\mvp-core

# Usa el wrapper de Windows
$env:PDF_SOURCE = "c:\ruta\a\tu-documento.pdf"
./run-mvp.ps1
```

### "PDF extraction failed"
- Verificar que el PDF no esté encriptado
- Usar archivos PDF válidos (no imágenes escaneadas)
- El workflow simula extracción si no hay pdftotext instalado

### "Build failed"
```powershell
# Limpiar configuración previa
Remove-Item project-logs/mvp/intake/latest.json -ErrorAction SilentlyContinue

# Reintentar
./run-mvp.ps1
```

### "Database connection failed"
- Verificar `DATABASE_URL` en `.env`
- Para Neon: Crear proyecto en neon.tech
- Para local: Usar SQLite cambiando `DB=sqlite`
```

---

## 📚 Ejemplos Completos

### Ejemplo 1: SaaS Dashboard
```powershell
$env:MVP_REQUEST = "Dashboard SaaS multi-tenant con autenticación, gestión de usuarios, analytics en tiempo real, integración con IA para insights"
$env:FRONTEND_TECH = "react-vite-enterprise"
$env:BACKEND_TECH = "fastify"
$env:DB = "neon-postgres"
$env:AUTH = "clerk"
./run-mvp.ps1
```

### Ejemplo 2: Marketplace
```powershell
$env:MVP_REQUEST = "Plataforma de marketplace B2B con catálogo de productos, gestión de vendedores, pagos integrados, panel de administración"
$env:FRONTEND_TECH = "nextjs"
$env:BACKEND_TECH = "express-drizzle"
$env:FEATURES = "payments,admin-panel"
./run-mvp.ps1
```

### Ejemplo 3: App Interna
```powershell
$env:MVP_REQUEST = "Aplicación interna para gestión de proyectos con kanban board, time tracking, reportes PDF, integración con Slack"
$env:SELECT = "frontend,backend,docs"  # Sin auth enterprise
$env:FRONTEND_TECH = "react-vite"
$env:BACKEND_TECH = "fastify"
./run-mvp.ps1
```

---

## 🔄 Ciclo de Desarrollo

### Iteración Rápida
1. **Modificar requerimientos** en `[PROJECT_ROOT]/docs/mvp/REQUEST.txt`
2. **Re-ejecutar** `./run-mvp.ps1` (sobrescribe código)
3. **Mantener** base de datos y configuración existente

### Backup y Recovery
```powershell
# Crear checkpoint antes de cambios grandes
# (Implementado en plugins para versiones futuras)

# Rollback si algo falla
# Restaurar desde backup automático
```

### Escalado
- **Agregar features**: Modificar REQUEST.txt + re-ejecutar
- **Cambiar tecnologías**: Override con variables de entorno
- **Añadir módulos**: `SELECT="docs,frontend,backend,security"`

---

## 🎉 Éxito y Próximos Pasos

### Verificación de MVP Completado
- ✅ **Directorio creado** con estructura completa
- ✅ **Frontend corriendo** en localhost:5173
- ✅ **Backend API** respondiendo en localhost:3001
- ✅ **Base de datos** conectada y migrada
- ✅ **Documentación** completa generada

### Deploy y Producción
```powershell
# Configurar producción
# - Variables de entorno de prod
# - Build optimizado: npm run build
# - Deploy a Vercel/Netlify + Railway/Render
# - CI/CD con GitHub Actions incluidos
```

### Soporte y Comunidad
- **Documentación**: `.windsurf/workflows/MVP/README.md`
- **Logs detallados**: `project-logs/mvp/logs/`
- **Configuración**: `mvp.config.json`

---

*Esta guía se actualiza automáticamente con nuevas features. Última actualización: 2025-09-16*
