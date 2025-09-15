---
description: Security Audit - Checklist de seguridad para código y configuración
---

# Security Audit Workflow

Auditoría completa de seguridad para identificar vulnerabilidades, configuraciones inseguras y mejores prácticas de seguridad.

## Pre-requisitos
- Conocimiento básico de OWASP Top 10
- Herramientas de security scanning (SAST, DAST, SCA)
- Equipo con permisos para implementar correcciones
- Ambiente de staging para testing de seguridad

## Pasos del Workflow

### 1. Preparación de Security Audit
```markdown
## Checklist Pre-Audit

### Equipo y Recursos:
- [ ] **Security Champion**: Persona responsable de seguridad asignada
- [ ] **Timeline definido**: Fechas para discovery, assessment, remediation
- [ ] **Scope claro**: Sistemas, aplicaciones, infraestructura incluidos
- [ ] **Regulaciones aplicables**: GDPR, HIPAA, PCI-DSS, etc.
- [ ] **Herramientas listas**: Scanners, proxies, testing tools configurados
- [ ] **Ambiente de testing**: Staging environment sin datos reales
- [ ] **Plan de comunicación**: Cómo reportar findings críticos

### Documentación:
- [ ] **Arquitectura documentada**: Diagramas de sistema y data flow
- [ ] **Inventario de activos**: Lista completa de sistemas y datos
- [ ] **Políticas de seguridad**: Guías y estándares del equipo
- [ ] **Contactos de seguridad**: Equipo de respuesta a incidentes
- [ ] **Historial de auditorías**: Resultados anteriores para comparación
```

### 2. Fases del Security Audit
```markdown
## Fases de Auditoría

### Fase 1: Reconocimiento y Discovery
- **Asset Discovery**: Identificar todos los sistemas y servicios
- **Service Enumeration**: Mapear puertos, servicios y versiones
- **Technology Stack**: Documentar frameworks, librerías, dependencias
- **User Roles**: Identificar roles y permisos de usuario
- **Data Classification**: Clasificar tipos de datos sensibles

### Fase 2: Vulnerability Assessment
- **Automated Scanning**: Ejecutar scanners de vulnerabilidades
- **Manual Testing**: Penetration testing ético
- **Configuration Review**: Auditar configuraciones de seguridad
- **Code Review**: Análisis estático de código fuente
- **Compliance Check**: Verificar cumplimiento de estándares

### Fase 3: Risk Analysis
- **Risk Rating**: CVSS scoring para vulnerabilidades
- **Business Impact**: Evaluar impacto en negocio
- **Exploitability**: Dificultad de explotación
- **Remediation Priority**: Priorizar correcciones por riesgo

### Fase 4: Reporting y Remediation
- **Executive Summary**: Resumen para management
- **Technical Details**: Hallazgos detallados para developers
- **Remediation Plan**: Plan de corrección con timelines
- **Follow-up Plan**: Verificación de correcciones
```

### 3. Checklist de Security Audit Automatizado
```javascript
// scripts/security-audit.js
const { execSync } = require('child_process')
const fs = require('fs')
const https = require('https')

class SecurityAuditor {
  constructor() {
    this.findings = []
    this.severityLevels = {
      CRITICAL: 4,
      HIGH: 3,
      MEDIUM: 2,
      LOW: 1,
      INFO: 0
    }
  }

  async runFullAudit() {
    console.log('🔒 Iniciando auditoría de seguridad completa...')

    // Ejecutar todas las verificaciones
    await this.checkDependencies()
    await this.checkCodeSecurity()
    await this.checkConfiguration()
    await this.checkSecrets()
    await this.checkInfrastructure()
    await this.checkCompliance()

    // Generar reporte
    this.generateReport()
    this.generateRemediationPlan()

    return this.findings
  }

  async checkDependencies() {
    console.log('📦 Verificando dependencias...')

    try {
      // npm audit
      const auditResult = execSync('npm audit --json', { encoding: 'utf8' })
      const audit = JSON.parse(auditResult)

      if (audit.vulnerabilities) {
        Object.entries(audit.vulnerabilities).forEach(([pkg, vuln]) => {
          this.addFinding({
            category: 'DEPENDENCIES',
            severity: vuln.severity.toUpperCase(),
            title: `${pkg}: ${vuln.title}`,
            description: vuln.title,
            recommendation: `Update ${pkg} to version ${vuln.fixAvailable?.version || 'latest'}`,
            cve: vuln.cve || null,
            cvss: vuln.cvss?.score || null,
            references: [vuln.url]
          })
        })
      }

      // Verificar dependencias desactualizadas
      const outdatedResult = execSync('npm outdated --json', { encoding: 'utf8' })
      const outdated = JSON.parse(outdatedResult)

      Object.entries(outdated).forEach(([pkg, info]) => {
        const daysOld = Math.floor((Date.now() - new Date(info.time)) / (1000 * 60 * 60 * 24))
        if (daysOld > 365) { // Más de un año desactualizado
          this.addFinding({
            category: 'DEPENDENCIES',
            severity: 'MEDIUM',
            title: `Outdated dependency: ${pkg}`,
            description: `${pkg} is ${daysOld} days old`,
            recommendation: `Update ${pkg} from ${info.current} to ${info.latest}`
          })
        }
      })

    } catch (error) {
      console.log('⚠️ Error checking dependencies:', error.message)
    }
  }

  async checkCodeSecurity() {
    console.log('🔍 Analizando código fuente...')

    // Buscar patrones inseguros
    const patterns = [
      {
        name: 'Hardcoded Secrets',
        pattern: /(password|secret|token|key)\s*[:=]\s*['"][^'"]*['"]/gi,
        severity: 'HIGH',
        recommendation: 'Move secrets to environment variables or secret management system'
      },
      {
        name: 'SQL Injection',
        pattern: /(SELECT|INSERT|UPDATE|DELETE).*\$\{.*\}/gi,
        severity: 'CRITICAL',
        recommendation: 'Use parameterized queries or ORM prepared statements'
      },
      {
        name: 'XSS Vulnerability',
        pattern: /innerHTML\s*=.*\+/gi,
        severity: 'HIGH',
        recommendation: 'Use textContent or sanitize HTML input'
      },
      {
        name: 'Weak Cryptography',
        pattern: /(MD5|SHA1)\s*\(/gi,
        severity: 'MEDIUM',
        recommendation: 'Use SHA-256 or stronger cryptographic functions'
      },
      {
        name: 'Console Logs',
        pattern: /console\.(log|warn|error)/gi,
        severity: 'LOW',
        recommendation: 'Remove console statements from production code'
      }
    ]

    // Buscar en archivos de código
    const codeFiles = this.findFiles(['.js', '.ts', '.tsx', '.jsx', '.vue', '.py', '.java', '.php'])
    
    patterns.forEach(({ name, pattern, severity, recommendation }) => {
      codeFiles.forEach(file => {
        try {
          const content = fs.readFileSync(file, 'utf8')
          const matches = content.match(pattern)
          
          if (matches) {
            matches.forEach(match => {
              const lines = content.split('\n')
              const lineNumber = lines.findIndex(line => line.includes(match)) + 1
              
              this.addFinding({
                category: 'CODE_SECURITY',
                severity,
                title: `${name} in ${file}`,
                description: `Found: ${match}`,
                file,
                line: lineNumber,
                recommendation
              })
            })
          }
        } catch (error) {
          // Skip files that can't be read
        }
      })
    })
  }

  async checkConfiguration() {
    console.log('⚙️ Verificando configuración...')

    // Verificar archivos de configuración comunes
    const configFiles = [
      'package.json',
      '.env',
      '.env.example',
      'docker-compose.yml',
      'Dockerfile',
      'nginx.conf',
      '.htaccess',
      'web.config'
    ]

    configFiles.forEach(file => {
      if (fs.existsSync(file)) {
        try {
          const content = fs.readFileSync(file, 'utf8')

          // Verificar configuraciones inseguras
          if (content.includes('NODE_ENV=production') && content.includes('DEBUG=true')) {
            this.addFinding({
              category: 'CONFIGURATION',
              severity: 'MEDIUM',
              title: 'Debug mode enabled in production',
              file,
              recommendation: 'Disable debug mode in production environment'
            })
          }

          if (content.includes('password') && !content.includes('ENCRYPTED') && !file.includes('.example')) {
            this.addFinding({
              category: 'CONFIGURATION',
              severity: 'HIGH',
              title: 'Plain text password in config',
              file,
              recommendation: 'Use encrypted passwords or environment variables'
            })
          }

        } catch (error) {
          // Skip files that can't be read
        }
      }
    })
  }

  async checkSecrets() {
    console.log('🔐 Verificando manejo de secrets...')

    // Buscar archivos que podrían contener secrets
    const secretFiles = this.findFiles(['.env', '.key', '.pem', '.crt'])
    
    secretFiles.forEach(file => {
      if (!file.includes('.example') && !file.includes('.template')) {
        this.addFinding({
          category: 'SECRETS',
          severity: 'HIGH',
          title: `Potential secret file: ${file}`,
          file,
          recommendation: 'Ensure secret files are not committed to version control'
        })
      }
    })

    // Verificar .gitignore
    if (fs.existsSync('.gitignore')) {
      const gitignore = fs.readFileSync('.gitignore', 'utf8')
      
      const requiredIgnores = ['.env', 'node_modules/', '*.log', '.DS_Store']
      requiredIgnores.forEach(pattern => {
        if (!gitignore.includes(pattern)) {
          this.addFinding({
            category: 'SECRETS',
            severity: 'MEDIUM',
            title: `Missing .gitignore pattern: ${pattern}`,
            recommendation: `Add '${pattern}' to .gitignore`
          })
        }
      })
    } else {
      this.addFinding({
        category: 'SECRETS',
        severity: 'HIGH',
        title: 'Missing .gitignore file',
        recommendation: 'Create .gitignore file to prevent committing sensitive files'
      })
    }
  }

  async checkInfrastructure() {
    console.log('🏗️ Verificando infraestructura...')

    // Verificar Dockerfile si existe
    if (fs.existsSync('Dockerfile')) {
      const dockerfile = fs.readFileSync('Dockerfile', 'utf8')

      if (dockerfile.includes('FROM') && dockerfile.includes('root')) {
        this.addFinding({
          category: 'INFRASTRUCTURE',
          severity: 'MEDIUM',
          title: 'Running as root in Docker',
          file: 'Dockerfile',
          recommendation: 'Create non-root user for running the application'
        })
      }

      if (!dockerfile.includes('USER') && !dockerfile.includes('non-root')) {
        this.addFinding({
          category: 'INFRASTRUCTURE',
          severity: 'LOW',
          title: 'No non-root user specified',
          file: 'Dockerfile',
          recommendation: 'Specify a non-root user for security'
        })
      }
    }

    // Verificar docker-compose si existe
    if (fs.existsSync('docker-compose.yml')) {
      const compose = fs.readFileSync('docker-compose.yml', 'utf8')

      if (compose.includes('ports:') && !compose.includes('networks:')) {
        this.addFinding({
          category: 'INFRASTRUCTURE',
          severity: 'LOW',
          title: 'Exposed ports without network isolation',
          file: 'docker-compose.yml',
          recommendation: 'Use Docker networks for service isolation'
        })
      }
    }
  }

  async checkCompliance() {
    console.log('📋 Verificando cumplimiento...')

    // OWASP Top 10 checks
    const owaspChecks = [
      {
        id: 'A01:2021',
        name: 'Broken Access Control',
        checks: ['Verify user permissions are properly enforced']
      },
      {
        id: 'A02:2021',
        name: 'Cryptographic Failures',
        checks: ['Ensure proper encryption of sensitive data']
      },
      {
        id: 'A03:2021',
        name: 'Injection',
        checks: ['Validate all user inputs', 'Use parameterized queries']
      },
      {
        id: 'A04:2021',
        name: 'Insecure Design',
        checks: ['Implement secure by design principles']
      },
      {
        id: 'A05:2021',
        name: 'Security Misconfiguration',
        checks: ['Review security configurations']
      },
      {
        id: 'A06:2021',
        name: 'Vulnerable Components',
        checks: ['Keep dependencies updated', 'Remove unused dependencies']
      },
      {
        id: 'A07:2021',
        name: 'Identification & Authentication Failures',
        checks: ['Implement proper authentication mechanisms']
      },
      {
        id: 'A08:2021',
        name: 'Software Integrity Failures',
        checks: ['Verify integrity of software components']
      },
      {
        id: 'A09:2021',
        name: 'Logging & Monitoring Failures',
        checks: ['Implement proper logging and monitoring']
      },
      {
        id: 'A10:2021',
        name: 'Server-Side Request Forgery',
        checks: ['Validate and sanitize URLs']
      }
    ]

    // Placeholder - estas verificaciones requieren análisis manual
    owaspChecks.forEach(category => {
      this.addFinding({
        category: 'COMPLIANCE',
        severity: 'INFO',
        title: `OWASP ${category.id}: ${category.name}`,
        description: `Review: ${category.checks.join(', ')}`,
        recommendation: 'Conduct manual review for this OWASP category'
      })
    })
  }

  findFiles(extensions) {
    const files = []
    const walk = (dir) => {
      if (!fs.existsSync(dir)) return
      
      const items = fs.readdirSync(dir)
      items.forEach(item => {
        const path = `${dir}/${item}`
        const stat = fs.statSync(path)
        
        if (stat.isDirectory() && !item.startsWith('.') && item !== 'node_modules') {
          walk(path)
        } else if (stat.isFile()) {
          const ext = item.substring(item.lastIndexOf('.'))
          if (extensions.includes(ext) || extensions.some(e => item.includes(e))) {
            files.push(path)
          }
        }
      })
    }
    
    walk('.')
    return files
  }

  addFinding(finding) {
    this.findings.push({
      id: `SEC-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      timestamp: new Date().toISOString(),
      ...finding
    })
  }

  generateReport() {
    const report = {
      timestamp: new Date().toISOString(),
      summary: {
        totalFindings: this.findings.length,
        critical: this.findings.filter(f => f.severity === 'CRITICAL').length,
        high: this.findings.filter(f => f.severity === 'HIGH').length,
        medium: this.findings.filter(f => f.severity === 'MEDIUM').length,
        low: this.findings.filter(f => f.severity === 'LOW').length,
        info: this.findings.filter(f => f.severity === 'INFO').length
      },
      findings: this.findings.sort((a, b) => this.severityLevels[b.severity] - this.severityLevels[a.severity])
    }

    fs.writeFileSync('security-audit-report.json', JSON.stringify(report, null, 2))

    console.log('\n🔒 Security Audit Report')
    console.log('========================')
    console.log(`Total findings: ${report.summary.totalFindings}`)
    console.log(`Critical: ${report.summary.critical}`)
    console.log(`High: ${report.summary.high}`)
    console.log(`Medium: ${report.summary.medium}`)
    console.log(`Low: ${report.summary.low}`)
    console.log(`Info: ${report.summary.info}`)

    if (report.findings.length > 0) {
      console.log('\n🚨 Critical & High Severity Findings:')
      report.findings
        .filter(f => f.severity === 'CRITICAL' || f.severity === 'HIGH')
        .slice(0, 10)
        .forEach(finding => {
          console.log(`\n[${finding.severity}] ${finding.title}`)
          console.log(`Category: ${finding.category}`)
          if (finding.file) console.log(`File: ${finding.file}`)
          if (finding.line) console.log(`Line: ${finding.line}`)
          console.log(`Recommendation: ${finding.recommendation}`)
        })
    }

    return report
  }

  generateRemediationPlan() {
    const plan = {
      immediate: this.findings.filter(f => f.severity === 'CRITICAL'),
      high: this.findings.filter(f => f.severity === 'HIGH'),
      medium: this.findings.filter(f => f.severity === 'MEDIUM'),
      low: this.findings.filter(f => f.severity === 'LOW'),
      info: this.findings.filter(f => f.severity === 'INFO')
    }

    fs.writeFileSync('security-remediation-plan.json', JSON.stringify(plan, null, 2))

    console.log('\n📋 Remediation Plan Generated')
    console.log('=============================')
    console.log(`Immediate (Critical): ${plan.immediate.length}`)
    console.log(`High Priority: ${plan.high.length}`)
    console.log(`Medium Priority: ${plan.medium.length}`)
    console.log(`Low Priority: ${plan.low.length}`)
    console.log(`Informational: ${plan.info.length}`)

    return plan
  }
}

// Ejecutar auditoría
const auditor = new SecurityAuditor()
auditor.runFullAudit()
```

### 4. Checklist de Security Audit Manual
```markdown
## Security Audit Checklist Manual

### Autenticación y Autorización:
- [ ] **Password Policy**: Longitud mínima, complejidad, expiración
- [ ] **Multi-Factor Authentication**: Implementado para accesos críticos
- [ ] **Session Management**: Timeouts apropiados, invalidación correcta
- [ ] **Role-Based Access**: Principio de menor privilegio aplicado
- [ ] **API Authentication**: JWT, OAuth, API keys implementados correctamente
- [ ] **Password Storage**: Hashing seguro (bcrypt, argon2)
- [ ] **Brute Force Protection**: Rate limiting implementado

### Manejo de Datos:
- [ ] **Data Encryption**: Datos sensibles encriptados en reposo y tránsito
- [ ] **Input Validation**: Sanitización de todas las entradas de usuario
- [ ] **Output Encoding**: Prevención de XSS en outputs
- [ ] **SQL Injection**: Consultas parametrizadas o ORMs seguros
- [ ] **File Upload Security**: Validación de tipos, tamaños, contenido
- [ ] **Sensitive Data Logging**: No loggear passwords, tokens, PII

### Configuración de Seguridad:
- [ ] **HTTPS Everywhere**: Certificados válidos, HSTS implementado
- [ ] **Security Headers**: CSP, X-Frame-Options, X-Content-Type-Options
- [ ] **CORS Policy**: Configuración restrictiva de orígenes permitidos
- [ ] **Error Handling**: Mensajes de error no revelan información sensible
- [ ] **Debug Mode**: Deshabilitado en producción
- [ ] **Default Credentials**: Cambiados en todos los sistemas
- [ ] **Unnecessary Services**: Deshabilitados o removidos

### Infraestructura y Red:
- [ ] **Firewall Rules**: Reglas restrictivas implementadas
- [ ] **Network Segmentation**: Separación de redes sensibles
- [ ] **VPN Access**: Acceso remoto seguro requerido
- [ ] **Monitoring**: IDS/IPS, logging de red implementado
- [ ] **Backup Security**: Backups encriptados y acceso restringido
- [ ] **Patch Management**: Sistema de actualizaciones implementado

### Compliance y Governance:
- [ ] **Security Training**: Equipo capacitado en seguridad
- [ ] **Incident Response**: Plan documentado y testeado
- [ ] **Regular Audits**: Auditorías periódicas programadas
- [ ] **Third-Party Risk**: Evaluación de proveedores
- [ ] **Legal Compliance**: Cumplimiento de regulaciones aplicables
- [ ] **Security Metrics**: KPIs de seguridad definidos y monitoreados
```

### 5. Reporte Ejecutivo y Técnico
```markdown
## Security Audit Report Template

### Executive Summary
[Resumen ejecutivo de 1-2 páginas con hallazgos críticos y recomendaciones de alto nivel]

### Methodology
[Descripción de las metodologías utilizadas en la auditoría]

### Scope
[Sistemas, aplicaciones y periodos de tiempo incluidos en la auditoría]

### Findings Summary
[Resumen estadístico de hallazgos por severidad y categoría]

### Critical Findings
[Detalle de vulnerabilidades críticas con impacto y recomendaciones]

### High Risk Findings
[Detalle de vulnerabilidades de alto riesgo]

### Medium Risk Findings
[Detalle de vulnerabilidades de riesgo medio]

### Low Risk Findings
[Detalle de vulnerabilidades de bajo riesgo]

### Compliance Assessment
[Evaluación de cumplimiento con estándares y regulaciones]

### Remediation Plan
[Plan detallado de corrección con prioridades y timelines]

### Conclusions
[Conclusiones generales y recomendaciones estratégicas]

### Appendices
- Detailed vulnerability descriptions
- Code samples and proofs of concept
- Tool outputs and scan results
- Configuration files reviewed
```

### 6. Plan de Remediation
```javascript
// scripts/security-remediation-tracker.js
const fs = require('fs')

class RemediationTracker {
  constructor() {
    this.remediationPlan = this.loadRemediationPlan()
    this.statusOptions = ['OPEN', 'IN_PROGRESS', 'RESOLVED', 'ACCEPTED_RISK']
  }

  loadRemediationPlan() {
    try {
      return JSON.parse(fs.readFileSync('security-remediation-plan.json', 'utf8'))
    } catch (error) {
      return { immediate: [], high: [], medium: [], low: [], info: [] }
    }
  }

  updateFindingStatus(findingId, status, notes = '') {
    const allFindings = [
      ...this.remediationPlan.immediate,
      ...this.remediationPlan.high,
      ...this.remediationPlan.medium,
      ...this.remediationPlan.low,
      ...this.remediationPlan.info
    ]

    const finding = allFindings.find(f => f.id === findingId)
    if (finding) {
      finding.status = status
      finding.lastUpdated = new Date().toISOString()
      finding.notes = notes

      this.saveRemediationPlan()
      console.log(`✅ Updated ${findingId} to ${status}`)
    } else {
      console.log(`❌ Finding ${findingId} not found`)
    }
  }

  getStatusSummary() {
    const allFindings = [
      ...this.remediationPlan.immediate,
      ...this.remediationPlan.high,
      ...this.remediationPlan.medium,
      ...this.remediationPlan.low,
      ...this.remediationPlan.info
    ]

    const summary = {
      total: allFindings.length,
      open: allFindings.filter(f => f.status !== 'RESOLVED' && f.status !== 'ACCEPTED_RISK').length,
      resolved: allFindings.filter(f => f.status === 'RESOLVED').length,
      acceptedRisk: allFindings.filter(f => f.status === 'ACCEPTED_RISK').length,
      bySeverity: {
        CRITICAL: allFindings.filter(f => f.severity === 'CRITICAL').length,
        HIGH: allFindings.filter(f => f.severity === 'HIGH').length,
        MEDIUM: allFindings.filter(f => f.severity === 'MEDIUM').length,
        LOW: allFindings.filter(f => f.severity === 'LOW').length,
        INFO: allFindings.filter(f => f.severity === 'INFO').length
      }
    }

    console.log('\n📊 Remediation Status Summary')
    console.log('=============================')
    console.log(`Total findings: ${summary.total}`)
    console.log(`Open: ${summary.open}`)
    console.log(`Resolved: ${summary.resolved}`)
    console.log(`Accepted risk: ${summary.acceptedRisk}`)
    console.log('\nBy severity:')
    Object.entries(summary.bySeverity).forEach(([severity, count]) => {
      console.log(`  ${severity}: ${count}`)
    })

    return summary
  }

  generateProgressReport() {
    const summary = this.getStatusSummary()
    const progress = ((summary.resolved + summary.acceptedRisk) / summary.total) * 100

    const report = {
      timestamp: new Date().toISOString(),
      progress: Math.round(progress * 100) / 100,
      summary,
      nextSteps: this.getNextSteps()
    }

    fs.writeFileSync('security-remediation-progress.json', JSON.stringify(report, null, 2))

    console.log(`\n📈 Overall Progress: ${report.progress}%`)

    return report
  }

  getNextSteps() {
    const openCritical = this.remediationPlan.immediate.filter(f => f.status !== 'RESOLVED' && f.status !== 'ACCEPTED_RISK')
    const openHigh = this.remediationPlan.high.filter(f => f.status !== 'RESOLVED' && f.status !== 'ACCEPTED_RISK')

    const nextSteps = []

    if (openCritical.length > 0) {
      nextSteps.push(`Address ${openCritical.length} critical security findings immediately`)
    }

    if (openHigh.length > 0) {
      nextSteps.push(`Address ${openHigh.length} high-risk security findings`)
    }

    if (nextSteps.length === 0) {
      nextSteps.push('All critical and high-risk findings have been addressed')
    }

    return nextSteps
  }

  saveRemediationPlan() {
    fs.writeFileSync('security-remediation-plan.json', JSON.stringify(this.remediationPlan, null, 2))
  }

  // CLI interface
  static runCommand(args) {
    const tracker = new RemediationTracker()

    switch (args[0]) {
      case 'status':
        tracker.getStatusSummary()
        break
      case 'update':
        tracker.updateFindingStatus(args[1], args[2], args.slice(3).join(' '))
        break
      case 'progress':
        tracker.generateProgressReport()
        break
      default:
        console.log('Usage: node security-remediation-tracker.js <command> [args]')
        console.log('Commands:')
        console.log('  status                    - Show remediation status summary')
        console.log('  update <id> <status>      - Update finding status')
        console.log('  progress                  - Generate progress report')
    }
  }
}

// CLI execution
if (require.main === module) {
  RemediationTracker.runCommand(process.argv.slice(2))
}

module.exports = RemediationTracker
```

### 7. CI/CD Integration
```yaml
# .github/workflows/security-audit.yml
name: Security Audit
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
  schedule:
    - cron: '0 2 * * 1' # Weekly security audit

jobs:
  security-audit:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run automated security audit
        run: node scripts/security-audit.js

      - name: Upload security report
        uses: actions/upload-artifact@v3
        with:
          name: security-audit-report
          path: |
            security-audit-report.json
            security-remediation-plan.json

      - name: Security audit notification
        if: always()
        run: |
          CRITICAL=$(jq '.summary.critical' security-audit-report.json)
          HIGH=$(jq '.summary.high' security-audit-report.json)

          if [ "$CRITICAL" -gt 0 ] || [ "$HIGH" -gt 0 ]; then
            echo "🚨 Security audit found $CRITICAL critical and $HIGH high severity issues"
            # Send notification to security team
            curl -X POST -H 'Content-type: application/json' \
              --data "{\"text\":\"🚨 Security audit found issues: $CRITICAL critical, $HIGH high\"}" \
              ${{ secrets.SECURITY_WEBHOOK_URL }}
          fi

  dependency-scan:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'

      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v2
        if: always()
        with:
          sarif_file: 'trivy-results.sarif'

  secrets-scan:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run TruffleHog OSS
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base: main
          head: HEAD
          extra_args: --debug --only-verified

  compliance-check:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18

      - name: Install dependencies
        run: npm ci

      - name: Run license compliance check
        run: |
          npm install -g license-checker
          license-checker --production --json > production-licenses.json
          license-checker --development --json > dev-licenses.json

      - name: Check for GPL licenses
        run: |
          if jq -r '.[] | select(.licenses | contains("GPL")) | .name' production-licenses.json | grep -q .; then
            echo "⚠️ GPL licensed dependencies found in production"
            exit 1
          fi

      - name: Upload license reports
        uses: actions/upload-artifact@v3
        with:
          name: license-reports
          path: |
            production-licenses.json
            dev-licenses.json
```

### 8. Mejores Prácticas
- **Shift Left Security**: Integrar seguridad desde el inicio del desarrollo
- **Defense in Depth**: Múltiples capas de controles de seguridad
- **Zero Trust**: Verificar todas las requests y accesos
- **Fail Secure**: Sistema seguro por defecto, permisos explícitos
- **Regular Audits**: Auditorías periódicas y continuas
- **Security Training**: Capacitación continua del equipo
- **Incident Response**: Plan documentado y practicado
- **Continuous Monitoring**: Monitoreo 24/7 de seguridad

### 9. Recursos Adicionales
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [SANS Security Policy Templates](https://www.sans.org/information-security-policy/)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [CIS Controls](https://www.cisecurity.org/controls/)
