# Neon Database Plugin
# Plugin para configurar base de datos Neon

param(
    [string]$TargetDir = "server",
    [string]$SchemaName = "schema"
)

function Configure-NeonDatabase {
    param(
        [string]$TargetDir = "server",
        [string]$SchemaName = "schema"
    )

    Write-Host "🗄️ Configurando Neon Database en $TargetDir"

    Push-Location $TargetDir

    # Instalar dependencias si no están
    if (!(Test-Path "node_modules")) {
        npm install @neondatabase/serverless drizzle-orm
        npm install -D drizzle-kit
    }

    # Crear esquema base
    $schemaContent = @"
import { pgTable, serial, text, timestamp } from 'drizzle-orm/pg-core'
import { createInsertSchema } from 'drizzle-zod'
import { z } from 'zod'

// Users table
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: text('email').notNull().unique(),
  name: text('name'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
})

// Insert schema
export const insertUserSchema = createInsertSchema(users).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
})

// Export types
export type User = typeof users.$inferSelect
export type NewUser = typeof insertUserSchema._type
"@

    $schemaContent | Out-File -Encoding UTF8 "src/schemas/$SchemaName.ts"

    # Crear drizzle.config.ts si no existe
    if (!(Test-Path "drizzle.config.ts")) {
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

    # Crear archivo de conexión DB
    $dbContent = @"
import { neon } from '@neondatabase/serverless'
import { drizzle } from 'drizzle-orm/neon-http'

// Create connection
const sql = neon(process.env.DATABASE_URL!)
export const db = drizzle(sql)

// Export for use in routes
export default db
"@

    $dbContent | Out-File -Encoding UTF8 "src/lib/db.ts"

    Pop-Location

    Write-Host "✅ Neon Database configurado en $TargetDir"
    Write-Host "🗄️ Para generar migraciones: cd $TargetDir && npm run db:generate"
    Write-Host "🗄️ Para aplicar: cd $TargetDir && npm run db:migrate"
}

# Ejecutar si se llama directamente
Configure-NeonDatabase -TargetDir $TargetDir -SchemaName $SchemaName
