---
description: Visual Regression Testing - Detectar cambios visuales no deseados
---

# Visual Regression Testing Workflow

Workflow para detectar cambios visuales en la UI usando screenshots y comparación automática.

## Pre-requisitos
- Playwright o Cypress para capturar screenshots
- Herramientas: Chromatic, Percy, Applitools
- Base de datos de screenshots de referencia

## Pasos del Workflow

### 1. Configurar Herramientas de Visual Testing
```bash
# Instalar herramientas
npm install --save-dev @playwright/test pixelmatch pngjs
# Para Chromatic (Storybook)
npm install --save-dev chromatic
```

### 2. Configurar Playwright para Visual Testing
```javascript
// playwright.config.js
import { defineConfig } from '@playwright/test'

export default defineConfig({
  testDir: './tests',
  use: {
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    {
      name: 'visual-tests',
      testMatch: '**/visual/*.spec.js',
      use: {
        ...devices['Desktop Chrome'],
        screenshot: 'on',
      },
    },
  ],
})
```

### 3. Tests de Regresión Visual Básicos
```javascript
// tests/visual/homepage.spec.js
import { test, expect } from '@playwright/test'

test.describe('Homepage Visual Tests', () => {
  test('homepage matches baseline', async ({ page }) => {
    await page.goto('/')

    // Esperar a que cargue completamente
    await page.waitForLoadState('networkidle')

    // Tomar screenshot
    await expect(page).toHaveScreenshot('homepage.png', {
      threshold: 0.1, // 10% de tolerancia
      maxDiffPixels: 100
    })
  })

  test('login form matches baseline', async ({ page }) => {
    await page.goto('/login')

    // Esperar a elementos específicos
    await page.waitForSelector('[data-testid="login-form"]')

    // Tomar screenshot del componente específico
    const loginForm = page.locator('[data-testid="login-form"]')
    await expect(loginForm).toHaveScreenshot('login-form.png')
  })

  test('responsive design - mobile', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 })
    await page.goto('/')

    await expect(page).toHaveScreenshot('homepage-mobile.png')
  })

  test('responsive design - tablet', async ({ page }) => {
    await page.setViewportSize({ width: 768, height: 1024 })
    await page.goto('/')

    await expect(page).toHaveScreenshot('homepage-tablet.png')
  })
})
```

### 4. Test Coverage Completo
```javascript
// tests/visual/complete-visual-suite.spec.js
import { test, expect } from '@playwright/test'

test.describe('Complete Visual Regression Suite', () => {
  test.beforeEach(async ({ page }) => {
    // Setup común
    await page.goto('/')
    await page.waitForLoadState('networkidle')
  })

  // Páginas principales
  const pages = [
    { name: 'homepage', path: '/' },
    { name: 'about', path: '/about' },
    { name: 'contact', path: '/contact' },
    { name: 'products', path: '/products' },
    { name: 'dashboard', path: '/dashboard' }
  ]

  pages.forEach(({ name, path }) => {
    test(`${name} page visual regression`, async ({ page }) => {
      await page.goto(path)
      await expect(page).toHaveScreenshot(`${name}.png`)
    })
  })

  // Estados de interacción
  test('button states', async ({ page }) => {
    const button = page.locator('[data-testid="primary-button"]')

    // Estado normal
    await expect(button).toHaveScreenshot('button-normal.png')

    // Hover
    await button.hover()
    await expect(button).toHaveScreenshot('button-hover.png')

    // Focus
    await button.focus()
    await expect(button).toHaveScreenshot('button-focus.png')

    // Active/pressed
    await page.mouse.down()
    await expect(button).toHaveScreenshot('button-active.png')
  })

  // Form states
  test('form validation states', async ({ page }) => {
    await page.goto('/contact')

    const form = page.locator('[data-testid="contact-form"]')
    const submitButton = page.locator('[data-testid="submit-button"]')

    // Estado inicial
    await expect(form).toHaveScreenshot('form-initial.png')

    // Llenar con datos inválidos
    await page.fill('[data-testid="email-input"]', 'invalid-email')
    await submitButton.click()

    // Estado con errores
    await expect(form).toHaveScreenshot('form-errors.png')

    // Corregir y llenar correctamente
    await page.fill('[data-testid="email-input"]', 'valid@example.com')
    await page.fill('[data-testid="name-input"]', 'John Doe')
    await submitButton.click()

    // Estado success
    await expect(form).toHaveScreenshot('form-success.png')
  })

  // Componentes reutilizables
  test('common components', async ({ page }) => {
    await page.goto('/components-showcase')

    const components = [
      'header',
      'navigation',
      'footer',
      'modal',
      'dropdown',
      'tooltip'
    ]

    for (const component of components) {
      const element = page.locator(`[data-testid="${component}"]`)
      if (await element.isVisible()) {
        await expect(element).toHaveScreenshot(`${component}.png`)
      }
    }
  })
})
```

### 5. Configurar Baseline de Screenshots
```javascript
// scripts/update-baseline.js
const { execSync } = require('child_process')
const fs = require('fs')

function updateVisualBaseline() {
  console.log('📸 Updating visual baseline screenshots...')

  // Ejecutar tests en modo update
  try {
    execSync('npx playwright test --update-snapshots', {
      stdio: 'inherit',
      cwd: process.cwd()
    })
  } catch (error) {
    console.log('Error updating baseline:', error.message)
  }

  // Verificar que se crearon los archivos
  const testResultsDir = './test-results'
  if (fs.existsSync(testResultsDir)) {
    const files = fs.readdirSync(testResultsDir)
    console.log(`✅ Updated ${files.length} baseline screenshots`)
  }
}

updateVisualBaseline()
```

### 6. Comparación de Imágenes Custom
```javascript
// utils/image-comparison.js
const fs = require('fs')
const { PNG } = require('pngjs')
const pixelmatch = require('pixelmatch')

class ImageComparator {
  constructor(threshold = 0.1, maxDiffPixels = 100) {
    this.threshold = threshold
    this.maxDiffPixels = maxDiffPixels
  }

  async compareImages(baselinePath, currentPath, diffPath) {
    const baseline = PNG.sync.read(fs.readFileSync(baselinePath))
    const current = PNG.sync.read(fs.readFileSync(currentPath))

    const { width, height } = baseline
    const diff = new PNG({ width, height })

    const diffPixels = pixelmatch(
      baseline.data,
      current.data,
      diff.data,
      width,
      height,
      { threshold: this.threshold }
    )

    fs.writeFileSync(diffPath, PNG.sync.write(diff))

    const percentage = (diffPixels / (width * height)) * 100

    return {
      diffPixels,
      percentage,
      isDifferent: diffPixels > this.maxDiffPixels,
      width,
      height
    }
  }

  async generateComparisonReport(baselineDir, currentDir, outputDir) {
    const baselineFiles = fs.readdirSync(baselineDir)
      .filter(file => file.endsWith('.png'))

    const report = {
      timestamp: new Date().toISOString(),
      comparisons: [],
      summary: {
        total: baselineFiles.length,
        passed: 0,
        failed: 0,
        totalDiffPixels: 0
      }
    }

    for (const file of baselineFiles) {
      const baselinePath = `${baselineDir}/${file}`
      const currentPath = `${currentDir}/${file}`
      const diffPath = `${outputDir}/diff-${file}`

      try {
        const result = await this.compareImages(baselinePath, currentPath, diffPath)

        report.comparisons.push({
          file,
          ...result,
          status: result.isDifferent ? 'failed' : 'passed'
        })

        if (result.isDifferent) {
          report.summary.failed++
        } else {
          report.summary.passed++
        }

        report.summary.totalDiffPixels += result.diffPixels

      } catch (error) {
        report.comparisons.push({
          file,
          error: error.message,
          status: 'error'
        })
        report.summary.failed++
      }
    }

    fs.writeFileSync(`${outputDir}/comparison-report.json`,
      JSON.stringify(report, null, 2))

    console.log(`📊 Visual Comparison Report:`)
    console.log(`Total: ${report.summary.total}`)
    console.log(`Passed: ${report.summary.passed}`)
    console.log(`Failed: ${report.summary.failed}`)
    console.log(`Total diff pixels: ${report.summary.totalDiffPixels}`)

    return report
  }
}

// Uso
const comparator = new ImageComparator(0.1, 100)
comparator.generateComparisonReport(
  './screenshots/baseline',
  './screenshots/current',
  './screenshots/diff'
)
```

### 7. Integration con Chromatic (para Storybook)
```javascript
// .github/workflows/chromatic.yml
name: 'Chromatic'
on: push

jobs:
  chromatic-deployment:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: npm ci
      - name: Build Storybook
        run: npm run build-storybook
      - name: Publish to Chromatic
        uses: chromaui/action@v1
        with:
          projectToken: ${{ secrets.CHROMATIC_PROJECT_TOKEN }}
          token: ${{ secrets.GITHUB_TOKEN }}
          buildScriptName: build-storybook
          exitZeroOnChanges: true
          autoAcceptChanges: main
```

### 8. Configurar Chromatic en package.json
```json
{
  "scripts": {
    "build-storybook": "storybook build",
    "chromatic": "chromatic --project-token=$CHROMATIC_PROJECT_TOKEN"
  },
  "devDependencies": {
    "chromatic": "^6.17.4"
  }
}
```

### 9. Estrategias para Reducir Falsos Positivos
```javascript
// tests/visual/stable-visual-tests.spec.js
import { test, expect } from '@playwright/test'

test.describe('Stable Visual Tests', () => {
  test.beforeEach(async ({ page }) => {
    // Deshabilitar animaciones
    await page.addStyleTag({
      content: `
        *, *::before, *::after {
          animation-duration: 0.01ms !important;
          animation-iteration-count: 1 !important;
          transition-duration: 0.01ms !important;
        }
      `
    })

    // Esperar a fuentes
    await page.evaluate(() => {
      return document.fonts.ready
    })

    // Deshabilitar elementos dinámicos
    await page.addStyleTag({
      content: `
        .timestamp, .random-id, .dynamic-content {
          display: none !important;
        }
      `
    })
  })

  test('stable homepage', async ({ page }) => {
    await page.goto('/')

    // Esperar a contenido dinámico
    await page.waitForFunction(() => {
      const dynamicElements = document.querySelectorAll('.loading, .skeleton')
      return dynamicElements.length === 0
    })

    // Tomar screenshot con área específica (excluyendo header dinámico)
    const mainContent = page.locator('main')
    await expect(mainContent).toHaveScreenshot('homepage-stable.png', {
      mask: [page.locator('.timestamp')], // Enmascarar elementos variables
    })
  })
})
```

### 10. CI/CD Integration Completa
```yaml
# .github/workflows/visual-regression.yml
name: Visual Regression Tests
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  visual-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright browsers
        run: npx playwright install

      - name: Build application
        run: npm run build

      - name: Start application
        run: npm run preview &
        env:
          PORT: 3000

      - name: Wait for app to be ready
        run: |
          timeout 30 bash -c 'until curl -f http://localhost:3000; do sleep 1; done'

      - name: Run visual tests
        run: npx playwright test --project=visual-tests

      - name: Upload visual test results
        uses: actions/upload-artifact@v3
        with:
          name: visual-test-results
          path: |
            test-results/
            screenshots/

      - name: Comment PR with visual differences
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs')
            const results = JSON.parse(fs.readFileSync('./test-results/results.json', 'utf8'))

            const failedTests = results.suites.flatMap(suite =>
              suite.specs.flatMap(spec =>
                spec.tests.filter(test => test.results[0].status === 'failed')
              )
            )

            if (failedTests.length > 0) {
              const comment = `## 🚨 Visual Regression Detected\n\n` +
                `Found ${failedTests.length} visual differences:\n\n` +
                failedTests.map(test =>
                  `- ${test.title}\n  ![diff](https://github.com/${{ github.repository }}/actions/runs/${{ github.run_id }}/artifacts/visual-test-results/screenshots/diff-${test.title}.png)`
                ).join('\n')

              github.rest.issues.createComment({
                issue_number: context.issue.number,
                owner: context.repo.owner,
                repo: context.repo.repo,
                body: comment
              })
            }
```

### 11. Checklist de Visual Testing
- [ ] **Baseline establecido**: Screenshots de referencia guardados
- [ ] **Tests configurados**: Cobertura de componentes y páginas críticas
- [ ] **CI/CD integrado**: Tests ejecutándose automáticamente
- [ ] **Tolerancias configuradas**: Umbrales apropiados para diferencias
- [ ] **Falsos positivos minimizados**: Animaciones y contenido dinámico manejado
- [ ] **Reportes configurados**: Resultados claros y accesibles
- [ ] **Aprobación de cambios**: Proceso para aceptar cambios intencionales
- [ ] **Mantenimiento**: Estrategia para actualizar baselines periódicamente

### 12. Mejores Prácticas
- **Test solo lo necesario**: Enfocarse en elementos visuales críticos
- **Usar data-testid**: Selectores estables para elementos dinámicos
- **Manejar contenido dinámico**: Enmascarar timestamps, IDs aleatorios
- **Configurar tolerancias**: Balance entre detección y ruido
- **Paralelizar tests**: Ejecutar tests en paralelo para velocidad
- **Versionar baselines**: Mantener historial de cambios visuales
- **Integrar con design system**: Tests automáticos de componentes
