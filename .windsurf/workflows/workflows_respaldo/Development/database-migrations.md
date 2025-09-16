---
description: Database Migrations - Gestión de cambios en esquemas de BD
---

# Database Migrations Workflow

Sistema completo para gestionar cambios en esquemas de base de datos de forma segura y versionada.

## Pre-requisitos
- Base de datos configurada (PostgreSQL, MySQL, MongoDB, etc.)
- ORM o herramienta de migraciones (Prisma, TypeORM, Flyway, etc.)
- Ambiente de desarrollo con permisos de modificación de BD
- Equipo alineado en estrategia de migraciones

## Pasos del Workflow

### 1. Configuración de Herramientas de Migración
```javascript
// prisma/schema.prisma (ejemplo con Prisma)
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

```javascript
// Configuración de TypeORM
// src/config/database.ts
import { DataSource } from 'typeorm'

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '5432'),
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  synchronize: false, // NUNCA true en producción
  logging: process.env.NODE_ENV === 'development',
  entities: ['src/entities/**/*.ts'],
  migrations: ['src/migrations/**/*.ts'],
  subscribers: ['src/subscribers/**/*.ts'],
})
```

### 2. Creación de Migraciones
```bash
# Con Prisma
npx prisma migrate dev --name add-user-table

# Con TypeORM
npm run typeorm migration:create -- -n AddUserTable

# Con Flyway (SQL puro)
# Crear archivo SQL en migrations/V1__add_user_table.sql
```

```sql
-- migrations/V1__add_user_table.sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
```

```javascript
// migrations/001-add-user-table.ts (TypeORM)
import { MigrationInterface, QueryRunner, Table } from 'typeorm'

export class AddUserTable001 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'users',
        columns: [
          {
            name: 'id',
            type: 'int',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'increment',
          },
          {
            name: 'email',
            type: 'varchar',
            length: '255',
            isUnique: true,
          },
          {
            name: 'name',
            type: 'varchar',
            length: '255',
            isNullable: true,
          },
          {
            name: 'createdAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
          {
            name: 'updatedAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
        ],
      }),
    )

    // Crear índices
    await queryRunner.createIndex(
      'users',
      new TableIndex({
        name: 'IDX_USERS_EMAIL',
        columnNames: ['email'],
      }),
    )
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropIndex('users', 'IDX_USERS_EMAIL')
    await queryRunner.dropTable('users')
  }
}
```

### 3. Scripts de Automatización
```json
// package.json scripts para migraciones
{
  "scripts": {
    "db:generate": "prisma generate",
    "db:migrate": "prisma migrate deploy",
    "db:migrate:dev": "prisma migrate dev",
    "db:migrate:reset": "prisma migrate reset",
    "db:seed": "tsx prisma/seed.ts",
    "db:studio": "prisma studio",
    "db:push": "prisma db push",
    "db:pull": "prisma db pull",
    "db:diff": "prisma migrate diff",
    "db:status": "prisma migrate status"
  }
}
```

```javascript
// scripts/database-migration.js
const { execSync } = require('child_process')
const fs = require('fs')

class DatabaseMigrationManager {
  constructor() {
    this.environments = ['development', 'staging', 'production']
  }

  // Crear nueva migración
  createMigration(name, type = 'prisma') {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-')
    const migrationName = `${timestamp}-${name}`

    if (type === 'prisma') {
      execSync(`npx prisma migrate dev --name ${migrationName}`)
    } else if (type === 'typeorm') {
      execSync(`npm run typeorm migration:create -- -n ${migrationName}`)
    }

    console.log(`✅ Migration created: ${migrationName}`)
    return migrationName
  }

  // Ejecutar migraciones
  async runMigrations(environment = 'development') {
    console.log(`🚀 Running migrations for ${environment}...`)

    // Set environment variables
    process.env.NODE_ENV = environment

    try {
      if (fs.existsSync('prisma/schema.prisma')) {
        // Prisma
        execSync('npx prisma migrate deploy', { stdio: 'inherit' })
      } else if (fs.existsSync('src/migrations')) {
        // TypeORM
        execSync('npm run typeorm migration:run', { stdio: 'inherit' })
      } else {
        // Custom migrations
        await this.runCustomMigrations(environment)
      }

      console.log(`✅ Migrations completed for ${environment}`)
    } catch (error) {
      console.error(`❌ Migration failed: ${error.message}`)
      throw error
    }
  }

  // Revertir migraciones
  async rollbackMigrations(steps = 1, environment = 'development') {
    console.log(`⏪ Rolling back ${steps} migration(s) for ${environment}...`)

    process.env.NODE_ENV = environment

    try {
      if (fs.existsSync('prisma/schema.prisma')) {
        // Prisma - necesita revertir manualmente
        console.log('⚠️ Prisma requires manual rollback. Use: npx prisma migrate reset')
      } else if (fs.existsSync('src/migrations')) {
        // TypeORM
        execSync(`npm run typeorm migration:revert -- -n ${steps}`, { stdio: 'inherit' })
      }

      console.log(`✅ Rollback completed for ${environment}`)
    } catch (error) {
      console.error(`❌ Rollback failed: ${error.message}`)
      throw error
    }
  }

  // Verificar estado de migraciones
  checkMigrationStatus(environment = 'development') {
    console.log(`📊 Checking migration status for ${environment}...`)

    process.env.NODE_ENV = environment

    try {
      let status
      if (fs.existsSync('prisma/schema.prisma')) {
        status = execSync('npx prisma migrate status', { encoding: 'utf8' })
      } else if (fs.existsSync('src/migrations')) {
        status = execSync('npm run typeorm migration:show', { encoding: 'utf8' })
      }

      console.log('Migration Status:')
      console.log(status)

      return status
    } catch (error) {
      console.error(`❌ Failed to check migration status: ${error.message}`)
      return null
    }
  }

  // Crear backup antes de migrar
  async createBackup(environment = 'production') {
    console.log(`💾 Creating database backup for ${environment}...`)

    const timestamp = new Date().toISOString().replace(/[:.]/g, '-')
    const backupFile = `backup-${environment}-${timestamp}.sql`

    try {
      // Para PostgreSQL
      execSync(`pg_dump ${process.env.DATABASE_URL} > ${backupFile}`)

      console.log(`✅ Backup created: ${backupFile}`)
      return backupFile
    } catch (error) {
      console.error(`❌ Backup failed: ${error.message}`)
      throw error
    }
  }

  // Validar migraciones
  async validateMigrations() {
    console.log('🔍 Validating migrations...')

    const issues = []

    // Verificar que las migraciones tienen up y down
    if (fs.existsSync('src/migrations')) {
      const migrationFiles = fs.readdirSync('src/migrations')
        .filter(file => file.endsWith('.ts'))

      for (const file of migrationFiles) {
        const content = fs.readFileSync(`src/migrations/${file}`, 'utf8')

        if (!content.includes('public async up(')) {
          issues.push(`${file}: Missing up() method`)
        }

        if (!content.includes('public async down(')) {
          issues.push(`${file}: Missing down() method`)
        }
      }
    }

    // Verificar que no hay cambios pendientes en el schema
    if (fs.existsSync('prisma/schema.prisma')) {
      try {
        execSync('npx prisma migrate diff --from-schema-datamodel --to-schema-datamodel --exit-code', { stdio: 'pipe' })
      } catch (error) {
        if (error.status === 2) {
          issues.push('Schema changes detected that are not reflected in migrations')
        }
      }
    }

    if (issues.length > 0) {
      console.log('❌ Migration validation issues found:')
      issues.forEach(issue => console.log(`  - ${issue}`))
      return false
    }

    console.log('✅ All migrations validated')
    return true
  }

  // Ejecutar seeds
  async runSeeds(environment = 'development') {
    console.log(`🌱 Running database seeds for ${environment}...`)

    process.env.NODE_ENV = environment

    try {
      if (fs.existsSync('prisma/seed.ts')) {
        execSync('npx tsx prisma/seed.ts', { stdio: 'inherit' })
      } else if (fs.existsSync('src/database/seeds')) {
        // Custom seed files
        const seedFiles = fs.readdirSync('src/database/seeds')
          .filter(file => file.endsWith('.ts'))

        for (const file of seedFiles) {
          execSync(`npx tsx src/database/seeds/${file}`, { stdio: 'inherit' })
        }
      }

      console.log(`✅ Seeds completed for ${environment}`)
    } catch (error) {
      console.error(`❌ Seeding failed: ${error.message}`)
      throw error
    }
  }
}

// CLI interface
const args = process.argv.slice(2)
const manager = new DatabaseMigrationManager()

switch (args[0]) {
  case 'create':
    manager.createMigration(args[1], args[2])
    break
  case 'migrate':
    manager.runMigrations(args[1])
    break
  case 'rollback':
    manager.rollbackMigrations(parseInt(args[1] || '1'), args[2])
    break
  case 'status':
    manager.checkMigrationStatus(args[1])
    break
  case 'backup':
    manager.createBackup(args[1])
    break
  case 'validate':
    manager.validateMigrations()
    break
  case 'seed':
    manager.runSeeds(args[1])
    break
  default:
    console.log('Usage: node database-migration.js <command> [args]')
    console.log('Commands:')
    console.log('  create <name> [type]    - Create new migration')
    console.log('  migrate [env]           - Run pending migrations')
    console.log('  rollback [steps] [env]  - Rollback migrations')
    console.log('  status [env]            - Check migration status')
    console.log('  backup [env]            - Create database backup')
    console.log('  validate                - Validate migrations')
    console.log('  seed [env]              - Run database seeds')
}
```

### 4. Seeds y Datos de Prueba
```javascript
// prisma/seed.ts
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  console.log('🌱 Seeding database...')

  // Crear usuarios de prueba
  await prisma.user.createMany({
    data: [
      {
        email: 'admin@example.com',
        name: 'Admin User',
        role: 'ADMIN'
      },
      {
        email: 'user@example.com',
        name: 'Regular User',
        role: 'USER'
      }
    ]
  })

  // Crear categorías
  await prisma.category.createMany({
    data: [
      { name: 'Technology', slug: 'technology' },
      { name: 'Business', slug: 'business' },
      { name: 'Science', slug: 'science' }
    ]
  })

  console.log('✅ Database seeded successfully')
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
```

```javascript
// src/database/seeds/user.seed.ts
import { DataSource } from 'typeorm'
import { User } from '../entities/User'

export class UserSeed {
  public async run(dataSource: DataSource): Promise<void> {
    const userRepository = dataSource.getRepository(User)

    const users = [
      {
        email: 'admin@example.com',
        name: 'Admin User',
        role: 'ADMIN',
        isActive: true
      },
      {
        email: 'user@example.com',
        name: 'Regular User',
        role: 'USER',
        isActive: true
      }
    ]

    for (const userData of users) {
      const existingUser = await userRepository.findOne({
        where: { email: userData.email }
      })

      if (!existingUser) {
        const user = userRepository.create(userData)
        await userRepository.save(user)
        console.log(`✅ Created user: ${userData.email}`)
      }
    }
  }
}
```

### 5. Estrategia de Deployment de Migraciones
```yaml
# .github/workflows/database-migration.yml
name: Database Migration
on:
  push:
    branches: [main]
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production

jobs:
  migrate:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment || 'staging' }}

    services:
      postgres:
        image: postgres:13
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Cache node modules
        uses: actions/cache@v3
        with:
          path: ~/.npm
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-

      - name: Install dependencies
        run: npm ci

      - name: Create database backup
        run: |
          pg_dump ${{ secrets.DATABASE_URL }} > backup-$(date +%Y%m%d_%H%M%S).sql
          echo "BACKUP_FILE=backup-$(date +%Y%m%d_%H%M%S).sql" >> $GITHUB_ENV

      - name: Upload backup
        uses: actions/upload-artifact@v3
        with:
          name: database-backup
          path: ${{ env.BACKUP_FILE }}

      - name: Validate migrations
        run: node scripts/database-migration.js validate

      - name: Run migrations
        run: node scripts/database-migration.js migrate ${{ inputs.environment || 'staging' }}
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}

      - name: Run seeds (only for staging)
        if: inputs.environment == 'staging' || inputs.environment == null
        run: node scripts/database-migration.js seed ${{ inputs.environment || 'staging' }}
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}

      - name: Verify migration success
        run: node scripts/database-migration.js status ${{ inputs.environment || 'staging' }}
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}

      - name: Notify on failure
        if: failure()
        run: |
          curl -X POST -H 'Content-type: application/json' \
          --data '{"text":"🚨 Database migration failed in ${{ inputs.environment || '\''staging'\'' }}"}' \
          ${{ secrets.SLACK_WEBHOOK_URL }}
```

### 6. Monitoreo y Alertas
```javascript
// scripts/database-monitor.js
const { execSync } = require('child_process')

class DatabaseMonitor {
  constructor() {
    this.alerts = []
  }

  // Verificar estado de la base de datos
  async checkDatabaseHealth() {
    console.log('🏥 Checking database health...')

    try {
      // Verificar conexión
      execSync('pg_isready', { stdio: 'pipe' })

      // Verificar que las tablas existen
      const tables = execSync(`
        psql ${{ process.env.DATABASE_URL }} -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public';"
      `, { encoding: 'utf8' })

      if (tables.trim().split('\n').length < 2) {
        this.alerts.push('No tables found in database')
      }

      console.log('✅ Database is healthy')
      return true

    } catch (error) {
      this.alerts.push(`Database health check failed: ${error.message}`)
      console.log('❌ Database health check failed')
      return false
    }
  }

  // Verificar estado de migraciones
  async checkMigrationStatus() {
    console.log('📊 Checking migration status...')

    try {
      const status = execSync('npx prisma migrate status', { encoding: 'utf8' })

      if (status.includes('Database schema is up to date')) {
        console.log('✅ Migrations are up to date')
        return true
      } else {
        this.alerts.push('Pending migrations detected')
        console.log('⚠️ Pending migrations detected')
        return false
      }

    } catch (error) {
      this.alerts.push(`Migration status check failed: ${error.message}`)
      return false
    }
  }

  // Verificar performance
  async checkPerformance() {
    console.log('⚡ Checking database performance...')

    try {
      // Verificar queries lentas
      const slowQueries = execSync(`
        SELECT query, total_time, calls
        FROM pg_stat_statements
        WHERE total_time > 1000
        ORDER BY total_time DESC
        LIMIT 5;
      `, { encoding: 'utf8' })

      if (slowQueries.trim()) {
        this.alerts.push('Slow queries detected')
        console.log('⚠️ Slow queries detected')
      }

      // Verificar conexiones activas
      const connections = execSync(`
        SELECT count(*) as active_connections
        FROM pg_stat_activity
        WHERE state = 'active';
      `, { encoding: 'utf8' })

      console.log(`📈 Active connections: ${connections.trim()}`)

    } catch (error) {
      console.log('ℹ️ Performance metrics not available')
    }
  }

  // Generar reporte
  generateReport() {
    const report = {
      timestamp: new Date().toISOString(),
      health: this.alerts.length === 0,
      alerts: this.alerts,
      recommendations: []
    }

    if (this.alerts.length > 0) {
      console.log('\n🚨 Database Alerts:')
      this.alerts.forEach(alert => console.log(`  - ${alert}`))
    } else {
      console.log('\n✅ Database is healthy')
    }

    // Recomendaciones
    if (this.alerts.includes('Pending migrations detected')) {
      report.recommendations.push('Run database migrations')
    }

    if (this.alerts.includes('Slow queries detected')) {
      report.recommendations.push('Review and optimize slow queries')
    }

    return report
  }

  // Ejecutar monitoreo completo
  async runMonitoring() {
    await this.checkDatabaseHealth()
    await this.checkMigrationStatus()
    await this.checkPerformance()

    return this.generateReport()
  }
}

// Ejecutar monitoreo
const monitor = new DatabaseMonitor()
monitor.runMonitoring().then(report => {
  if (!report.health) {
    process.exit(1)
  }
})
```

### 7. Estrategias de Backup y Recovery
```bash
#!/bin/bash
# scripts/database-backup.sh

set -e

# Configuración
BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ENVIRONMENT=${1:-development}
RETENTION_DAYS=30

# Crear directorio de backups
mkdir -p "$BACKUP_DIR"

echo "💾 Creating database backup for $ENVIRONMENT..."

# Backup de PostgreSQL
if [[ "$ENVIRONMENT" == "production" ]]; then
    pg_dump "$DATABASE_URL" > "$BACKUP_DIR/backup-$ENVIRONMENT-$TIMESTAMP.sql"
else
    # Para desarrollo, incluir datos
    pg_dump --no-owner --no-privileges "$DATABASE_URL" > "$BACKUP_DIR/backup-$ENVIRONMENT-$TIMESTAMP.sql"
fi

# Comprimir backup
gzip "$BACKUP_DIR/backup-$ENVIRONMENT-$TIMESTAMP.sql"

echo "✅ Backup created: $BACKUP_DIR/backup-$ENVIRONMENT-$TIMESTAMP.sql.gz"

# Limpiar backups antiguos
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +$RETENTION_DAYS -delete

echo "🧹 Cleaned up backups older than $RETENTION_DAYS days"

# Subir a cloud storage (opcional)
if [[ -n "$AWS_S3_BUCKET" ]]; then
    aws s3 cp "$BACKUP_DIR/backup-$ENVIRONMENT-$TIMESTAMP.sql.gz" "s3://$AWS_S3_BUCKET/backups/"
    echo "☁️ Backup uploaded to S3"
fi
```

```bash
#!/bin/bash
# scripts/database-restore.sh

set -e

BACKUP_FILE=$1
ENVIRONMENT=${2:-development}

if [[ -z "$BACKUP_FILE" ]]; then
    echo "❌ Usage: $0 <backup-file> [environment]"
    exit 1
fi

echo "🔄 Restoring database from $BACKUP_FILE for $ENVIRONMENT..."

# Crear backup antes de restaurar (safety net)
./scripts/database-backup.sh "${ENVIRONMENT}-pre-restore"

# Descomprimir si es necesario
if [[ "$BACKUP_FILE" == *.gz ]]; then
    gunzip -c "$BACKUP_FILE" > /tmp/restore.sql
    RESTORE_FILE=/tmp/restore.sql
else
    RESTORE_FILE="$BACKUP_FILE"
fi

# Restaurar base de datos
psql "$DATABASE_URL" < "$RESTORE_FILE"

# Limpiar archivo temporal
if [[ -f /tmp/restore.sql ]]; then
    rm /tmp/restore.sql
fi

echo "✅ Database restored from $BACKUP_FILE"
```

### 8. Checklist de Database Migrations
- [ ] **Herramienta configurada**: Prisma/TypeORM/Flyway configurado correctamente
- [ ] **Environment variables**: DATABASE_URL configurado para cada ambiente
- [ ] **Backup strategy**: Backups automáticos antes de migraciones
- [ ] **Migration validation**: Migraciones validadas antes de ejecutar
- [ ] **Rollback plan**: Estrategia de rollback para cada migración
- [ ] **Testing**: Migraciones probadas en ambiente de staging
- [ ] **Documentation**: Cambios documentados en CHANGELOG
- [ ] **Monitoring**: Alertas configuradas para fallos de migración

### 9. Mejores Prácticas
- **Versionado**: Cada migración tiene timestamp y descripción clara
- **Transacciones**: Migraciones envueltas en transacciones cuando sea posible
- **Idempotencia**: Migraciones seguras de ejecutar múltiples veces
- **Rollback**: Todas las migraciones tienen método de rollback
- **Testing**: Migraciones probadas en ambiente de desarrollo
- **Backup**: Siempre crear backup antes de migrar en producción
- **Gradual rollout**: Deploy de migraciones separado del código
- **Monitoring**: Monitoreo continuo del estado de las migraciones

### 10. Troubleshooting
```markdown
## Problemas Comunes y Soluciones

### Migration Fails:
```bash
# Ver detalles del error
npx prisma migrate status

# Reset development database
npx prisma migrate reset

# Aplicar manualmente
npx prisma db push
```

### Schema Drift:
```bash
# Comparar schema actual con esperado
npx prisma migrate diff \
  --from-schema-datamodel prisma/schema.prisma \
  --to-database-url "$DATABASE_URL"

# Resolver diferencias manualmente
npx prisma db push --force-reset
```

### Lock Issues:
```bash
# PostgreSQL: Ver locks activos
SELECT * FROM pg_locks WHERE NOT granted;

# Liberar locks (con cuidado)
SELECT pg_cancel_backend(pid) FROM pg_stat_activity WHERE state = 'active';
```

### Data Loss Prevention:
```bash
# Ver qué datos se perderán
npx prisma migrate diff \
  --from-migrations ./prisma/migrations \
  --to-schema-datamodel prisma/schema.prisma

# Crear backup antes de proceder
./scripts/database-backup.sh production
```
```

### 11. Recursos Adicionales
- [Prisma Migrations](https://www.prisma.io/docs/concepts/components/prisma-migrate)
- [TypeORM Migrations](https://typeorm.io/migrations)
- [Flyway Documentation](https://flywaydb.org/documentation/)
- [Database Change Management Best Practices](https://www.red-gate.com/simple-talk/databases/database-administration/database-change-management-best-practices/)
