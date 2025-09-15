---
description: Code Review - Checklist y proceso para revisiones de código
---

# Code Review Workflow

Proceso estructurado para revisiones de código efectivas que mejoran calidad y consistencia.

## Pre-requisitos
- Pull request/merge request creado
- Código siguiendo estándares del equipo
- Tests pasando
- Documentación actualizada

## Pasos del Workflow

### 1. Preparación para Code Review
```markdown
## Checklist Pre-Review

### Autor del PR:
- [ ] **Commits claros**: Mensajes descriptivos siguiendo conventional commits
- [ ] **Tests incluidos**: Cobertura apropiada para cambios realizados
- [ ] **Documentación**: README, comentarios, API docs actualizados
- [ ] **Linting**: Código pasa todas las reglas de linting
- [ ] **Build passing**: Aplicación compila sin errores
- [ ] **Breaking changes**: Documentados si existen
- [ ] **Dependencias**: Nuevas dependencias justificadas y seguras

### Revisor:
- [ ] **Contexto claro**: Entender propósito y alcance del cambio
- [ ] **Tiempo suficiente**: Dedicar tiempo completo a la revisión
- [ ] **Ambiente listo**: Código descargado y ejecutándose localmente
- [ ] **Herramientas listas**: IDE configurado para revisión
```

### 2. Checklist de Code Review Técnico
```markdown
## Code Review Checklist

### Arquitectura & Diseño:
- [ ] **Principios SOLID**: Código sigue principios de diseño orientado a objetos
- [ ] **Separación de responsabilidades**: Cada módulo/clase tiene responsabilidad clara
- [ ] **Acoplamiento bajo**: Dependencias mínimas entre componentes
- [ ] **Cohesión alta**: Funcionalidad relacionada agrupada apropiadamente
- [ ] **Patrones de diseño**: Uso apropiado de patrones establecidos
- [ ] **Escalabilidad**: Código preparado para crecimiento futuro

### Calidad del Código:
- [ ] **Nombres descriptivos**: Variables, funciones, clases con nombres claros
- [ ] **Funciones pequeñas**: Métodos < 30 líneas, funciones < 50 líneas
- [ ] **Complejidad ciclomática**: < 10 por función
- [ ] **Duplicación**: No hay código duplicado (DRY principle)
- [ ] **Comentarios útiles**: Explican "por qué" no "qué"
- [ ] **Constantes en lugar de magia**: Números/strings hardcodeados extraídos
- [ ] **Manejo de errores**: Try/catch apropiados, errores descriptivos

### Seguridad:
- [ ] **Input validation**: Todos los inputs validados y sanitizados
- [ ] **Autenticación/Autorización**: Controles apropiados implementados
- [ ] **Sensitive data**: No hay secrets hardcodeados
- [ ] **SQL Injection**: Consultas parametrizadas o ORMs seguros
- [ ] **XSS Prevention**: Output encoding apropiado
- [ ] **CSRF Protection**: Tokens implementados donde necesario

### Performance:
- [ ] **Queries eficientes**: No hay N+1 queries, índices apropiados
- [ ] **Lazy loading**: Implementado donde beneficia
- [ ] **Caching**: Estrategias implementadas para datos frecuentemente accedidos
- [ ] **Memory leaks**: Recursos liberados apropiadamente
- [ ] **Bundle size**: Optimizaciones para tamaño de bundle
- [ ] **Time complexity**: Algoritmos eficientes (O(n) preferido sobre O(n²))

### Testing:
- [ ] **Unit tests**: Cobertura > 80% para lógica nueva
- [ ] **Integration tests**: Flujos completos testeados
- [ ] **Edge cases**: Casos límite considerados y testeados
- [ ] **Error scenarios**: Manejo de errores testeado
- [ ] **Mocks apropiados**: External dependencies mockeadas
- [ ] **Test naming**: Nombres descriptivos siguiendo patrón

### Accesibilidad:
- [ ] **WCAG compliance**: Cumple con estándares de accesibilidad
- [ ] **Semantic HTML**: Uso correcto de elementos semánticos
- [ ] **Keyboard navigation**: Funcionalidad operable por teclado
- [ ] **Screen readers**: Compatible con lectores de pantalla
- [ ] **Color contrast**: Contraste apropiado para legibilidad
- [ ] **Alt text**: Imágenes con texto alternativo descriptivo

### Documentación:
- [ ] **Inline comments**: Complejos algoritmos documentados
- [ ] **Function documentation**: JSDoc/TSDoc para APIs públicas
- [ ] **README updates**: Cambios documentados en README
- [ ] **API documentation**: Endpoints documentados (Swagger/OpenAPI)
- [ ] **Breaking changes**: Documentados en CHANGELOG
- [ ] **Migration guides**: Para cambios que requieren migración
```

### 3. Proceso de Code Review
```markdown
## Code Review Process

### Fase 1: Auto-Review (Autor)
1. **Ejecutar tests**: Asegurarse que pasan localmente
2. **Linting**: Correr linters y arreglar issues
3. **Build**: Verificar que compila correctamente
4. **Coverage**: Revisar cobertura de tests
5. **Self-review**: Leer código como si fuera de otra persona

### Fase 2: Peer Review (Revisor)
1. **Entender contexto**: Leer descripción del PR y tickets relacionados
2. **Revisar cambios**: Ver diff completo, no solo archivos modificados
3. **Ejecutar código**: Probar cambios localmente
4. **Verificar tests**: Ejecutar suite completa
5. **Documentar feedback**: Comentarios claros y constructivos

### Fase 3: Iteración
1. **Discutir findings**: Conversación constructiva sobre issues encontrados
2. **Priorizar fixes**: Critical bugs primero, luego mejoras
3. **Implementar cambios**: Autor hace correcciones
4. **Re-review**: Revisor verifica correcciones
5. **Aprobar**: Cuando todo esté correcto

### Fase 4: Merge
1. **Final checks**: Build y tests pasan en CI
2. **Merge strategy**: Squash, merge commit, o rebase según política
3. **Deploy**: Monitorear deployment post-merge
4. **Follow-up**: Revisar métricas y feedback post-deploy
```

### 4. Guías para Comentarios Efectivos
```markdown
## Effective Code Review Comments

### ✅ Buenos Comentarios:
- **Específicos**: "Esta función es compleja, considera dividirla en dos"
- **Constructivos**: "En lugar de usar un for loop, considera map() para claridad"
- **Con contexto**: "Esta query podría causar N+1, aquí está la explicación..."
- **Con sugerencias**: "Para mejorar performance, podríamos usar memoización aquí"

### ❌ Comentarios Problemáticos:
- **Vagos**: "Esto está mal" (¿Por qué? ¿Cómo mejorar?)
- **Demandantes**: "Cambia esto ahora" (sin explicación)
- **Sarcásticos**: "Wow, qué código tan creativo" (desmotivador)
- **Off-topic**: "También necesitamos cambiar el logo" (no relacionado)

### Plantillas de Comentarios:

#### Para Issues Críticos:
```
🔴 **Critical Issue**
Esta vulnerabilidad podría exponer datos sensibles.

**Problema:** Input no sanitizado permite SQL injection
**Evidencia:** Línea 45: `query(\`SELECT * FROM users WHERE id = \${userId}\`)`
**Solución:** Usar prepared statements o ORM con sanitización
**Severidad:** High
```

#### Para Mejoras Sugeridas:
```
💡 **Improvement Suggestion**
Esta función podría ser más legible dividiéndola.

**Actual:** 50 líneas manejando validación, parsing y response
**Sugerido:** Separar en `validateInput()`, `parseData()`, `buildResponse()`
**Beneficio:** Más fácil de testear y mantener
```

#### Para Preguntas:
```
❓ **Question**
¿Hay alguna razón específica para usar este algoritmo sobre el estándar?

**Contexto:** Usando custom sorting vs Array.sort()
**Alternativa:** Considerar Array.sort() para consistencia
```
```

### 5. Automatización de Code Review
```javascript
// scripts/automated-code-review.js
const { execSync } = require('child_process')
const fs = require('fs')

class AutomatedCodeReviewer {
  constructor() {
    this.issues = []
  }

  async reviewCode() {
    console.log('🔍 Running automated code review...')

    // Ejecutar herramientas automáticas
    await this.runESLint()
    await this.runPrettier()
    await this.checkTestCoverage()
    await this.runSecurityScan()
    await this.checkDependencies()
    await this.analyzeComplexity()

    // Generar reporte
    this.generateReport()
  }

  async runESLint() {
    console.log('🔍 Running ESLint...')
    try {
      const output = execSync('npx eslint src/ --format json', { encoding: 'utf8' })
      const results = JSON.parse(output)

      results.forEach(result => {
        result.messages.forEach(message => {
          this.issues.push({
            type: 'lint',
            severity: message.severity,
            file: result.filePath,
            line: message.line,
            message: message.message,
            rule: message.ruleId
          })
        })
      })
    } catch (error) {
      console.log('ESLint found issues')
    }
  }

  async runPrettier() {
    console.log('🔍 Checking code formatting...')
    try {
      execSync('npx prettier --check src/', { stdio: 'inherit' })
    } catch (error) {
      this.issues.push({
        type: 'format',
        severity: 2,
        message: 'Code formatting issues found. Run `npm run format`'
      })
    }
  }

  async checkTestCoverage() {
    console.log('🔍 Checking test coverage...')
    try {
      const output = execSync('npm run test:coverage', { encoding: 'utf8' })
      // Parse coverage report
      const coverageMatch = output.match(/All files[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*(\d+)%/)
      const coverage = coverageMatch ? parseInt(coverageMatch[1]) : 0

      if (coverage < 80) {
        this.issues.push({
          type: 'coverage',
          severity: 1,
          message: `Test coverage is ${coverage}%. Minimum required: 80%`
        })
      }
    } catch (error) {
      this.issues.push({
        type: 'coverage',
        severity: 2,
        message: 'Failed to run test coverage'
      })
    }
  }

  async runSecurityScan() {
    console.log('🔍 Running security scan...')
    try {
      execSync('npm audit --audit-level moderate', { stdio: 'inherit' })
    } catch (error) {
      this.issues.push({
        type: 'security',
        severity: 2,
        message: 'Security vulnerabilities found in dependencies'
      })
    }
  }

  async checkDependencies() {
    console.log('🔍 Checking dependencies...')
    try {
      const output = execSync('npm outdated --json', { encoding: 'utf8' })
      const outdated = JSON.parse(output)

      if (Object.keys(outdated).length > 0) {
        this.issues.push({
          type: 'dependencies',
          severity: 1,
          message: `${Object.keys(outdated).length} dependencies are outdated`
        })
      }
    } catch (error) {
      // npm outdated can fail if no package.json
    }
  }

  async analyzeComplexity() {
    console.log('🔍 Analyzing code complexity...')
    // This would require additional tools like complexity-report
    // For now, just check for long files
    const files = this.getSourceFiles()
    files.forEach(file => {
      const stats = fs.statSync(file)
      const lines = fs.readFileSync(file, 'utf8').split('\n').length

      if (lines > 300) {
        this.issues.push({
          type: 'complexity',
          severity: 1,
          file,
          message: `File is ${lines} lines long. Consider splitting into smaller files`
        })
      }
    })
  }

  getSourceFiles() {
    const walk = (dir) => {
      let results = []
      const list = fs.readdirSync(dir)
      list.forEach(file => {
        file = dir + '/' + file
        const stat = fs.statSync(file)
        if (stat && stat.isDirectory() && !file.includes('node_modules')) {
          results = results.concat(walk(file))
        } else if (file.endsWith('.js') || file.endsWith('.ts') || file.endsWith('.tsx')) {
          results.push(file)
        }
      })
      return results
    }
    return walk('./src')
  }

  generateReport() {
    const report = {
      timestamp: new Date().toISOString(),
      totalIssues: this.issues.length,
      issuesByType: {},
      issuesBySeverity: { 1: 0, 2: 0 }
    }

    this.issues.forEach(issue => {
      report.issuesByType[issue.type] = (report.issuesByType[issue.type] || 0) + 1
      report.issuesBySeverity[issue.severity]++
    })

    fs.writeFileSync('code-review-report.json', JSON.stringify({ report, issues: this.issues }, null, 2))

    console.log('📊 Code Review Report:')
    console.log(`Total issues: ${report.totalIssues}`)
    console.log(`Low severity: ${report.issuesBySeverity[1]}`)
    console.log(`High severity: ${report.issuesBySeverity[2]}`)

    if (this.issues.length > 0) {
      console.log('\n🔍 Issues found:')
      this.issues.slice(0, 10).forEach(issue => {
        const severity = issue.severity === 2 ? '🔴' : '🟡'
        console.log(`${severity} ${issue.type}: ${issue.message}`)
        if (issue.file) console.log(`   File: ${issue.file}`)
      })

      if (this.issues.length > 10) {
        console.log(`... and ${this.issues.length - 10} more issues`)
      }
    }

    return report
  }
}

// Ejecutar revisión automática
const reviewer = new AutomatedCodeReviewer()
reviewer.reviewCode()
```

### 6. CI/CD Integration
```yaml
# .github/workflows/code-review.yml
name: Code Review Automation
on: [pull_request]

jobs:
  automated-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Run automated code review
        run: node scripts/automated-code-review.js

      - name: Upload review report
        uses: actions/upload-artifact@v3
        with:
          name: code-review-report
          path: code-review-report.json

      - name: Comment PR with review results
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs')
            const report = JSON.parse(fs.readFileSync('./code-review-report.json', 'utf8'))

            let comment = '## 🤖 Automated Code Review Results\n\n'

            if (report.issues.length === 0) {
              comment += '✅ **All checks passed!**\n\n'
              comment += 'Great job! Your code looks good to merge.\n'
            } else {
              comment += `⚠️ **Found ${report.issues.length} issues**\n\n`

              const highSeverity = report.issues.filter(i => i.severity === 2)
              const lowSeverity = report.issues.filter(i => i.severity === 1)

              if (highSeverity.length > 0) {
                comment += `🔴 **${highSeverity.length} high severity issues:**\n`
                highSeverity.slice(0, 5).forEach(issue => {
                  comment += `- ${issue.message}\n`
                  if (issue.file) comment += `  \`${issue.file}\`\n`
                })
                comment += '\n'
              }

              if (lowSeverity.length > 0) {
                comment += `🟡 **${lowSeverity.length} low severity issues:**\n`
                lowSeverity.slice(0, 3).forEach(issue => {
                  comment += `- ${issue.message}\n`
                })
                comment += '\n'
              }
            }

            comment += '### 📋 Manual Review Checklist\n'
            comment += '- [ ] Code follows team conventions\n'
            comment += '- [ ] Security best practices applied\n'
            comment += '- [ ] Performance considerations addressed\n'
            comment += '- [ ] Tests are comprehensive\n'
            comment += '- [ ] Documentation is updated\n'

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: comment
            })
```

### 7. Guías para Aprobación de PRs
```markdown
## Pull Request Approval Guidelines

### ✅ Aprobación Inmediata:
- Cambios triviales (typos, formatting)
- Hotfixes críticos con tests incluidos
- Cambios siguiendo exactamente patrones existentes
- Actualizaciones de documentación únicamente

### 🔄 Aprobación Condicional:
- Nuevas features con tests completos
- Refactoring con impacto limitado
- Cambios de configuración bien documentados
- Actualizaciones de dependencias no críticas

### ❌ Requiere Discusión Adicional:
- Cambios arquitecturales significativos
- Nuevas dependencias sin evaluación de seguridad
- Breaking changes sin migration plan
- Código con deuda técnica significativa
- Cambios sin tests apropiados

### 🚫 Rechazo Automático:
- Código con vulnerabilidades de seguridad conocidas
- Tests fallando en CI
- Build roto
- Cobertura de tests < 80% para nueva funcionalidad
- Issues críticos de linting sin resolver
```

### 8. Métricas de Code Review
```javascript
// scripts/code-review-metrics.js
const fs = require('fs')
const { graphql } = require('@octokit/graphql')

class CodeReviewMetrics {
  constructor(token) {
    this.graphql = graphql.defaults({
      headers: {
        authorization: `token ${token}`
      }
    })
  }

  async getReviewMetrics(owner, repo, days = 30) {
    const query = `
      query($owner: String!, $repo: String!, $since: DateTime!) {
        repository(owner: $owner, name: $repo) {
          pullRequests(first: 100, states: MERGED, orderBy: {field: UPDATED_AT, direction: DESC}) {
            nodes {
              number
              title
              createdAt
              mergedAt
              reviews(first: 10) {
                nodes {
                  author {
                    login
                  }
                  state
                  submittedAt
                }
              }
              comments {
                totalCount
              }
            }
          }
        }
      }
    `

    const since = new Date(Date.now() - days * 24 * 60 * 60 * 1000).toISOString()

    const result = await this.graphql(query, { owner, repo, since })
    const prs = result.repository.pullRequests.nodes

    const metrics = {
      totalPRs: prs.length,
      avgReviewTime: 0,
      avgComments: 0,
      reviewsByUser: {},
      approvalRate: 0
    }

    let totalReviewTime = 0
    let totalComments = 0
    let approvedPRs = 0

    prs.forEach(pr => {
      const created = new Date(pr.createdAt)
      const merged = new Date(pr.mergedAt)
      const reviewTime = (merged - created) / (1000 * 60 * 60) // hours

      totalReviewTime += reviewTime
      totalComments += pr.comments.totalCount

      // Count reviews by user
      pr.reviews.nodes.forEach(review => {
        const user = review.author.login
        if (!metrics.reviewsByUser[user]) {
          metrics.reviewsByUser[user] = { total: 0, approved: 0 }
        }
        metrics.reviewsByUser[user].total++

        if (review.state === 'APPROVED') {
          metrics.reviewsByUser[user].approved++
          approvedPRs++
        }
      })
    })

    metrics.avgReviewTime = totalReviewTime / prs.length
    metrics.avgComments = totalComments / prs.length
    metrics.approvalRate = (approvedPRs / prs.length) * 100

    console.log('📊 Code Review Metrics:')
    console.log(`Total PRs: ${metrics.totalPRs}`)
    console.log(`Avg review time: ${metrics.avgReviewTime.toFixed(1)} hours`)
    console.log(`Avg comments: ${metrics.avgComments.toFixed(1)}`)
    console.log(`Approval rate: ${metrics.approvalRate.toFixed(1)}%`)

    return metrics
  }
}

// Uso
const metrics = new CodeReviewMetrics(process.env.GITHUB_TOKEN)
metrics.getReviewMetrics('owner', 'repo')
```

### 9. Mejores Prácticas
- **Tamaño óptimo de PR**: 200-400 líneas para revisión efectiva
- **Tiempo de respuesta**: Máximo 24 horas para primera revisión
- **Pair programming**: Para cambios complejos o críticos
- **Knowledge sharing**: Explicar decisiones técnicas en comentarios
- **Continuous learning**: Regularmente actualizar conocimientos del equipo
- **Tool adoption**: Usar herramientas que faciliten el proceso
- **Feedback culture**: Ambiente constructivo para feedback

### 10. Recursos Adicionales
- [Google Code Review Guidelines](https://google.github.io/eng-practices/review/)
- [Thoughtbot Code Review](https://github.com/thoughtbot/guides/tree/master/code-review)
- [Microsoft Code Review Checklist](https://docs.microsoft.com/en-us/azure/devops/learn/devops-at-microsoft/code-reviews)
- [GitHub Code Review Tools](https://github.com/features/code-review)
