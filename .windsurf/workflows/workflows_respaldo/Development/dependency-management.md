---
description: Dependency Management - Gestión y auditoría de dependencias
---

# Dependency Management Workflow

Sistema completo para gestionar, auditar y mantener dependencias de proyecto de forma segura y eficiente.

## Pre-requisitos
- package.json configurado
- Node.js/npm o gestor de paquetes equivalente
- CI/CD configurado
- Equipo alineado en política de dependencias

## Pasos del Workflow

### 1. Configuración Inicial de Dependencias
```json
// package.json con configuración optimizada
{
  "name": "my-project",
  "version": "1.0.0",
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "dependencies": {
    // Solo dependencias de producción necesarias
  },
  "devDependencies": {
    // Herramientas de desarrollo
  },
  "peerDependencies": {
    // Dependencias requeridas por el usuario
  }
}
```

### 2. Políticas de Dependencias
```markdown
## Dependency Policy

### Tipos de Dependencias:
- **dependencies**: Código necesario en producción
- **devDependencies**: Solo para desarrollo/testing
- **peerDependencies**: Dependencias que el usuario debe instalar
- **optionalDependencies**: Dependencias opcionales

### Reglas Generales:
- ✅ **Usar versiones fijas** para estabilidad
- ✅ **Auditoría semanal** de vulnerabilidades
- ✅ **Actualizaciones regulares** pero controladas
- ✅ **Zero dependencias innecesarias**
- ✅ **Preferir mantenidas** sobre populares
- ❌ **No usar versiones con ~ o ^** en producción
- ❌ **No depender de GitHub URLs** directamente
- ❌ **No ignorar vulnerabilidades** críticas

### Proceso de Adición:
1. Evaluar necesidad real
2. Verificar alternativas
3. Revisar mantenimiento y comunidad
4. Probar integración
5. Documentar decisión
```

### 3. Scripts de Gestión de Dependencias
```json
// package.json scripts
{
  "scripts": {
    "deps:check": "npm audit && npm outdated",
    "deps:update": "npm update && npm audit fix",
    "deps:audit": "npm audit --audit-level moderate",
    "deps:clean": "npm prune && npm dedupe",
    "deps:security": "npm audit --production",
    "deps:licenses": "npx license-checker --json > licenses.json",
    "deps:tree": "npm ls --depth=0",
    "deps:why": "npm ls <package-name>"
  }
}
```

### 4. Automatización de Auditorías
```javascript
// scripts/dependency-audit.js
const { execSync } = require('child_process')
const fs = require('fs')

class DependencyAuditor {
  constructor() {
    this.report = {
      timestamp: new Date().toISOString(),
      vulnerabilities: [],
      outdated: [],
      licenses: [],
      recommendations: []
    }
  }

  async runFullAudit() {
    console.log('🔍 Running comprehensive dependency audit...')

    await this.checkVulnerabilities()
    await this.checkOutdated()
    await this.analyzeLicenses()
    await this.checkBundleSize()
    await this.generateRecommendations()

    this.generateReport()
  }

  async checkVulnerabilities() {
    console.log('🔍 Checking for vulnerabilities...')

    try {
      const auditResult = execSync('npm audit --json', { encoding: 'utf8' })
      const audit = JSON.parse(auditResult)

      if (audit.vulnerabilities) {
        Object.values(audit.vulnerabilities).forEach(vuln => {
          this.report.vulnerabilities.push({
            package: vuln.name,
            severity: vuln.severity,
            title: vuln.title,
            url: vuln.url,
            fixAvailable: vuln.fixAvailable
          })
        })
      }
    } catch (error) {
      console.log('❌ Error checking vulnerabilities:', error.message)
    }
  }

  async checkOutdated() {
    console.log('🔍 Checking for outdated packages...')

    try {
      const outdatedResult = execSync('npm outdated --json', { encoding: 'utf8' })
      const outdated = JSON.parse(outdatedResult)

      Object.entries(outdated).forEach(([pkg, info]) => {
        this.report.outdated.push({
          package: pkg,
          current: info.current,
          latest: info.latest,
          type: info.type,
          daysOutdated: this.daysSinceUpdate(info.time)
        })
      })
    } catch (error) {
      // npm outdated exits with code 1 when there are outdated packages
      if (error.stdout) {
        const outdated = JSON.parse(error.stdout)
        Object.entries(outdated).forEach(([pkg, info]) => {
          this.report.outdated.push({
            package: pkg,
            current: info.current,
            latest: info.latest,
            type: info.type
          })
        })
      }
    }
  }

  async analyzeLicenses() {
    console.log('🔍 Analyzing package licenses...')

    try {
      const licensesResult = execSync('npx license-checker --json', { encoding: 'utf8' })
      const licenses = JSON.parse(licensesResult)

      const licenseSummary = {}
      Object.values(licenses).forEach(pkg => {
        const license = pkg.licenses || 'Unknown'
        licenseSummary[license] = (licenseSummary[license] || 0) + 1
      })

      this.report.licenses = Object.entries(licenseSummary)
        .map(([license, count]) => ({ license, count }))
        .sort((a, b) => b.count - a.count)

    } catch (error) {
      console.log('❌ Error analyzing licenses:', error.message)
    }
  }

  async checkBundleSize() {
    console.log('🔍 Analyzing bundle size impact...')

    try {
      const bundleResult = execSync('npx webpack-bundle-analyzer --mode production --json', {
        encoding: 'utf8',
        cwd: process.cwd()
      })

      // Parse bundle analyzer output
      // This would require additional parsing logic

    } catch (error) {
      console.log('⚠️  Bundle analysis not available or failed')
    }
  }

  async generateRecommendations() {
    console.log('🤔 Generating recommendations...')

    // Critical vulnerabilities
    const criticalVulns = this.report.vulnerabilities.filter(v => v.severity === 'critical')
    if (criticalVulns.length > 0) {
      this.report.recommendations.push({
        priority: 'CRITICAL',
        action: 'Fix critical vulnerabilities immediately',
        details: `${criticalVulns.length} critical vulnerabilities found`
      })
    }

    // Outdated dependencies
    const veryOutdated = this.report.outdated.filter(pkg => pkg.daysOutdated > 180)
    if (veryOutdated.length > 0) {
      this.report.recommendations.push({
        priority: 'HIGH',
        action: 'Update severely outdated dependencies',
        details: `${veryOutdated.length} packages outdated > 6 months`
      })
    }

    // License issues
    const unknownLicenses = this.report.licenses.find(l => l.license === 'Unknown')
    if (unknownLicenses && unknownLicenses.count > 0) {
      this.report.recommendations.push({
        priority: 'MEDIUM',
        action: 'Review packages with unknown licenses',
        details: `${unknownLicenses.count} packages have unknown licenses`
      })
    }
  }

  daysSinceUpdate(timeString) {
    if (!timeString) return 0
    const updateDate = new Date(timeString)
    const now = new Date()
    return Math.floor((now - updateDate) / (1000 * 60 * 60 * 24))
  }

  generateReport() {
    const summary = {
      totalVulnerabilities: this.report.vulnerabilities.length,
      criticalVulns: this.report.vulnerabilities.filter(v => v.severity === 'critical').length,
      highVulns: this.report.vulnerabilities.filter(v => v.severity === 'high').length,
      outdatedPackages: this.report.outdated.length,
      recommendations: this.report.recommendations.length
    }

    console.log('\n📊 Dependency Audit Report')
    console.log('========================')
    console.log(`Total vulnerabilities: ${summary.totalVulnerabilities}`)
    console.log(`  Critical: ${summary.criticalVulns}`)
    console.log(`  High: ${summary.highVulns}`)
    console.log(`Outdated packages: ${summary.outdatedPackages}`)
    console.log(`Recommendations: ${summary.recommendations}`)

    if (this.report.recommendations.length > 0) {
      console.log('\n💡 Recommendations:')
      this.report.recommendations.forEach(rec => {
        const icon = rec.priority === 'CRITICAL' ? '🚨' :
                     rec.priority === 'HIGH' ? '⚠️' : 'ℹ️'
        console.log(`${icon} ${rec.action}`)
        console.log(`   ${rec.details}`)
      })
    }

    // Save detailed report
    fs.writeFileSync('dependency-report.json', JSON.stringify(this.report, null, 2))
    console.log('\n📄 Detailed report saved to dependency-report.json')
  }

  async autoFix() {
    console.log('🔧 Attempting automatic fixes...')

    // Fix auto-fixable vulnerabilities
    try {
      execSync('npm audit fix', { stdio: 'inherit' })
      console.log('✅ Automatic vulnerability fixes applied')
    } catch (error) {
      console.log('⚠️  Some vulnerabilities could not be auto-fixed')
    }

    // Update minor/patch versions
    try {
      execSync('npm update', { stdio: 'inherit' })
      console.log('✅ Dependencies updated to latest compatible versions')
    } catch (error) {
      console.log('❌ Error updating dependencies')
    }
  }
}

// CLI interface
const args = process.argv.slice(2)
const auditor = new DependencyAuditor()

if (args.includes('--fix')) {
  auditor.runFullAudit().then(() => auditor.autoFix())
} else {
  auditor.runFullAudit()
}
```

### 5. Actualización Controlada de Dependencias
```javascript
// scripts/update-dependencies.js
const { execSync } = require('child_process')
const fs = require('fs')
const semver = require('semver')

class DependencyUpdater {
  constructor() {
    this.updates = {
      major: [],
      minor: [],
      patch: []
    }
  }

  async analyzeUpdates() {
    console.log('🔍 Analyzing available updates...')

    const outdatedResult = execSync('npm outdated --json', { encoding: 'utf8' })
    const outdated = JSON.parse(outdatedResult)

    Object.entries(outdated).forEach(([pkg, info]) => {
      const current = semver.parse(info.current)
      const latest = semver.parse(info.latest)

      if (latest.major > current.major) {
        this.updates.major.push({ package: pkg, current: info.current, latest: info.latest })
      } else if (latest.minor > current.minor) {
        this.updates.minor.push({ package: pkg, current: info.current, latest: info.latest })
      } else if (latest.patch > current.patch) {
        this.updates.patch.push({ package: pkg, current: info.current, latest: info.latest })
      }
    })

    this.displayUpdates()
  }

  displayUpdates() {
    console.log('\n📦 Available Updates:')
    console.log('===================')

    if (this.updates.patch.length > 0) {
      console.log(`\n🟢 Patch updates (${this.updates.patch.length}):`)
      this.updates.patch.forEach(update => {
        console.log(`  ${update.package}: ${update.current} → ${update.latest}`)
      })
    }

    if (this.updates.minor.length > 0) {
      console.log(`\n🟡 Minor updates (${this.updates.minor.length}):`)
      this.updates.minor.forEach(update => {
        console.log(`  ${update.package}: ${update.current} → ${update.latest}`)
      })
    }

    if (this.updates.major.length > 0) {
      console.log(`\n🔴 Major updates (${this.updates.major.length}):`)
      this.updates.major.forEach(update => {
        console.log(`  ${update.package}: ${update.current} → ${update.latest}`)
      })
    }
  }

  async safeUpdate(updateType = 'patch') {
    console.log(`🔧 Applying ${updateType} updates...`)

    const updates = this.updates[updateType]
    if (updates.length === 0) {
      console.log(`✅ No ${updateType} updates available`)
      return
    }

    // Create backup branch
    const backupBranch = `backup-deps-${new Date().toISOString().slice(0, 10)}`
    execSync(`git checkout -b ${backupBranch}`)

    // Update packages
    const packages = updates.map(u => `${u.package}@latest`).join(' ')
    try {
      execSync(`npm install ${packages}`, { stdio: 'inherit' })

      // Run tests
      execSync('npm test', { stdio: 'inherit' })

      // Run build
      execSync('npm run build', { stdio: 'inherit' })

      // If successful, commit changes
      execSync(`git add package.json package-lock.json`)
      execSync(`git commit -m "chore: update ${updateType} dependencies"`)

      console.log(`✅ Successfully updated ${updates.length} ${updateType} dependencies`)

    } catch (error) {
      console.log(`❌ Update failed, reverting changes...`)
      execSync(`git checkout package.json package-lock.json`)
      execSync(`git checkout main`)  // or develop branch
      execSync(`git branch -D ${backupBranch}`)
    }
  }

  async checkBreakingChanges() {
    console.log('🔍 Checking for breaking changes...')

    const majorUpdates = this.updates.major
    for (const update of majorUpdates) {
      console.log(`\n🔴 Checking ${update.package}@${update.latest}...`)

      // Check changelog or release notes
      try {
        const changelog = execSync(`curl -s https://raw.githubusercontent.com/${this.getRepoName(update.package)}/master/CHANGELOG.md`, {
          encoding: 'utf8'
        })

        if (changelog.toLowerCase().includes('breaking change')) {
          console.log(`⚠️  ${update.package} has breaking changes in v${update.latest}`)
        }
      } catch (error) {
        console.log(`ℹ️  Could not check changelog for ${update.package}`)
      }
    }
  }

  getRepoName(packageName) {
    // This would need to be implemented to get GitHub repo from npm package
    // For now, return a placeholder
    return 'owner/repo'
  }

  generateUpdatePlan() {
    const plan = {
      immediate: this.updates.patch,
      scheduled: this.updates.minor,
      manual: this.updates.major,
      totalSavings: this.calculateSavings()
    }

    fs.writeFileSync('dependency-update-plan.json', JSON.stringify(plan, null, 2))
    console.log('📄 Update plan saved to dependency-update-plan.json')

    return plan
  }

  calculateSavings() {
    // Estimate bundle size savings from updates
    // This would require bundle analysis
    return 'TBD - requires bundle analysis'
  }
}

// CLI interface
const args = process.argv.slice(2)
const updater = new DependencyUpdater()

switch (args[0]) {
  case 'analyze':
    updater.analyzeUpdates()
    break
  case 'update':
    const updateType = args[1] || 'patch'
    updater.analyzeUpdates().then(() => updater.safeUpdate(updateType))
    break
  case 'breaking':
    updater.analyzeUpdates().then(() => updater.checkBreakingChanges())
    break
  case 'plan':
    updater.analyzeUpdates().then(() => updater.generateUpdatePlan())
    break
  default:
    console.log('Usage: node update-dependencies.js <command>')
    console.log('Commands: analyze, update [patch|minor|major], breaking, plan')
}
```

### 6. Monitoreo de Bundle Size
```javascript
// scripts/bundle-analysis.js
const { execSync } = require('child_process')
const fs = require('fs')

class BundleAnalyzer {
  constructor() {
    this.baseline = this.loadBaseline()
  }

  async analyzeBundle() {
    console.log('📦 Analyzing bundle size...')

    // Build production bundle
    execSync('npm run build', { stdio: 'inherit' })

    // Analyze bundle size
    const distDir = './dist'
    const files = fs.readdirSync(distDir)

    let totalSize = 0
    const fileSizes = []

    files.forEach(file => {
      const filePath = `${distDir}/${file}`
      const stats = fs.statSync(filePath)

      if (stats.isFile()) {
        const sizeKB = stats.size / 1024
        totalSize += stats.size
        fileSizes.push({
          file,
          size: sizeKB,
          percentage: 0 // Will be calculated after
        })
      }
    })

    // Calculate percentages
    fileSizes.forEach(file => {
      file.percentage = ((file.size * 1024 / totalSize) * 100).toFixed(2)
    })

    const analysis = {
      timestamp: new Date().toISOString(),
      totalSize: (totalSize / 1024 / 1024).toFixed(2) + ' MB',
      files: fileSizes.sort((a, b) => b.size - a.size),
      comparison: this.compareWithBaseline(totalSize)
    }

    this.saveAnalysis(analysis)
    this.displayAnalysis(analysis)

    return analysis
  }

  compareWithBaseline(currentSize) {
    if (!this.baseline) {
      return { status: 'baseline', change: 0 }
    }

    const baselineSize = this.baseline.totalSizeBytes
    const change = ((currentSize - baselineSize) / baselineSize) * 100

    return {
      status: change > 5 ? 'increased' : change < -5 ? 'decreased' : 'stable',
      change: change.toFixed(2),
      baseline: (baselineSize / 1024 / 1024).toFixed(2) + ' MB'
    }
  }

  loadBaseline() {
    try {
      return JSON.parse(fs.readFileSync('bundle-baseline.json', 'utf8'))
    } catch (error) {
      return null
    }
  }

  saveAnalysis(analysis) {
    // Save current analysis as new baseline
    const baseline = {
      timestamp: analysis.timestamp,
      totalSizeBytes: parseFloat(analysis.totalSize) * 1024 * 1024,
      totalSize: analysis.totalSize
    }

    fs.writeFileSync('bundle-baseline.json', JSON.stringify(baseline, null, 2))
    fs.writeFileSync('bundle-analysis.json', JSON.stringify(analysis, null, 2))
  }

  displayAnalysis(analysis) {
    console.log('\n📊 Bundle Analysis Report')
    console.log('========================')
    console.log(`Total bundle size: ${analysis.totalSize}`)

    if (analysis.comparison.status !== 'baseline') {
      const changeIcon = analysis.comparison.change > 0 ? '📈' : '📉'
      console.log(`${changeIcon} Change from baseline: ${analysis.comparison.change}%`)
      console.log(`Baseline: ${analysis.comparison.baseline}`)
    }

    console.log('\n📁 Largest files:')
    analysis.files.slice(0, 10).forEach(file => {
      console.log(`  ${file.file}: ${file.size.toFixed(2)} KB (${file.percentage}%)`)
    })

    // Recommendations
    const largeFiles = analysis.files.filter(f => f.size > 500) // > 500KB
    if (largeFiles.length > 0) {
      console.log('\n💡 Recommendations:')
      console.log('  Consider code splitting for large files:')
      largeFiles.forEach(file => {
        console.log(`    - ${file.file}: ${file.size.toFixed(2)} KB`)
      })
    }
  }

  async suggestOptimizations() {
    console.log('\n🔧 Bundle Optimization Suggestions:')

    const suggestions = [
      'Implement code splitting with dynamic imports',
      'Use tree shaking to remove unused code',
      'Optimize images and assets',
      'Consider using CDN for large libraries',
      'Implement lazy loading for routes',
      'Use compression (gzip/brotli)',
      'Remove unused dependencies'
    ]

    suggestions.forEach(suggestion => {
      console.log(`  • ${suggestion}`)
    })
  }
}

// Uso
const analyzer = new BundleAnalyzer()
analyzer.analyzeBundle().then(() => analyzer.suggestOptimizations())
```

### 7. CI/CD Integration
```yaml
# .github/workflows/dependency-audit.yml
name: Dependency Audit
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
  schedule:
    - cron: '0 2 * * 1' # Weekly audit

jobs:
  audit:
    runs-on: ubuntu-latest
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

      - name: Run dependency audit
        run: node scripts/dependency-audit.js

      - name: Upload audit report
        uses: actions/upload-artifact@v3
        with:
          name: dependency-audit-report
          path: dependency-report.json

      - name: Fail on critical vulnerabilities
        run: |
          CRITICAL=$(jq '.vulnerabilities | map(select(.severity == "critical")) | length' dependency-report.json)
          if [ "$CRITICAL" -gt 0 ]; then
            echo "🚨 $CRITICAL critical vulnerabilities found!"
            exit 1
          fi

      - name: Warn on high vulnerabilities
        run: |
          HIGH=$(jq '.vulnerabilities | map(select(.severity == "high")) | length' dependency-report.json)
          if [ "$HIGH" -gt 0 ]; then
            echo "⚠️ $HIGH high severity vulnerabilities found"
          fi

  bundle-analysis:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Build and analyze bundle
        run: node scripts/bundle-analysis.js

      - name: Upload bundle report
        uses: actions/upload-artifact@v3
        with:
          name: bundle-analysis-report
          path: bundle-analysis.json

  license-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Check licenses
        run: |
          npm install -g license-checker
          license-checker --production --json > production-licenses.json
          license-checker --development --json > dev-licenses.json

      - name: Upload license reports
        uses: actions/upload-artifact@v3
        with:
          name: license-reports
          path: |
            production-licenses.json
            dev-licenses.json
```

### 8. Checklist de Dependency Management
- [ ] **Auditoría semanal** ejecutada automáticamente
- [ ] **Vulnerabilidades críticas** resueltas inmediatamente
- [ ] **Licencias compatibles** verificadas
- [ ] **Bundle size** monitoreado y optimizado
- [ ] **Dependencias actualizadas** regularmente
- [ ] **Versiones fijas** en producción
- [ ] **Peer dependencies** especificadas correctamente
- [ ] **Documentación** de decisiones de dependencias

### 9. Estrategias de Optimización
```markdown
## Dependency Optimization Strategies

### Bundle Size:
- **Tree Shaking**: Eliminar código no usado
- **Code Splitting**: Dividir bundle en chunks
- **Dynamic Imports**: Cargar módulos bajo demanda
- **Compression**: Usar gzip/brotli

### Performance:
- **CDN**: Servir dependencias desde CDN
- **Caching**: Cache agresivo de dependencias
- **Preloading**: Pre-cargar recursos críticos
- **Lazy Loading**: Cargar componentes bajo demanda

### Security:
- **Subresource Integrity**: Verificar integridad de CDN assets
- **CSP Headers**: Content Security Policy
- **Dependency Scanning**: Escaneo continuo de vulnerabilidades
- **Lock Files**: Usar package-lock.json para reproducibilidad

### Maintenance:
- **Automated Updates**: Dependabot para PRs automáticas
- **Version Policies**: Semantic versioning estricto
- **Deprecation Monitoring**: Alertas de dependencias deprecated
- **Size Budgets**: Límites de tamaño de bundle
```

### 10. Troubleshooting Común
```markdown
## Dependency Issues & Solutions

### Version Conflicts:
```bash
# Ver conflictos
npm ls <package-name>

# Resolver conflictos
npm install --save-dev <package-name>@<version>

# Limpiar node_modules
rm -rf node_modules package-lock.json
npm install
```

### Bundle Size Issues:
```bash
# Analizar bundle
npx webpack-bundle-analyzer dist/static/js/*.js

# Encontrar dependencias grandes
npm ls --depth=0 | grep -E "(lodash|moment|jquery)"
```

### Audit Issues:
```bash
# Ver detalles de vulnerabilidades
npm audit --audit-level info

# Actualizar dependencias vulnerables
npm audit fix --force  # ⚠️ Puede romper cosas

# Excluir dependencias problemáticas
# En package.json:
"overrides": {
  "problematic-package": "safe-version"
}
```

### License Issues:
```bash
# Verificar licencias
npx license-checker --production --csv > licenses.csv

# Excluir licencias problemáticas
npx license-checker --exclude "GPL,BSD"
```
```

### 11. Mejores Prácticas
- **Minimal Dependencies**: Solo instalar lo necesario
- **Regular Audits**: Ejecutar auditorías semanalmente
- **Version Pinning**: Usar versiones exactas en producción
- **Security First**: Nunca ignorar vulnerabilidades críticas
- **Documentation**: Documentar por qué se elige cada dependencia
- **Team Alignment**: Todos los developers siguen las mismas reglas
- **Automation**: Todo el proceso lo más automatizado posible

### 12. Recursos Adicionales
- [npm Audit Documentation](https://docs.npmjs.com/cli/v8/commands/npm-audit)
- [Snyk Vulnerability Database](https://snyk.io/vuln/)
- [Bundle Analyzer](https://github.com/webpack-contrib/webpack-bundle-analyzer)
- [License Checker](https://github.com/davglass/license-checker)
