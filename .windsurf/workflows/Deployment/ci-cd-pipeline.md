---
description: CI/CD Pipeline - Configuración completa de pipelines automatizados
---

# CI/CD Pipeline Workflow

Pipeline completo de Integración Continua y Despliegue Continuo para automatizar todo el proceso de desarrollo a producción.

## Pre-requisitos
- Repositorio en GitHub/GitLab con acceso a Actions
- Proyecto con tests configurados
- Variables de entorno para diferentes ambientes
- Equipo alineado en estrategia de branching y releases

## Pasos del Workflow

### 1. Estructura de Pipelines
```yaml
# .github/workflows/ci.yml - Pipeline de Integración Continua
name: CI
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18.x, 20.x]

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run linter
        run: npm run lint

      - name: Run tests
        run: npm run test:ci

      - name: Build application
        run: npm run build

      - name: Upload coverage reports
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info

  security:
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

      - name: Run security audit
        run: npm audit --audit-level moderate

      - name: Run SAST
        run: npm run security:scan

  quality:
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

      - name: Run type checking
        run: npm run type-check

      - name: Check bundle size
        run: npm run bundle:analyze

      - name: Run accessibility tests
        run: npm run test:a11y
```

```yaml
# .github/workflows/cd.yml - Pipeline de Despliegue Continuo
name: CD
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
  deploy-staging:
    if: github.ref == 'refs/heads/main' || inputs.environment == 'staging'
    runs-on: ubuntu-latest
    environment: staging

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build application
        run: npm run build

      - name: Run database migrations
        run: npm run db:migrate
        env:
          DATABASE_URL: ${{ secrets.STAGING_DATABASE_URL }}

      - name: Deploy to staging
        run: |
          # Deployment logic here
          echo "Deploying to staging..."

      - name: Run smoke tests
        run: npm run test:smoke
        env:
          BASE_URL: ${{ secrets.STAGING_BASE_URL }}

      - name: Notify deployment success
        run: |
          curl -X POST -H 'Content-type: application/json' \
          --data '{"text":"✅ Staging deployment successful"}' \
          ${{ secrets.SLACK_WEBHOOK_URL }}

  deploy-production:
    if: inputs.environment == 'production'
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build application
        run: npm run build:prod

      - name: Create database backup
        run: npm run db:backup
        env:
          DATABASE_URL: ${{ secrets.PRODUCTION_DATABASE_URL }}

      - name: Run database migrations
        run: npm run db:migrate
        env:
          DATABASE_URL: ${{ secrets.PRODUCTION_DATABASE_URL }}

      - name: Deploy to production
        run: |
          # Production deployment logic
          echo "Deploying to production..."

      - name: Run production smoke tests
        run: npm run test:smoke:prod
        env:
          BASE_URL: ${{ secrets.PRODUCTION_BASE_URL }}

      - name: Create release tag
        run: |
          VERSION=$(node -p "require('./package.json').version")
          git tag "v$VERSION"
          git push origin "v$VERSION"

      - name: Notify production deployment
        run: |
          curl -X POST -H 'Content-type: application/json' \
          --data '{"text":"🚀 Production deployment successful - v$(node -p "require('./package.json').version")"}' \
          ${{ secrets.SLACK_WEBHOOK_URL }}
```

### 2. Configuración Avanzada de CI/CD
```yaml
# .github/workflows/pr-checks.yml - Verificaciones específicas de PR
name: PR Checks
on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  pr-validation:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Validate PR title
        run: |
          PR_TITLE="${{ github.event.pull_request.title }}"
          if [[ ! "$PR_TITLE" =~ ^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: ]]; then
            echo "❌ PR title must follow conventional commits format"
            echo "Expected: type(scope): description"
            echo "Example: feat(auth): add user login functionality"
            exit 1
          fi

      - name: Check PR size
        run: |
          CHANGED_FILES=$(git diff --name-only HEAD~1 | wc -l)
          CHANGED_LINES=$(git diff --stat HEAD~1 | tail -1 | awk '{print $4+$6}')

          if [ "$CHANGED_FILES" -gt 50 ] || [ "$CHANGED_LINES" -gt 1000 ]; then
            echo "⚠️ Large PR detected ($CHANGED_FILES files, $CHANGED_LINES lines)"
            echo "Consider splitting into smaller PRs for easier review"
          fi

      - name: Check for console.logs
        run: |
          if git diff --name-only HEAD~1 | xargs grep -l "console\." --include="*.js" --include="*.ts" --include="*.tsx"; then
            echo "⚠️ console.log statements found. Please remove for production."
          fi

      - name: Check test coverage
        run: |
          npm run test:coverage
          COVERAGE=$(grep -o '"lines":{"total":[0-9]*,"covered":[0-9]*' coverage/coverage-summary.json | grep -o '[0-9]*' | tail -2 | head -1)
          TOTAL=$(grep -o '"lines":{"total":[0-9]*,"covered":[0-9]*' coverage/coverage-summary.json | grep -o '[0-9]*' | tail -3 | head -1)

          if [ "$COVERAGE" -lt "$TOTAL" ]; then
            PERCENTAGE=$((COVERAGE * 100 / TOTAL))
            if [ "$PERCENTAGE" -lt 80 ]; then
              echo "❌ Test coverage is $PERCENTAGE%. Minimum required: 80%"
              exit 1
            fi
          fi

      - name: Run dependency check
        run: |
          if npm audit --audit-level moderate; then
            echo "✅ No security vulnerabilities found"
          else
            echo "❌ Security vulnerabilities found"
            exit 1
          fi
```

```yaml
# .github/workflows/nightly.yml - Tests nocturnos
name: Nightly Tests
on:
  schedule:
    - cron: '0 2 * * *'  # 2 AM daily
  workflow_dispatch:

jobs:
  e2e-tests:
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

      - name: Setup test database
        run: |
          # Setup test database
          npm run db:test:setup

      - name: Run E2E tests
        run: npm run test:e2e
        env:
          DATABASE_URL: ${{ secrets.TEST_DATABASE_URL }}

      - name: Upload test artifacts
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: e2e-test-results
          path: |
            test-results/
            screenshots/

  performance-tests:
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

      - name: Build application
        run: npm run build

      - name: Start application
        run: npm run start &
        env:
          PORT: 3000

      - name: Wait for app to be ready
        run: |
          timeout 60 bash -c 'until curl -f http://localhost:3000/health; do sleep 2; done'

      - name: Run performance tests
        run: npm run test:performance

      - name: Upload performance results
        uses: actions/upload-artifact@v3
        with:
          name: performance-results
          path: performance-results/
```

### 3. Estrategias de Deployment
```yaml
# .github/workflows/blue-green.yml - Blue-Green Deployment
name: Blue-Green Deployment
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'production'
        type: choice
        options:
          - staging
          - production

jobs:
  blue-green-deploy:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build application
        run: npm run build

      - name: Determine target environment
        run: |
          # Logic to determine which environment is currently active
          CURRENT_ACTIVE=$(curl -s ${{ secrets.LB_STATUS_URL }})
          if [[ "$CURRENT_ACTIVE" == "blue" ]]; then
            echo "TARGET_ENV=green" >> $GITHUB_ENV
            echo "IDLE_ENV=blue" >> $GITHUB_ENV
          else
            echo "TARGET_ENV=blue" >> $GITHUB_ENV
            echo "IDLE_ENV=green" >> $GITHUB_ENV
          fi

      - name: Deploy to target environment
        run: |
          echo "Deploying to ${{ env.TARGET_ENV }} environment..."
          # Deployment logic for target environment
          ./scripts/deploy.sh ${{ env.TARGET_ENV }}

      - name: Run health checks
        run: |
          # Wait for deployment to be ready
          timeout 300 bash -c 'until curl -f ${{ secrets.${{ env.TARGET_ENV }}_HEALTH_URL }}; do sleep 10; done'

      - name: Run smoke tests
        run: |
          npm run test:smoke
          # Test against target environment

      - name: Switch traffic
        run: |
          echo "Switching traffic to ${{ env.TARGET_ENV }}..."
          # Update load balancer to route traffic to target environment
          curl -X POST ${{ secrets.LB_SWITCH_URL }} \
            -H "Content-Type: application/json" \
            -d "{\"active\": \"${{ env.TARGET_ENV }}\"}"

      - name: Monitor deployment
        run: |
          # Monitor for 5 minutes after traffic switch
          for i in {1..30}; do
            if curl -f ${{ secrets.${{ env.TARGET_ENV }}_HEALTH_URL }}; then
              echo "✅ Health check passed ($i/30)"
            else
              echo "❌ Health check failed ($i/30)"
              # Rollback logic here
              curl -X POST ${{ secrets.LB_SWITCH_URL }} \
                -H "Content-Type: application/json" \
                -d "{\"active\": \"${{ env.IDLE_ENV }}\"}"
              exit 1
            fi
            sleep 10
          done

      - name: Cleanup old deployment
        run: |
          echo "Cleaning up ${{ env.IDLE_ENV }} environment..."
          # Optional: shutdown old environment to save resources
```

```yaml
# .github/workflows/canary.yml - Canary Deployment
name: Canary Deployment
on:
  workflow_dispatch:
    inputs:
      percentage:
        description: 'Percentage of traffic to route to canary'
        required: true
        default: '10'
        type: string

jobs:
  canary-deploy:
    runs-on: ubuntu-latest
    environment: production

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build canary version
        run: |
          npm run build
          # Tag build as canary
          echo "CANARY_BUILD=true" >> $GITHUB_ENV
          echo "CANARY_VERSION=$(date +%Y%m%d-%H%M%S)" >> $GITHUB_ENV

      - name: Deploy canary version
        run: |
          echo "Deploying canary version ${{ env.CANARY_VERSION }}..."
          # Deploy to canary infrastructure
          ./scripts/deploy-canary.sh ${{ env.CANARY_VERSION }}

      - name: Route canary traffic
        run: |
          echo "Routing ${{ inputs.percentage }}% traffic to canary..."
          # Update load balancer with canary rules
          curl -X POST ${{ secrets.LB_CANARY_URL }} \
            -H "Content-Type: application/json" \
            -d "{\"canary\": \"${{ env.CANARY_VERSION }}\", \"percentage\": ${{ inputs.percentage }}}"

      - name: Monitor canary deployment
        run: |
          echo "Monitoring canary deployment for 30 minutes..."
          for i in {1..180}; do
            # Check error rates, latency, etc.
            ERROR_RATE=$(curl -s ${{ secrets.MONITORING_URL }}/error-rate | jq -r '.rate')
            LATENCY=$(curl -s ${{ secrets.MONITORING_URL }}/latency | jq -r '.p95')

            if (( $(echo "$ERROR_RATE > 0.05" | bc -l) )) || (( $(echo "$LATENCY > 1000" | bc -l) )); then
              echo "❌ Canary metrics degraded (Error: $ERROR_RATE, Latency: $LATENCY)"
              # Rollback logic
              ./scripts/rollback-canary.sh ${{ env.CANARY_VERSION }}
              exit 1
            fi

            echo "✅ Canary metrics OK ($i/180) - Error: $ERROR_RATE, Latency: $LATENCY"
            sleep 10
          done

      - name: Promote canary to production
        run: |
          echo "Promoting canary to full production..."
          # Route 100% traffic to canary version
          curl -X POST ${{ secrets.LB_PROMOTE_URL }} \
            -H "Content-Type: application/json" \
            -d "{\"version\": \"${{ env.CANARY_VERSION }}\"}"

      - name: Cleanup old versions
        run: |
          echo "Cleaning up old production versions..."
          ./scripts/cleanup-versions.sh
```

### 4. Monitoreo y Alertas
```yaml
# .github/workflows/monitoring.yml - Monitoreo continuo
name: Monitoring & Alerting
on:
  schedule:
    - cron: '*/5 * * * *'  # Every 5 minutes
  workflow_dispatch:

jobs:
  health-check:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Check application health
        run: |
          # Check staging
          if curl -f --max-time 10 ${{ secrets.STAGING_HEALTH_URL }}; then
            echo "✅ Staging is healthy"
          else
            echo "❌ Staging is unhealthy"
            # Send alert
            curl -X POST -H 'Content-type: application/json' \
              --data '{"text":"🚨 Staging application is unhealthy"}' \
              ${{ secrets.SLACK_WEBHOOK_URL }}
          fi

          # Check production
          if curl -f --max-time 10 ${{ secrets.PRODUCTION_HEALTH_URL }}; then
            echo "✅ Production is healthy"
          else
            echo "❌ Production is unhealthy"
            # Send critical alert
            curl -X POST -H 'Content-type: application/json' \
              --data '{"text":"🚨 CRITICAL: Production application is unhealthy"}' \
              ${{ secrets.SLACK_WEBHOOK_URL }}
          fi

  performance-monitoring:
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

      - name: Run performance tests
        run: npm run test:performance:smoke

      - name: Check performance thresholds
        run: |
          # Read performance results
          RESPONSE_TIME=$(cat performance-results.json | jq -r '.responseTime')
          ERROR_RATE=$(cat performance-results.json | jq -r '.errorRate')

          # Check thresholds
          if (( $(echo "$RESPONSE_TIME > 1000" | bc -l) )); then
            echo "⚠️ High response time detected: ${RESPONSE_TIME}ms"
            curl -X POST -H 'Content-type: application/json' \
              --data "{\"text\":\"⚠️ Performance degradation detected. Response time: ${RESPONSE_TIME}ms\"}" \
              ${{ secrets.SLACK_WEBHOOK_URL }}
          fi

          if (( $(echo "$ERROR_RATE > 0.05" | bc -l) )); then
            echo "❌ High error rate detected: ${ERROR_RATE}"
            curl -X POST -H 'Content-type: application/json' \
              --data "{\"text\":\"❌ High error rate detected: ${ERROR_RATE}\"}" \
              ${{ secrets.SLACK_WEBHOOK_URL }}
          fi

  dependency-monitoring:
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

      - name: Check for outdated dependencies
        run: |
          OUTDATED=$(npm outdated --json 2>/dev/null || echo "{}")
          COUNT=$(echo "$OUTDATED" | jq 'length')

          if [ "$COUNT" -gt 0 ]; then
            echo "⚠️ $COUNT outdated dependencies found"
            echo "$OUTDATED" | jq -r 'keys[]' | while read pkg; do
              echo "  - $pkg"
            done

            # Send notification
            curl -X POST -H 'Content-type: application/json' \
              --data "{\"text\":\"⚠️ $COUNT outdated dependencies found\"}" \
              ${{ secrets.SLACK_WEBHOOK_URL }}
          fi

  security-monitoring:
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

      - name: Run security audit
        run: |
          if npm audit --audit-level moderate > audit-results.txt 2>&1; then
            echo "✅ No security vulnerabilities found"
          else
            VULN_COUNT=$(grep -c "vulnerabilities" audit-results.txt || echo "0")
            echo "❌ $VULN_COUNT security vulnerabilities found"

            # Send alert for high/critical vulnerabilities
            if grep -q "high\|critical" audit-results.txt; then
              curl -X POST -H 'Content-type: application/json' \
                --data "{\"text\":\"🚨 High/critical security vulnerabilities found\"}" \
                ${{ secrets.SLACK_WEBHOOK_URL }}
            fi
          fi

      - name: Upload audit results
        uses: actions/upload-artifact@v3
        with:
          name: security-audit-results
          path: audit-results.txt
```

### 5. Scripts de Automatización
```javascript
// scripts/ci-cd-manager.js
const { execSync } = require('child_process')
const fs = require('fs')

class CICDPipelineManager {
  constructor() {
    this.environments = ['development', 'staging', 'production']
  }

  // Ejecutar tests completos
  async runFullTestSuite() {
    console.log('🧪 Running full test suite...')

    const testResults = {
      unit: false,
      integration: false,
      e2e: false,
      coverage: 0
    }

    try {
      // Unit tests
      execSync('npm run test:unit', { stdio: 'inherit' })
      testResults.unit = true
      console.log('✅ Unit tests passed')
    } catch (error) {
      console.log('❌ Unit tests failed')
    }

    try {
      // Integration tests
      execSync('npm run test:integration', { stdio: 'inherit' })
      testResults.integration = true
      console.log('✅ Integration tests passed')
    } catch (error) {
      console.log('❌ Integration tests failed')
    }

    try {
      // E2E tests
      execSync('npm run test:e2e', { stdio: 'inherit' })
      testResults.e2e = true
      console.log('✅ E2E tests passed')
    } catch (error) {
      console.log('❌ E2E tests failed')
    }

    // Coverage
    try {
      execSync('npm run test:coverage', { stdio: 'inherit' })
      const coverage = this.parseCoverage()
      testResults.coverage = coverage
      console.log(`📊 Test coverage: ${coverage}%`)
    } catch (error) {
      console.log('❌ Coverage analysis failed')
    }

    return testResults
  }

  // Validar deployment readiness
  async validateDeploymentReadiness(environment) {
    console.log(`🔍 Validating deployment readiness for ${environment}...`)

    const checks = {
      tests: false,
      build: false,
      security: false,
      dependencies: false
    }

    // Run tests
    const testResults = await this.runFullTestSuite()
    checks.tests = testResults.unit && testResults.integration

    // Build check
    try {
      execSync('npm run build', { stdio: 'inherit' })
      checks.build = true
      console.log('✅ Build successful')
    } catch (error) {
      console.log('❌ Build failed')
    }

    // Security check
    try {
      execSync('npm audit --audit-level moderate', { stdio: 'pipe' })
      checks.security = true
      console.log('✅ Security audit passed')
    } catch (error) {
      console.log('❌ Security vulnerabilities found')
    }

    // Dependencies check
    try {
      execSync('npm outdated', { stdio: 'pipe' })
      checks.dependencies = true
      console.log('✅ Dependencies up to date')
    } catch (error) {
      console.log('⚠️ Outdated dependencies found')
      checks.dependencies = true // Not blocking
    }

    const allPassed = Object.values(checks).every(check => check)

    if (allPassed) {
      console.log(`🎉 ${environment} is ready for deployment!`)
    } else {
      console.log(`❌ ${environment} is not ready for deployment`)
      console.log('Failed checks:', Object.entries(checks).filter(([_, passed]) => !passed).map(([check, _]) => check))
    }

    return allPassed
  }

  // Crear deployment package
  async createDeploymentPackage(environment) {
    console.log(`📦 Creating deployment package for ${environment}...`)

    const timestamp = new Date().toISOString().replace(/[:.]/g, '-')
    const packageName = `deploy-${environment}-${timestamp}`

    // Create deployment directory
    execSync(`mkdir -p deployments/${packageName}`)

    // Build application
    execSync('npm run build')

    // Copy build artifacts
    execSync(`cp -r dist deployments/${packageName}/`)
    execSync(`cp package.json deployments/${packageName}/`)
    execSync(`cp ecosystem.config.js deployments/${packageName}/`)

    // Create deployment manifest
    const manifest = {
      version: require('../package.json').version,
      environment,
      timestamp,
      commit: execSync('git rev-parse HEAD', { encoding: 'utf8' }).trim(),
      branch: execSync('git rev-parse --abbrev-ref HEAD', { encoding: 'utf8' }).trim()
    }

    fs.writeFileSync(`deployments/${packageName}/manifest.json`, JSON.stringify(manifest, null, 2))

    // Create archive
    execSync(`cd deployments && tar -czf ${packageName}.tar.gz ${packageName}`)

    console.log(`✅ Deployment package created: deployments/${packageName}.tar.gz`)

    return `deployments/${packageName}.tar.gz`
  }

  // Ejecutar deployment
  async deployToEnvironment(environment, packagePath) {
    console.log(`🚀 Deploying to ${environment}...`)

    const deployScript = `scripts/deploy-${environment}.sh`

    if (fs.existsSync(deployScript)) {
      execSync(`${deployScript} ${packagePath}`, { stdio: 'inherit' })
    } else {
      // Generic deployment
      console.log(`Generic deployment to ${environment}`)
      // Implementation depends on your infrastructure
    }

    console.log(`✅ Deployment to ${environment} completed`)
  }

  // Rollback deployment
  async rollbackDeployment(environment, version) {
    console.log(`⏪ Rolling back ${environment} to version ${version}...`)

    const rollbackScript = `scripts/rollback-${environment}.sh`

    if (fs.existsSync(rollbackScript)) {
      execSync(`${rollbackScript} ${version}`, { stdio: 'inherit' })
    } else {
      console.log(`Manual rollback required for ${environment}`)
    }

    console.log(`✅ Rollback completed`)
  }

  parseCoverage() {
    try {
      const coverageSummary = JSON.parse(fs.readFileSync('coverage/coverage-summary.json', 'utf8'))
      return coverageSummary.total.lines.pct
    } catch (error) {
      return 0
    }
  }

  // Ejecutar pipeline completo
  async runFullPipeline(environment) {
    console.log(`🚀 Starting CI/CD pipeline for ${environment}`)

    // Validate readiness
    const isReady = await this.validateDeploymentReadiness(environment)
    if (!isReady) {
      throw new Error(`${environment} is not ready for deployment`)
    }

    // Create deployment package
    const packagePath = await this.createDeploymentPackage(environment)

    // Deploy
    await this.deployToEnvironment(environment, packagePath)

    // Run post-deployment tests
    await this.runPostDeploymentTests(environment)

    console.log(`🎉 CI/CD pipeline completed successfully for ${environment}`)
  }

  // Tests post-deployment
  async runPostDeploymentTests(environment) {
    console.log(`🧪 Running post-deployment tests for ${environment}...`)

    try {
      execSync(`npm run test:smoke:${environment}`, { stdio: 'inherit' })
      console.log(`✅ Post-deployment tests passed for ${environment}`)
    } catch (error) {
      console.log(`❌ Post-deployment tests failed for ${environment}`)
      throw error
    }
  }
}

// CLI interface
const args = process.argv.slice(2)
const manager = new CICDPipelineManager()

switch (args[0]) {
  case 'test':
    manager.runFullTestSuite()
    break
  case 'validate':
    manager.validateDeploymentReadiness(args[1])
    break
  case 'package':
    manager.createDeploymentPackage(args[1])
    break
  case 'deploy':
    manager.runFullPipeline(args[1])
    break
  case 'rollback':
    manager.rollbackDeployment(args[1], args[2])
    break
  default:
    console.log('Usage: node ci-cd-manager.js <command> [args]')
    console.log('Commands:')
    console.log('  test                    - Run full test suite')
    console.log('  validate <env>          - Validate deployment readiness')
    console.log('  package <env>           - Create deployment package')
    console.log('  deploy <env>            - Run full deployment pipeline')
    console.log('  rollback <env> <version> - Rollback deployment')
}
```

### 6. Checklist de CI/CD
- [ ] **Pipelines configurados**: CI y CD pipelines en GitHub Actions
- [ ] **Tests automatizados**: Unit, integration, E2E tests ejecutándose
- [ ] **Quality gates**: Linting, type checking, security scans
- [ ] **Deployment strategies**: Blue-green, canary, rolling deployments
- [ ] **Environments**: Development, staging, production configurados
- [ ] **Monitoring**: Health checks, performance monitoring
- [ ] **Alerting**: Notificaciones para fallos y degradaciones
- [ ] **Rollback**: Estrategias de rollback automatizadas
- [ ] **Security**: Secrets management y access controls

### 7. Mejores Prácticas
- **Fail fast**: Detener pipeline al primer error significativo
- **Parallel execution**: Ejecutar jobs independientes en paralelo
- **Caching**: Cache de dependencies y build artifacts
- **Incremental builds**: Build solo lo que cambió
- **Environment parity**: Mismos procesos en todos los ambientes
- **Immutable deployments**: Nunca modificar código en producción
- **Zero downtime**: Deployments sin interrupción del servicio
- **Monitoring**: Observabilidad completa del pipeline

### 8. Troubleshooting
```markdown
## Problemas Comunes en CI/CD

### Pipeline Stuck:
```bash
# Ver estado del workflow
gh workflow view <workflow-name>

# Ver logs del job
gh run view <run-id> --log

# Cancelar workflow
gh run cancel <run-id>
```

### Tests Fallando en CI:
```bash
# Ejecutar tests localmente
npm run test:ci

# Ver diferencias de environment
echo $CI
echo $NODE_ENV

# Debug con verbose output
npm run test -- --verbose
```

### Deployment Issues:
```bash
# Ver logs de deployment
kubectl logs deployment/<app-name>

# Ver estado de pods
kubectl get pods

# Ver eventos
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Secrets Issues:
```bash
# Verificar secrets en GitHub
gh secret list

# Test connection con secrets
curl -H "Authorization: Bearer $TOKEN" $API_URL
```

### Performance Issues:
```bash
# Ver tiempo de ejecución
gh run view <run-id> --json jobs

# Optimizar caching
# Añadir cache para node_modules, build artifacts

# Paralelizar jobs
# Usar matrix strategy para múltiples versiones
```
```

### 9. Recursos Adicionales
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitLab CI Documentation](https://docs.gitlab.com/ee/ci/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [CircleCI Documentation](https://circleci.com/docs/)
- [CI/CD Best Practices](https://cloud.google.com/architecture/devops/devops-tech-continuous-integration)
