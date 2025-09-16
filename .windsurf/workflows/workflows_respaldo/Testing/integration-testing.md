---
description: Integration Testing - Pruebas de integración para componentes y módulos
---

# Integration Testing Workflow

Workflow para crear y ejecutar pruebas de integración que validan la interacción entre componentes, módulos y servicios.

## Pre-requisitos
- Proyecto configurado con framework de testing (Vitest, Jest, etc.)
- Dependencias de integración instaladas
- Base de datos de testing configurada (si aplica)

## Pasos del Workflow

### 1. Configurar Ambiente de Testing
```bash
# Instalar dependencias de testing si no existen
npm install --save-dev @testing-library/react @testing-library/jest-dom msw
```

### 2. Crear Estructura de Tests de Integración
```
src/
  __tests__/
    integration/
      components/
      services/
      pages/
```

### 3. Configurar Mock Services
Crear mocks para servicios externos:
- API endpoints
- Bases de datos
- Servicios de autenticación
- Servicios de terceros

### 4. Escribir Tests de Integración

#### Ejemplo: Test de Componente con API
```typescript
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { UserList } from '@/components/UserList'
import { server } from '@/mocks/server'

// Configurar MSW antes de todos los tests
beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

describe('UserList Integration', () => {
  it('loads and displays users from API', async () => {
    render(<UserList />)

    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument()
    })
  })

  it('handles API errors gracefully', async () => {
    // Mock error response
    server.use(
      rest.get('/api/users', (req, res, ctx) => {
        return res(ctx.status(500))
      })
    )

    render(<UserList />)

    await waitFor(() => {
      expect(screen.getByText('Error loading users')).toBeInTheDocument()
    })
  })
})
```

#### Ejemplo: Test de Página Completa
```typescript
import { render, screen } from '@testing-library/react'
import { BrowserRouter } from 'react-router-dom'
import { Dashboard } from '@/pages/Dashboard'

describe('Dashboard Page Integration', () => {
  it('renders complete dashboard with all components', () => {
    render(
      <BrowserRouter>
        <Dashboard />
      </BrowserRouter>
    )

    expect(screen.getByRole('heading', { name: /dashboard/i })).toBeInTheDocument()
    expect(screen.getByText(/welcome back/i)).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /create new/i })).toBeInTheDocument()
  })
})
```

### 5. Configurar Test Database
```typescript
// test-db-setup.ts
import { PrismaClient } from '@prisma/client'

export const createTestDatabase = () => {
  const prisma = new PrismaClient({
    datasources: {
      db: {
        url: process.env.DATABASE_URL_TEST
      }
    }
  })

  return prisma
}

// Limpiar DB entre tests
export const cleanDatabase = async (prisma: PrismaClient) => {
  await prisma.user.deleteMany()
  await prisma.post.deleteMany()
}
```

### 6. Ejecutar Tests de Integración
```bash
# Ejecutar solo tests de integración
npm run test:integration

# Con coverage
npm run test:integration -- --coverage

# Modo watch
npm run test:integration -- --watch
```

### 7. Configurar CI/CD para Integration Tests
```yaml
# .github/workflows/integration-tests.yml
name: Integration Tests
on: [push, pull_request]
jobs:
  integration:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: npm ci
      - name: Run integration tests
        run: npm run test:integration
```

### 8. Checklist de Validación
- [ ] Tests pasan en local
- [ ] Tests pasan en CI/CD
- [ ] Coverage mínimo alcanzado (80%+)
- [ ] Tests limpian estado entre ejecuciones
- [ ] Mocks configurados correctamente
- [ ] Errores manejados apropiadamente
- [ ] Tests son independientes y no flaky

### 9. Métricas de Éxito
- Todos los tests pasan
- Coverage > 80%
- Tiempo de ejecución < 5 minutos
- Zero flakiness
- Tests reflejan flujos de usuario reales

### 10. Troubleshooting
- **Tests lentos**: Optimizar queries de DB, usar más mocks
- **Tests flaky**: Aislar mejor el estado, usar waitFor correctamente
- **Coverage bajo**: Identificar código no testeado, agregar tests faltantes
- **CI fallando**: Verificar configuración de environment, secrets, etc.
