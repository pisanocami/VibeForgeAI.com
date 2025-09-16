# Fastify Plugin
# Plugin para scaffold de backend con Fastify

param(
    [string]$TargetDir = "server",
    [string]$Database = "neon",
    [switch]$TypeScript = $true
)

function Install-FastifyBackend {
    param(
        [string]$TargetDir = "server",
        [string]$Database = "neon",
        [bool]$TypeScript = $true
    )

    Write-Host "🚀 Instalando Fastify backend en $TargetDir"

    # Crear directorio si no existe
    if (!(Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }

    Push-Location $TargetDir

    # Inicializar package.json
    npm init -y

    # Instalar Fastify y dependencias base
    npm install fastify @fastify/cors @fastify/helmet
    npm install -D nodemon

    # Instalar base de datos
    switch ($Database) {
        "neon" {
            Write-Host "🗄️ Configurando Neon Postgres"
            npm install @neondatabase/serverless drizzle-orm
            npm install -D drizzle-kit
        }
        "sqlite" {
            Write-Host "🗄️ Configurando SQLite"
            npm install better-sqlite3 drizzle-orm
            npm install -D drizzle-kit
        }
        default {
            Write-Warning "⚠️ Base de datos '$Database' no soportada, usando Neon por defecto"
            npm install @neondatabase/serverless drizzle-orm
            npm install -D drizzle-kit
        }
    }

    # Instalar dependencias comunes
    npm install zod dotenv

    # Crear estructura de directorios
    $dirs = @("src", "src/routes", "src/plugins", "src/lib", "src/schemas", "migrations")
    foreach ($dir in $dirs) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    # Crear archivos base
    $serverContent = @"
import Fastify from 'fastify'
import cors from '@fastify/cors'
import helmet from '@fastify/helmet'
import dotenv from 'dotenv'

// Load environment variables
dotenv.config()

const server = Fastify({
  logger: true
})

// Register plugins
await server.register(cors)
await server.register(helmet)

// Health check route
server.get('/health', async (request, reply) => {
  return { status: 'ok', timestamp: new Date().toISOString() }
})

// API routes
server.get('/api/v1', async (request, reply) => {
  return { message: 'MVP API v1' }
})

// Start server
const start = async () => {
  try {
    await server.listen({ port: process.env.PORT || 3001, host: '0.0.0.0' })
  } catch (err) {
    server.log.error(err)
    process.exit(1)
  }
}

start()
"@

    if ($TypeScript) {
        $serverContent | Out-File -Encoding UTF8 "src/server.ts"
        npm install -D typescript @types/node tsx
    } else {
        $serverContent | Out-File -Encoding UTF8 "src/server.js"
    }

    # Crear .env.example
    $envContent = @"
PORT=3001
DATABASE_URL=your-database-url-here
NODE_ENV=development
"@
    $envContent | Out-File -Encoding UTF8 ".env.example"

    # Crear drizzle.config.ts si es TypeScript
    if ($TypeScript) {
        $drizzleConfig = @"
import { defineConfig } from 'drizzle-kit'

export default defineConfig({
  schema: './src/schemas/*.ts',
  out: './migrations',
  dialect: 'postgresql',
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
})
"@
        $drizzleConfig | Out-File -Encoding UTF8 "drizzle.config.ts"
    }

    # Actualizar package.json scripts
    $packageJson = Get-Content "package.json" -Encoding UTF8 | ConvertFrom-Json
    $packageJson.scripts = @{
        "dev" = if ($TypeScript) { "tsx watch src/server.ts" } else { "nodemon src/server.js" }
        "start" = if ($TypeScript) { "tsx src/server.ts" } else { "node src/server.js" }
        "build" = if ($TypeScript) { "tsc" } else { "echo 'No build step for JS'" }
        "db:generate" = "drizzle-kit generate"
        "db:migrate" = "drizzle-kit migrate"
        "db:push" = "drizzle-kit push"
    }
    $packageJson | ConvertTo-Json -Depth 10 | Out-File -Encoding UTF8 "package.json"

    Pop-Location

    Write-Host "✅ Backend Fastify instalado en $TargetDir"
    Write-Host "🚀 Para iniciar: cd $TargetDir && npm run dev"
}

# Ejecutar si se llama directamente
Install-FastifyBackend -TargetDir $TargetDir -Database $Database -TypeScript $TypeScript
