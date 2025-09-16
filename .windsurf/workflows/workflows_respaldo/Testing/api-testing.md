---
description: API Testing - Testing específico para endpoints REST/GraphQL
---

# API Testing Workflow

Workflow completo para testing de APIs REST, GraphQL y servicios backend.

## Pre-requisitos
- Postman/Newman para testing de APIs
- Herramientas: Artillery, k6, Newman
- Documentación de API (OpenAPI/Swagger)
- Ambiente de testing (staging/dev)

## Pasos del Workflow

### 1. Configurar Herramientas de API Testing
```bash
# Instalar herramientas
npm install --save-dev newman artillery k6
# Instalar globalmente
npm install -g @apidevtools/swagger-cli
```

### 2. Collection de Postman para Testing
```json
// api-tests.postman_collection.json
{
  "info": {
    "name": "API Tests Collection",
    "description": "Complete API testing suite"
  },
  "variable": [
    {
      "key": "baseUrl",
      "value": "http://localhost:3000/api"
    },
    {
      "key": "authToken",
      "value": ""
    }
  ],
  "item": [
    {
      "name": "Authentication",
      "item": [
        {
          "name": "Login",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"email\": \"test@example.com\",\n  \"password\": \"password123\"\n}"
            },
            "url": {
              "raw": "{{baseUrl}}/auth/login",
              "host": ["{{baseUrl}}"],
              "path": ["auth", "login"]
            },
            "description": "Test user login endpoint"
          },
          "event": [
            {
              "listen": "test",
              "script": {
                "exec": [
                  "pm.test(\"Status code is 200\", function () {",
                  "    pm.response.to.have.status(200);",
                  "});",
                  "",
                  "pm.test(\"Response has token\", function () {",
                  "    var jsonData = pm.response.json();",
                  "    pm.expect(jsonData).to.have.property('token');",
                  "    pm.collectionVariables.set('authToken', jsonData.token);",
                  "});"
                ]
              }
            }
          ]
        }
      ]
    },
    {
      "name": "Users API",
      "item": [
        {
          "name": "Get Users",
          "request": {
            "method": "GET",
            "header": [
              {
                "key": "Authorization",
                "value": "Bearer {{authToken}}"
              }
            ],
            "url": {
              "raw": "{{baseUrl}}/users",
              "host": ["{{baseUrl}}"],
              "path": ["users"]
            }
          },
          "event": [
            {
              "listen": "test",
              "script": {
                "exec": [
                  "pm.test(\"Status code is 200\", function () {",
                  "    pm.response.to.have.status(200);",
                  "});",
                  "",
                  "pm.test(\"Response is array\", function () {",
                  "    var jsonData = pm.response.json();",
                  "    pm.expect(jsonData).to.be.an('array');",
                  "});",
                  "",
                  "pm.test(\"Response time is less than 1000ms\", function () {",
                  "    pm.expect(pm.response.responseTime).to.be.below(1000);",
                  "});"
                ]
              }
            }
          ]
        },
        {
          "name": "Create User",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Authorization",
                "value": "Bearer {{authToken}}"
              },
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"name\": \"John Doe\",\n  \"email\": \"john@example.com\",\n  \"role\": \"user\"\n}"
            },
            "url": {
              "raw": "{{baseUrl}}/users",
              "host": ["{{baseUrl}}"],
              "path": ["users"]
            }
          },
          "event": [
            {
              "listen": "test",
              "script": {
                "exec": [
                  "pm.test(\"Status code is 201\", function () {",
                  "    pm.response.to.have.status(201);",
                  "});",
                  "",
                  "pm.test(\"Response has user data\", function () {",
                  "    var jsonData = pm.response.json();",
                  "    pm.expect(jsonData).to.have.property('id');",
                  "    pm.expect(jsonData).to.have.property('name');",
                  "});"
                ]
              }
            }
          ]
        }
      ]
    }
  ]
}
```

### 3. Ejecutar Tests con Newman
```bash
# Ejecutar collection completa
newman run api-tests.postman_collection.json \
  --environment staging.postman_environment.json \
  --reporters cli,json \
  --reporter-json-export results.json

# Con variables de entorno
newman run api-tests.postman_collection.json \
  --env-var baseUrl=http://localhost:3000/api \
  --env-var username=test@example.com \
  --env-var password=password123

# Tests en CI/CD
newman run api-tests.postman_collection.json \
  --reporters cli,junit \
  --reporter-junit-export test-results.xml
```

### 4. Load Testing de APIs con Artillery
```yaml
# artillery-config.yml
config:
  target: 'http://localhost:3000/api'
  phases:
    - duration: 60
      arrivalRate: 5
      name: Warm up
    - duration: 120
      arrivalRate: 5
      rampTo: 50
      name: Ramp up
    - duration: 60
      arrivalRate: 50
      name: Sustained load

scenarios:
  - name: 'Get users'
    weight: 40
    flow:
      - get:
          url: '/users'
          headers:
            Authorization: 'Bearer {{token}}'
          expect:
            - statusCode: 200
          capture:
            json: '$.[0].id'
            as: 'userId'

  - name: 'Create user'
    weight: 30
    flow:
      - post:
          url: '/users'
          headers:
            Authorization: 'Bearer {{token}}'
            Content-Type: 'application/json'
          json:
            name: 'Test User {{ $randomInt }}'
            email: 'test{{ $randomInt }}@example.com'
          expect:
            - statusCode: 201

  - name: 'Update user'
    weight: 20
    flow:
      - put:
          url: '/users/{{ userId }}'
          headers:
            Authorization: 'Bearer {{token}}'
            Content-Type: 'application/json'
          json:
            name: 'Updated User'
          expect:
            - statusCode: 200

  - name: 'Delete user'
    weight: 10
    flow:
      - delete:
          url: '/users/{{ userId }}'
          headers:
            Authorization: 'Bearer {{token}}'
          expect:
            - statusCode: 204
```

### 5. Contract Testing con Swagger
```javascript
// contract-tests.js
const SwaggerParser = require('@apidevtools/swagger-parser')
const axios = require('axios')

async function validateAPIContract() {
  try {
    // Parsear spec de OpenAPI
    const api = await SwaggerParser.validate('./swagger.yaml')
    console.log('✅ API specification is valid')

    // Testear cada endpoint definido
    for (const [path, methods] of Object.entries(api.paths)) {
      for (const [method, operation] of Object.entries(methods)) {
        await testEndpoint(path, method, operation, api)
      }
    }

  } catch (error) {
    console.error('❌ API contract validation failed:', error.message)
  }
}

async function testEndpoint(path, method, operation, api) {
  const baseUrl = 'http://localhost:3000'
  const fullUrl = baseUrl + path

  try {
    const response = await axios({
      method: method.toUpperCase(),
      url: fullUrl,
      headers: {
        'Content-Type': 'application/json'
      }
    })

    // Validar status code esperado
    const expectedStatus = operation.responses['200'] ? 200 :
                          operation.responses['201'] ? 201 : 200

    if (response.status !== expectedStatus) {
      throw new Error(`Expected status ${expectedStatus}, got ${response.status}`)
    }

    console.log(`✅ ${method.toUpperCase()} ${path} - Status: ${response.status}`)

  } catch (error) {
    console.error(`❌ ${method.toUpperCase()} ${path} - Error: ${error.message}`)
  }
}

validateAPIContract()
```

### 6. Tests de GraphQL APIs
```javascript
// graphql-tests.js
const { request } = require('graphql-request')

const endpoint = 'http://localhost:3000/graphql'

describe('GraphQL API Tests', () => {
  test('Get users query', async () => {
    const query = `
      query GetUsers($first: Int) {
        users(first: $first) {
          id
          name
          email
        }
      }
    `

    const variables = { first: 10 }

    const data = await request(endpoint, query, variables)

    expect(data.users).toBeDefined()
    expect(Array.isArray(data.users)).toBe(true)
    expect(data.users.length).toBeLessThanOrEqual(10)
  })

  test('Create user mutation', async () => {
    const mutation = `
      mutation CreateUser($input: CreateUserInput!) {
        createUser(input: $input) {
          id
          name
          email
        }
      }
    `

    const variables = {
      input: {
        name: 'Test User',
        email: 'test@example.com'
      }
    }

    const data = await request(endpoint, mutation, variables)

    expect(data.createUser).toBeDefined()
    expect(data.createUser.id).toBeDefined()
    expect(data.createUser.name).toBe('Test User')
  })

  test('Query with invalid schema', async () => {
    const invalidQuery = `
      query {
        invalidField {
          id
        }
      }
    `

    await expect(request(endpoint, invalidQuery))
      .rejects.toThrow('Cannot query field')
  })
})
```

### 7. API Security Testing
```javascript
// api-security-tests.js
const axios = require('axios')

const baseUrl = 'http://localhost:3000/api'

describe('API Security Tests', () => {
  test('Authentication required', async () => {
    try {
      await axios.get(`${baseUrl}/users`)
      fail('Should have thrown 401 error')
    } catch (error) {
      expect(error.response.status).toBe(401)
    }
  })

  test('Invalid token rejected', async () => {
    try {
      await axios.get(`${baseUrl}/users`, {
        headers: {
          Authorization: 'Bearer invalid-token'
        }
      })
      fail('Should have thrown 401 error')
    } catch (error) {
      expect(error.response.status).toBe(401)
    }
  })

  test('SQL injection prevention', async () => {
    const maliciousPayload = {
      search: "'; DROP TABLE users; --"
    }

    const response = await axios.post(`${baseUrl}/search`, maliciousPayload, {
      headers: {
        Authorization: `Bearer ${validToken}`
      }
    })

    // Should not execute SQL injection
    expect(response.status).toBe(200)
    expect(response.data).toBeDefined()
  })

  test('Rate limiting', async () => {
    const requests = []

    // Make many requests quickly
    for (let i = 0; i < 100; i++) {
      requests.push(
        axios.get(`${baseUrl}/users`, {
          headers: {
            Authorization: `Bearer ${validToken}`
          }
        })
      )
    }

    const results = await Promise.allSettled(requests)

    // Some requests should be rate limited
    const rateLimited = results.filter(result =>
      result.status === 'rejected' &&
      result.reason.response?.status === 429
    )

    expect(rateLimited.length).toBeGreaterThan(0)
  })

  test('Input validation', async () => {
    const invalidData = {
      email: 'invalid-email',
      name: ''
    }

    try {
      await axios.post(`${baseUrl}/users`, invalidData, {
        headers: {
          Authorization: `Bearer ${validToken}`
        }
      })
      fail('Should have thrown validation error')
    } catch (error) {
      expect(error.response.status).toBe(400)
      expect(error.response.data.errors).toBeDefined()
    }
  })
})
```

### 8. CI/CD Integration
```yaml
# .github/workflows/api-tests.yml
name: API Tests
on: [push, pull_request]

jobs:
  api-tests:
    runs-on: ubuntu-latest
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

      - name: Install dependencies
        run: npm ci

      - name: Start API server
        run: npm run dev &
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test

      - name: Wait for server
        run: |
          timeout 30 bash -c 'until curl -f http://localhost:3000/health; do sleep 1; done'

      - name: Run Postman tests
        run: |
          npm install -g newman
          newman run tests/api-tests.postman_collection.json \
            --env-var baseUrl=http://localhost:3000/api \
            --reporters cli,junit \
            --reporter-junit-export api-test-results.xml

      - name: Run GraphQL tests
        run: npm run test:graphql

      - name: Run security tests
        run: npm run test:security

      - name: Upload test results
        uses: actions/upload-artifact@v3
        with:
          name: api-test-results
          path: |
            api-test-results.xml
            test-results/
```

### 9. API Monitoring y Alertas
```javascript
// api-monitoring.js
const axios = require('axios')

class APIMonitor {
  constructor(baseUrl) {
    this.baseUrl = baseUrl
    this.endpoints = [
      { path: '/health', method: 'GET', expectedStatus: 200 },
      { path: '/users', method: 'GET', expectedStatus: 200 },
      { path: '/api/v1/status', method: 'GET', expectedStatus: 200 }
    ]
  }

  async monitorEndpoints() {
    const results = []

    for (const endpoint of this.endpoints) {
      try {
        const startTime = Date.now()

        const response = await axios({
          method: endpoint.method,
          url: `${this.baseUrl}${endpoint.path}`,
          timeout: 5000
        })

        const responseTime = Date.now() - startTime

        results.push({
          endpoint: endpoint.path,
          status: 'UP',
          responseTime,
          statusCode: response.status
        })

        // Alertas
        if (responseTime > 1000) {
          console.warn(`⚠️  Slow response: ${endpoint.path} (${responseTime}ms)`)
        }

        if (response.status !== endpoint.expectedStatus) {
          console.error(`❌ Unexpected status: ${endpoint.path} (${response.status})`)
        }

      } catch (error) {
        results.push({
          endpoint: endpoint.path,
          status: 'DOWN',
          error: error.message
        })

        console.error(`❌ Endpoint down: ${endpoint.path} - ${error.message}`)
      }
    }

    return results
  }

  async generateReport() {
    const results = await this.monitorEndpoints()

    const report = {
      timestamp: new Date().toISOString(),
      summary: {
        total: results.length,
        up: results.filter(r => r.status === 'UP').length,
        down: results.filter(r => r.status === 'DOWN').length,
        averageResponseTime: results
          .filter(r => r.responseTime)
          .reduce((sum, r) => sum + r.responseTime, 0) / results.length
      },
      results
    }

    console.log('📊 API Monitoring Report:')
    console.log(`Total endpoints: ${report.summary.total}`)
    console.log(`Up: ${report.summary.up}`)
    console.log(`Down: ${report.summary.down}`)
    console.log(`Avg response time: ${report.summary.averageResponseTime.toFixed(0)}ms`)

    return report
  }
}

// Uso
const monitor = new APIMonitor('http://localhost:3000')
setInterval(() => monitor.generateReport(), 60000) // Every minute
```

### 10. Checklist de API Testing
- [ ] **Contract Testing**: Validar contra especificación OpenAPI
- [ ] **Functional Testing**: CRUD operations funcionan correctamente
- [ ] **Negative Testing**: Manejo apropiado de errores
- [ ] **Performance Testing**: Response times dentro de límites
- [ ] **Security Testing**: Autenticación, autorización, validación
- [ ] **Load Testing**: Manejo de carga concurrente
- [ ] **Integration Testing**: Interacción con otros servicios
- [ ] **Monitoring**: Alertas y métricas configuradas
