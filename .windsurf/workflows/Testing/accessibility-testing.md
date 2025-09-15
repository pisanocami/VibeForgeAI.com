---
description: Accessibility Testing - Auditorías de accesibilidad WCAG para aplicaciones web
---

# Accessibility Testing Workflow

Workflow completo para testing de accesibilidad siguiendo estándares WCAG 2.1 AA.

## Pre-requisitos
- Herramientas: axe-core, lighthouse, pa11y, WAVE
- Conocimiento básico de WCAG guidelines
- Componentes siguiendo patrones de accesibilidad

## Pasos del Workflow

### 1. Configurar Herramientas de Accesibilidad
```bash
# Instalar herramientas de testing de accesibilidad
npm install --save-dev axe-core @axe-core/puppeteer lighthouse pa11y
```

### 2. Configurar axe-core para Tests Unitarios
```typescript
// accessibility.test.ts
import { axe, toHaveNoViolations } from 'jest-axe'
import { render } from '@testing-library/react'
import { Button } from '@/components/Button'

expect.extend(toHaveNoViolations)

describe('Accessibility', () => {
  it('Button should have no accessibility violations', async () => {
    const { container } = render(<Button>Click me</Button>)
    const results = await axe(container)
    expect(results).toHaveNoViolations()
  })
})
```

### 3. Configurar axe-core para Tests E2E
```typescript
// e2e-accessibility.test.ts
import puppeteer from 'puppeteer'
import axe from 'axe-core'

describe('E2E Accessibility', () => {
  let browser
  let page

  beforeAll(async () => {
    browser = await puppeteer.launch()
    page = await browser.newPage()
  })

  afterAll(async () => {
    await browser.close()
  })

  it('Homepage should have no accessibility violations', async () => {
    await page.goto('http://localhost:3000')

    // Inyectar axe-core
    await page.addScriptTag({ path: 'node_modules/axe-core/axe.min.js' })

    // Ejecutar auditoría
    const results = await page.evaluate(() => {
      return new Promise((resolve) => {
        axe.run((err, results) => {
          if (err) throw err
          resolve(results)
        })
      })
    })

    expect(results.violations).toHaveLength(0)
  })
})
```

### 4. Configurar Lighthouse Accessibility Audit
```javascript
// lighthouse-accessibility.js
const lighthouse = require('lighthouse')
const chromeLauncher = require('chrome-launcher')

async function auditAccessibility(url) {
  const chrome = await chromeLauncher.launch({ chromeFlags: ['--headless'] })

  const options = {
    logLevel: 'info',
    output: 'json',
    onlyCategories: ['accessibility'],
    port: chrome.port
  }

  const runnerResult = await lighthouse(url, options)

  await chrome.kill()

  const accessibilityScore = runnerResult.lhr.categories.accessibility.score * 100
  const violations = runnerResult.lhr.audits

  console.log(`Accessibility Score: ${accessibilityScore}%`)

  // Mostrar violaciones críticas
  Object.keys(violations).forEach(key => {
    const audit = violations[key]
    if (audit.score === 0 && audit.details) {
      console.log(`❌ ${audit.title}: ${audit.description}`)
      console.log(`   Impact: ${audit.details.impact}`)
    }
  })

  return runnerResult.lhr
}

auditAccessibility('https://your-app.com')
```

### 5. Checklist WCAG 2.1 AA Compliance

#### Perceptible (Principio 1)
- [ ] **1.1.1 Non-text Content**: Todas las imágenes tienen alt text apropiado
- [ ] **1.2.1 Audio-only and Video-only**: Contenido multimedia tiene alternativas
- [ ] **1.2.2 Captions**: Videos tienen subtítulos
- [ ] **1.2.3 Audio Description**: Contenido visual tiene descripción de audio
- [ ] **1.3.1 Info and Relationships**: Estructura semántica correcta (headings, lists, etc.)
- [ ] **1.3.2 Meaningful Sequence**: Orden de lectura lógico
- [ ] **1.3.3 Sensory Characteristics**: No depender solo de forma, tamaño o posición
- [ ] **1.4.1 Use of Color**: Información no transmitida solo por color
- [ ] **1.4.2 Audio Control**: Audio no inicia automáticamente o tiene control de volumen
- [ ] **1.4.3 Contrast (Minimum)**: Contraste mínimo 4.5:1 para texto normal
- [ ] **1.4.4 Resize text**: Texto puede agrandarse hasta 200% sin pérdida de funcionalidad
- [ ] **1.4.5 Images of Text**: No usar imágenes de texto (excepto para branding)

#### Operable (Principio 2)
- [ ] **2.1.1 Keyboard**: Toda funcionalidad operable por teclado
- [ ] **2.1.2 No Keyboard Trap**: No atrapar el foco del teclado
- [ ] **2.1.4 Character Key Shortcuts**: Atajos de teclado pueden desactivarse o modificarse
- [ ] **2.2.1 Timing Adjustable**: Límites de tiempo pueden ajustarse
- [ ] **2.2.2 Pause, Stop, Hide**: Movimiento puede pausarse/detenerse
- [ ] **2.3.1 Three Flashes or Below**: No flashes >3 veces por segundo
- [ ] **2.4.1 Bypass Blocks**: Enlaces para saltar bloques de contenido
- [ ] **2.4.2 Page Titled**: Páginas tienen títulos descriptivos
- [ ] **2.4.3 Focus Order**: Orden de foco lógico y predecible
- [ ] **2.4.4 Link Purpose**: Propósito del enlace claro por el texto del enlace
- [ ] **2.4.5 Multiple Ways**: Múltiples formas de localizar contenido
- [ ] **2.4.6 Headings and Labels**: Headings y labels descriptivos
- [ ] **2.4.7 Focus Visible**: Foco visible en todos los elementos interactivos

#### Understandable (Principio 3)
- [ ] **3.1.1 Language of Page**: Idioma de la página identificado
- [ ] **3.1.2 Language of Parts**: Cambios de idioma identificados
- [ ] **3.2.1 On Focus**: Cambio de contexto al recibir foco
- [ ] **3.2.2 On Input**: Cambio de contexto al cambiar valor
- [ ] **3.2.3 Consistent Navigation**: Navegación consistente
- [ ] **3.2.4 Consistent Identification**: Identificación consistente
- [ ] **3.3.1 Error Identification**: Errores claramente identificados
- [ ] **3.3.2 Labels or Instructions**: Labels o instrucciones para entradas
- [ ] **3.3.3 Error Suggestion**: Sugerencias para corregir errores
- [ ] **3.3.4 Error Prevention**: Prevención de errores (revisión, confirmación)

#### Robust (Principio 4)
- [ ] **4.1.1 Parsing**: Código parseable por tecnologías de asistencia
- [ ] **4.1.2 Name, Role, Value**: Nombre, rol y valor disponibles para APIs de accesibilidad
- [ ] **4.1.3 Status Messages**: Mensajes de estado anunciados por tecnologías de asistencia

### 6. Configurar Testing Automático con Pa11y
```javascript
// pa11y-config.js
const pa11y = require('pa11y')

async function runPa11yAudit(url) {
  const results = await pa11y(url, {
    standard: 'WCAG2AA',
    includeWarnings: true,
    includeNotices: true,
    runners: ['axe', 'htmlcs'],
    level: 'error'
  })

  console.log(`Found ${results.issues.length} issues:`)

  results.issues.forEach(issue => {
    console.log(`[${issue.type}] ${issue.message}`)
    console.log(`  Code: ${issue.code}`)
    console.log(`  Selector: ${issue.selector}`)
    console.log(`  Context: ${issue.context}`)
    console.log('---')
  })

  return results
}

runPa11yAudit('https://your-app.com')
```

### 7. Componentes Accesibles - Patrones Comunes

#### Button Accesible
```tsx
// ❌ Incorrecto
<div onClick={handleClick}>Click me</div>

// ✅ Correcto
<button
  onClick={handleClick}
  disabled={isDisabled}
  aria-pressed={isPressed}
>
  Click me
</button>
```

#### Form con Labels
```tsx
// ❌ Incorrecto
<input type="email" placeholder="Enter email" />

// ✅ Correcto
<label htmlFor="email">Email address</label>
<input
  id="email"
  type="email"
  aria-describedby="email-help"
  aria-invalid={hasError}
/>
<span id="email-help">We'll never share your email</span>
{hasError && <span role="alert">Please enter a valid email</span>}
```

#### Modal/Dialog Accesible
```tsx
function Modal({ isOpen, onClose, children }) {
  return (
    <>
      {isOpen && (
        <div role="dialog" aria-labelledby="modal-title" aria-modal="true">
          <div role="document">
            <h2 id="modal-title">Modal Title</h2>
            <button
              onClick={onClose}
              aria-label="Close modal"
              autoFocus
            >
              ×
            </button>
            {children}
          </div>
        </div>
      )}
    </>
  )
}
```

### 8. CI/CD Integration
```yaml
# .github/workflows/accessibility.yml
name: Accessibility Tests
on: [push, pull_request]

jobs:
  accessibility:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: npm ci
      - name: Run accessibility tests
        run: npm run test:a11y
      - name: Lighthouse accessibility audit
        run: npx lighthouse http://localhost:3000 --only-categories=accessibility
      - name: Upload results
        uses: actions/upload-artifact@v3
        with:
          name: accessibility-results
          path: ./accessibility-results/
```

### 9. Herramientas de Desarrollo
- **Browser DevTools**: Lighthouse tab para auditorías rápidas
- **WAVE Browser Extension**: Para testing visual de accesibilidad
- **axe DevTools**: Extension para testing detallado
- **Color Contrast Analyzer**: Para verificar ratios de contraste
- **Screen Reader Testing**: NVDA, JAWS, VoiceOver

### 10. Reporte de Resultados
```javascript
// accessibility-report.js
function generateReport(results) {
  const report = {
    timestamp: new Date().toISOString(),
    score: results.score,
    violations: results.violations.map(v => ({
      rule: v.id,
      impact: v.impact,
      description: v.description,
      help: v.help,
      elements: v.nodes.map(n => n.target)
    })),
    passes: results.passes.length,
    incomplete: results.incomplete.length
  }

  // Guardar reporte
  fs.writeFileSync('accessibility-report.json', JSON.stringify(report, null, 2))

  return report
}
```

### 11. Mejores Prácticas
- **Semantic HTML**: Usar elementos correctos (nav, main, aside, etc.)
- **ARIA cuando sea necesario**: Solo cuando HTML nativo no sea suficiente
- **Keyboard Navigation**: Probar toda la app con Tab, Enter, Space, Arrow keys
- **Screen Reader Testing**: Probar con NVDA/JAWS en Windows, VoiceOver en Mac
- **Color Independence**: Verificar que la app funciona en escala de grises
- **Focus Management**: Gestionar foco en SPAs, modales, formularios
- **Error Handling**: Mensajes de error claros y accesibles

### 12. Recursos Adicionales
- [WCAG 2.1 Guidelines](https://www.w3.org/TR/WCAG21/)
- [ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [MDN Accessibility](https://developer.mozilla.org/en-US/docs/Web/Accessibility)
- [WebAIM](https://webaim.org/)
