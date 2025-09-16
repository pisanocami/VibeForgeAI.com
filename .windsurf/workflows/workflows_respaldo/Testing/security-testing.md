---
description: Security Testing - Análisis de vulnerabilidades y penetration testing básico
---

# Security Testing Workflow

Workflow completo para testing de seguridad, análisis de vulnerabilidades y mejores prácticas de seguridad.

## Pre-requisitos
- Conocimiento básico de OWASP Top 10
- Herramientas: OWASP ZAP, Burp Suite, npm audit, Snyk
- Ambiente de testing seguro (no producción)

## Pasos del Workflow

### 1. Configurar Herramientas de Seguridad
```bash
# Instalar herramientas de security testing
npm install --save-dev owasp-dependency-check snyk
# Instalar herramientas globales
npm install -g retire @cyclonedx/cdxgen
```

### 2. Dependency Vulnerability Scanning
```javascript
// security-audit.js
const { execSync } = require('child_process')

function runSecurityAudit() {
  console.log('🔍 Running npm audit...')
  try {
    execSync('npm audit --audit-level=moderate', { stdio: 'inherit' })
  } catch (error) {
    console.log('❌ Vulnerabilities found in dependencies')
  }

  console.log('🔍 Running Snyk security scan...')
  try {
    execSync('snyk test', { stdio: 'inherit' })
  } catch (error) {
    console.log('❌ Snyk found security issues')
  }

  console.log('🔍 Checking for outdated dependencies...')
  try {
    execSync('npm outdated', { stdio: 'inherit' })
  } catch (error) {
    console.log('Some dependencies are outdated')
  }
}

runSecurityAudit()
```

### 3. Static Application Security Testing (SAST)
```javascript
// sast-scan.js
const esprima = require('esprima')
const fs = require('fs')

class SecurityScanner {
  constructor() {
    this.vulnerabilities = []
  }

  scanFile(filePath) {
    const content = fs.readFileSync(filePath, 'utf8')
    const ast = esprima.parseScript(content)

    this.checkForVulnerabilities(ast, filePath)
  }

  checkForVulnerabilities(ast, filePath) {
    // XSS Prevention Check
    this.checkXSSVulnerabilities(ast, filePath)

    // SQL Injection Check
    this.checkSQLInjection(ast, filePath)

    // Hardcoded Secrets Check
    this.checkHardcodedSecrets(ast, filePath)

    // Insecure Random Check
    this.checkInsecureRandom(ast, filePath)
  }

  checkXSSVulnerabilities(ast, filePath) {
    // Buscar uso de innerHTML sin sanitización
    this.traverseAST(ast, (node) => {
      if (node.type === 'AssignmentExpression' &&
          node.left.property?.name === 'innerHTML') {
        this.vulnerabilities.push({
          type: 'XSS',
          severity: 'High',
          file: filePath,
          line: node.loc?.start.line,
          message: 'Potential XSS vulnerability: innerHTML assignment without sanitization'
        })
      }
    })
  }

  checkSQLInjection(ast, filePath) {
    // Buscar queries SQL sin prepared statements
    this.traverseAST(ast, (node) => {
      if (node.type === 'CallExpression' &&
          node.callee.name === 'query' &&
          node.arguments.some(arg => arg.type === 'BinaryExpression')) {
        this.vulnerabilities.push({
          type: 'SQL Injection',
          severity: 'Critical',
          file: filePath,
          line: node.loc?.start.line,
          message: 'Potential SQL injection: string concatenation in query'
        })
      }
    })
  }

  checkHardcodedSecrets(ast, filePath) {
    const secretPatterns = [
      /password\s*[:=]\s*['"][^'"]*['"]/i,
      /secret\s*[:=]\s*['"][^'"]*['"]/i,
      /token\s*[:=]\s*['"][^'"]*['"]/i,
      /api.?key\s*[:=]\s*['"][^'"]*['"]/i
    ]

    const content = fs.readFileSync(filePath, 'utf8')
    secretPatterns.forEach(pattern => {
      const matches = content.match(pattern)
      if (matches) {
        this.vulnerabilities.push({
          type: 'Hardcoded Secret',
          severity: 'High',
          file: filePath,
          message: 'Potential hardcoded secret detected'
        })
      }
    })
  }

  checkInsecureRandom(ast, filePath) {
    this.traverseAST(ast, (node) => {
      if (node.type === 'CallExpression' &&
          node.callee.name === 'Math' &&
          node.callee.property?.name === 'random') {
        this.vulnerabilities.push({
          type: 'Insecure Random',
          severity: 'Medium',
          file: filePath,
          line: node.loc?.start.line,
          message: 'Using Math.random() for security-sensitive operations'
        })
      }
    })
  }

  traverseAST(node, callback) {
    callback(node)
    for (const key in node) {
      if (node[key] && typeof node[key] === 'object') {
        if (Array.isArray(node[key])) {
          node[key].forEach(child => this.traverseAST(child, callback))
        } else {
          this.traverseAST(node[key], callback)
        }
      }
    }
  }

  generateReport() {
    const report = {
      timestamp: new Date().toISOString(),
      totalVulnerabilities: this.vulnerabilities.length,
      vulnerabilities: this.vulnerabilities
    }

    fs.writeFileSync('security-report.json', JSON.stringify(report, null, 2))

    console.log(`🔍 Found ${this.vulnerabilities.length} potential vulnerabilities:`)
    this.vulnerabilities.forEach(vuln => {
      console.log(`[${vuln.severity}] ${vuln.type}: ${vuln.message}`)
      console.log(`  File: ${vuln.file}${vuln.line ? `:${vuln.line}` : ''}`)
    })

    return report
  }
}

// Uso
const scanner = new SecurityScanner()
scanner.scanFile('./src/components/LoginForm.js')
scanner.scanFile('./src/api/auth.js')
scanner.generateReport()
```

### 4. Dynamic Application Security Testing (DAST)
```javascript
// dast-testing.js
const puppeteer = require('puppeteer')

async function runDAST(url) {
  const browser = await puppeteer.launch({
    headless: false, // Para debugging visual
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  })

  const page = await browser.newPage()

  try {
    // Configurar logging de requests/responses
    page.on('request', request => {
      console.log(`📤 ${request.method()} ${request.url()}`)
    })

    page.on('response', response => {
      console.log(`📥 ${response.status()} ${response.url()}`)
    })

    // Navigate to the application
    await page.goto(url, { waitUntil: 'networkidle0' })

    // Test for common vulnerabilities

    // 1. Test for XSS via input fields
    await testXSS(page)

    // 2. Test for SQL Injection
    await testSQLInjection(page)

    // 3. Test for CSRF
    await testCSRF(page)

    // 4. Test for insecure headers
    await testSecurityHeaders(page)

    // 5. Test for exposed sensitive information
    await testInformationDisclosure(page)

  } finally {
    await browser.close()
  }
}

async function testXSS(page) {
  console.log('🔍 Testing for XSS vulnerabilities...')

  const xssPayloads = [
    '<script>alert("XSS")</script>',
    '<img src=x onerror=alert("XSS")>',
    'javascript:alert("XSS")'
  ]

  for (const payload of xssPayloads) {
    try {
      // Encontrar campos de input
      const inputs = await page.$$('input[type="text"], textarea')

      for (const input of inputs) {
        await input.clear()
        await input.type(payload)
        await page.keyboard.press('Enter')

        // Esperar y verificar si se ejecutó el payload
        await page.waitForTimeout(1000)

        // Verificar si apareció alert (esto es básico, en producción usaría más técnicas)
        const alerts = await page.$$('[role="alert"], .alert, .error')
        if (alerts.length > 0) {
          console.log(`❌ Potential XSS vulnerability found with payload: ${payload}`)
        }
      }
    } catch (error) {
      console.log(`Error testing XSS with payload ${payload}:`, error.message)
    }
  }
}

async function testSQLInjection(page) {
  console.log('🔍 Testing for SQL Injection vulnerabilities...')

  const sqlPayloads = [
    "' OR '1'='1",
    "'; DROP TABLE users; --",
    "' UNION SELECT * FROM users --"
  ]

  // Similar approach for login forms, search fields, etc.
  // Implementation would depend on the specific application
}

async function testCSRF(page) {
  console.log('🔍 Testing for CSRF vulnerabilities...')

  // Check for CSRF tokens in forms
  const forms = await page.$$('form')
  for (const form of forms) {
    const csrfToken = await form.$('input[name="csrf_token"], input[name="_token"]')
    if (!csrfToken) {
      console.log('⚠️  Form without CSRF token found')
    }
  }
}

async function testSecurityHeaders(page) {
  console.log('🔍 Testing security headers...')

  const response = await page.reload({ waitUntil: 'networkidle0' })

  // Check for important security headers
  const headers = response.headers()

  const requiredHeaders = {
    'x-frame-options': 'DENY or SAMEORIGIN',
    'x-content-type-options': 'nosniff',
    'x-xss-protection': '1; mode=block',
    'content-security-policy': 'CSP directives',
    'strict-transport-security': 'max-age=31536000'
  }

  for (const [header, expected] of Object.entries(requiredHeaders)) {
    if (!headers[header.toLowerCase()]) {
      console.log(`❌ Missing security header: ${header} (${expected})`)
    } else {
      console.log(`✅ ${header}: ${headers[header.toLowerCase()]}`)
    }
  }
}

async function testInformationDisclosure(page) {
  console.log('🔍 Testing for information disclosure...')

  // Check for exposed .env, .git, etc.
  const sensitivePaths = [
    '/.env',
    '/.git/config',
    '/.DS_Store',
    '/backup.sql',
    '/phpinfo.php'
  ]

  for (const path of sensitivePaths) {
    try {
      const response = await page.goto(`${page.url()}${path}`)
      if (response.status() === 200) {
        console.log(`❌ Sensitive file exposed: ${path}`)
      }
    } catch (error) {
      // Expected for 404s
    }
  }
}

// Ejecutar DAST
runDAST('http://localhost:3000')
```

### 5. OWASP Top 10 Testing Checklist

#### A01:2021 - Broken Access Control
- [ ] **URL Manipulation**: Probar acceso directo a recursos restringidos
- [ ] **Parameter Tampering**: Modificar parámetros en requests
- [ ] **Horizontal Privilege Escalation**: Acceder a recursos de otros usuarios
- [ ] **Vertical Privilege Escalation**: Elevar privilegios no autorizados

#### A02:2021 - Cryptographic Failures
- [ ] **Weak Encryption**: Verificar algoritmos de encriptación
- [ ] **Insecure Protocols**: Evitar HTTP, usar HTTPS
- [ ] **Hardcoded Keys**: Buscar keys hardcodeadas
- [ ] **Insufficient Key Size**: Verificar tamaño de keys criptográficas

#### A03:2021 - Injection
- [ ] **SQL Injection**: Probar payloads SQL en inputs
- [ ] **NoSQL Injection**: Probar inyección en bases NoSQL
- [ ] **Command Injection**: Probar ejecución de comandos
- [ ] **LDAP Injection**: Probar inyección LDAP

#### A04:2021 - Insecure Design
- [ ] **Business Logic Flaws**: Probar lógica de negocio
- [ ] **Race Conditions**: Probar condiciones de carrera
- [ ] **Lack of Limits**: Verificar límites de rate limiting

#### A05:2021 - Security Misconfiguration
- [ ] **Default Credentials**: Verificar credenciales por defecto
- [ ] **Unnecessary Services**: Deshabilitar servicios innecesarios
- [ ] **Verbose Errors**: Evitar errores detallados en producción
- [ ] **Directory Listing**: Deshabilitar listado de directorios

#### A06:2021 - Vulnerable Components
- [ ] **Outdated Dependencies**: Actualizar componentes vulnerables
- [ ] **Known Vulnerabilities**: Verificar CVEs conocidas
- [ ] **Unnecessary Components**: Remover dependencias no usadas

#### A07:2021 - Identification & Authentication Failures
- [ ] **Weak Passwords**: Probar políticas de password
- [ ] **Session Management**: Verificar manejo de sesiones
- [ ] **Brute Force**: Probar ataques de fuerza bruta
- [ ] **Credential Stuffing**: Probar credenciales reusadas

#### A08:2021 - Software Integrity Failures
- [ ] **CI/CD Security**: Verificar seguridad del pipeline
- [ ] **Code Signing**: Verificar firma de código
- [ ] **Third-party Dependencies**: Auditar dependencias de terceros

#### A09:2021 - Logging & Monitoring Failures
- [ ] **Insufficient Logging**: Verificar logs de seguridad
- [ ] **Log Injection**: Probar inyección en logs
- [ ] **Alert Fatigue**: Evitar demasiadas alertas falsas

#### A10:2021 - Server-Side Request Forgery
- [ ] **SSRF Prevention**: Verificar protección contra SSRF
- [ ] **URL Validation**: Validar URLs de entrada
- [ ] **Network Restrictions**: Restringir requests de red

### 6. CI/CD Security Integration
```yaml
# .github/workflows/security.yml
name: Security Tests
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 2 * * 1' # Weekly security scan

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Run npm audit
        run: npm audit --audit-level=moderate

      - name: Run Snyk security scan
        run: |
          npm install -g snyk
          snyk test --severity-threshold=medium

      - name: Run custom SAST
        run: node scripts/security-audit.js

      - name: Upload security report
        uses: actions/upload-artifact@v3
        with:
          name: security-report
          path: security-report.json

      - name: Fail on high severity vulnerabilities
        run: |
          if [ $(jq '.vulnerabilities | map(select(.severity == "Critical" or .severity == "High")) | length' security-report.json) -gt 0 ]; then
            echo "🚨 High severity vulnerabilities found!"
            exit 1
          fi
```

### 7. Secrets Management
```javascript
// secrets-check.js
const fs = require('fs')
const path = require('path')

function scanForSecrets(directory) {
  const secrets = []
  const secretPatterns = [
    /password\s*[:=]\s*['"][^'"]*['"]/i,
    /secret\s*[:=]\s*['"][^'"]*['"]/i,
    /token\s*[:=]\s*['"][^'"]*['"]/i,
    /api.?key\s*[:=]\s*['"][^'"]*['"]/i,
    /private.?key/i,
    /BEGIN\s+(RSA\s+)?PRIVATE\s+KEY/i
  ]

  function scanDir(dir) {
    const files = fs.readdirSync(dir)

    files.forEach(file => {
      const filePath = path.join(dir, file)
      const stat = fs.statSync(filePath)

      // Skip node_modules, .git, etc.
      if (file === 'node_modules' || file === '.git' || file.startsWith('.')) {
        return
      }

      if (stat.isDirectory()) {
        scanDir(filePath)
      } else {
        try {
          const content = fs.readFileSync(filePath, 'utf8')
          secretPatterns.forEach(pattern => {
            const matches = content.match(pattern)
            if (matches) {
              secrets.push({
                file: filePath,
                pattern: pattern.toString(),
                line: content.split('\n').findIndex(line => pattern.test(line)) + 1
              })
            }
          })
        } catch (error) {
          // Skip binary files
        }
      }
    })
  }

  scanDir(directory)

  if (secrets.length > 0) {
    console.log('🚨 Potential secrets found:')
    secrets.forEach(secret => {
      console.log(`  ${secret.file}:${secret.line} - ${secret.pattern}`)
    })
  } else {
    console.log('✅ No secrets found')
  }

  return secrets
}

scanForSecrets('./src')
```

### 8. Mejores Prácticas de Seguridad

#### Desarrollo Seguro
- **Input Validation**: Validar y sanitizar todos los inputs
- **Output Encoding**: Codificar outputs para prevenir XSS
- **Authentication**: Usar JWT, OAuth, multi-factor auth
- **Authorization**: Implementar RBAC/ABAC
- **Session Management**: Secure cookies, timeout apropiado
- **Error Handling**: No exponer información sensible en errores

#### Infraestructura
- **HTTPS Everywhere**: Forzar HTTPS con HSTS
- **Security Headers**: Implementar CSP, X-Frame-Options, etc.
- **Rate Limiting**: Prevenir ataques de fuerza bruta
- **CORS**: Configurar apropiadamente
- **API Security**: Usar API keys, rate limiting

#### DevSecOps
- **Shift Left Security**: Integrar seguridad desde el inicio
- **Automated Testing**: Ejecutar tests de seguridad en CI/CD
- **Vulnerability Management**: Proceso para manejar vulnerabilidades
- **Security Training**: Entrenar al equipo en seguridad

### 9. Herramientas Recomendadas
- **OWASP ZAP**: Proxy de interceptación para testing manual
- **Burp Suite**: Suite completa de testing de seguridad
- **Snyk**: Scanning de vulnerabilidades en dependencias
- **SonarQube**: Análisis estático de código
- **Dependabot**: Actualización automática de dependencias
- **Trivy**: Scanner de vulnerabilidades en containers

### 10. Reporte y Remediation
```javascript
// security-dashboard.js
function generateSecurityDashboard() {
  const report = {
    timestamp: new Date().toISOString(),
    summary: {
      totalVulnerabilities: 0,
      critical: 0,
      high: 0,
      medium: 0,
      low: 0
    },
    categories: {
      'Broken Access Control': [],
      'Cryptographic Failures': [],
      'Injection': [],
      'Insecure Design': [],
      'Security Misconfiguration': [],
      'Vulnerable Components': [],
      'Identification & Authentication Failures': [],
      'Software Integrity Failures': [],
      'Logging & Monitoring Failures': [],
      'Server-Side Request Forgery': []
    },
    recommendations: []
  }

  // Leer reportes de diferentes herramientas
  // Generar recomendaciones específicas
  // Crear dashboard visual

  return report
}
```

### 11. Compliance y Standards
- **OWASP ASVS**: Application Security Verification Standard
- **NIST Cybersecurity Framework**: Framework de ciberseguridad
- **ISO 27001**: Standard de gestión de seguridad de la información
- **GDPR**: Protección de datos personales
- **HIPAA**: Para aplicaciones de salud (si aplica)
