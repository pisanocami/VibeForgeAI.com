---
description: Performance Testing - Análisis de rendimiento y carga para aplicaciones web
---

# Performance Testing Workflow

Workflow completo para testing de rendimiento, carga y estrés de aplicaciones web.

## Pre-requisitos
- Aplicación corriendo en ambiente de staging/production
- Herramientas de performance: Lighthouse, WebPageTest, k6, Artillery
- Métricas de baseline establecidas

## Pasos del Workflow

### 1. Configurar Herramientas de Performance
```bash
# Instalar herramientas de testing
npm install --save-dev lighthouse puppeteer k6 artillery
```

### 2. Establecer Métricas Baseline
```javascript
// performance-baseline.js
const baseline = {
  lighthouse: {
    performance: 90,
    accessibility: 95,
    bestPractices: 90,
    seo: 90
  },
  loadTimes: {
    firstContentfulPaint: '< 1.5s',
    largestContentfulPaint: '< 2.5s',
    firstInputDelay: '< 100ms',
    cumulativeLayoutShift: '< 0.1'
  },
  api: {
    responseTime: '< 200ms',
    throughput: '> 1000 req/s'
  }
}

module.exports = baseline
```

### 3. Lighthouse Performance Audit
```javascript
// lighthouse-audit.js
const lighthouse = require('lighthouse')
const chromeLauncher = require('chrome-launcher')

async function runLighthouse(url) {
  const chrome = await chromeLauncher.launch({ chromeFlags: ['--headless'] })

  const options = {
    logLevel: 'info',
    output: 'json',
    onlyCategories: ['performance', 'accessibility', 'best-practices', 'seo'],
    port: chrome.port
  }

  const runnerResult = await lighthouse(url, options)

  await chrome.kill()

  return runnerResult.lhr
}

// Ejecutar audit
runLighthouse('https://your-app.com')
  .then(results => {
    console.log('Performance Score:', results.categories.performance.score * 100)
    console.log('Accessibility Score:', results.categories.accessibility.score * 100)
  })
```

### 4. Load Testing con k6
```javascript
// load-test.js
import http from 'k6/http'
import { check, sleep } from 'k6'
import { Rate, Trend } from 'k6/metrics'

// Métricas custom
const errorRate = new Rate('errors')
const responseTime = new Trend('response_time')

export const options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp up to 100 users
    { duration: '5m', target: 100 }, // Stay at 100 users
    { duration: '2m', target: 200 }, // Ramp up to 200 users
    { duration: '5m', target: 200 }, // Stay at 200 users
    { duration: '2m', target: 0 },   // Ramp down to 0 users
  ],
  thresholds: {
    http_req_duration: ['p(99)<300'], // 99% of requests must complete below 300ms
    http_req_failed: ['rate<0.1'],    // Error rate must be below 10%
  },
}

export default function () {
  const response = http.get('https://your-app.com/api/users')

  const checkResult = check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 300ms': (r) => r.timings.duration < 300,
  })

  errorRate.add(!checkResult)
  responseTime.add(response.timings.duration)

  sleep(1)
}
```

### 5. Artillery Load Testing
```javascript
// artillery-config.yml
config:
  target: 'https://your-app.com'
  phases:
    - duration: 60
      arrivalRate: 5
      name: Warm up
    - duration: 120
      arrivalRate: 5
      rampTo: 50
      name: Ramp up load
    - duration: 60
      arrivalRate: 50
      name: Sustained load

scenarios:
  - name: 'User journey'
    weight: 60
    flow:
      - get:
          url: '/'
      - think: 1
      - get:
          url: '/api/users'
      - think: 2
      - post:
          url: '/api/login'
          json:
            username: 'testuser'
            password: 'testpass'

  - name: 'API stress test'
    weight: 40
    flow:
      - loop:
          - get:
              url: '/api/data'
        count: 10
```

### 6. Web Vitals Monitoring
```javascript
// web-vitals.js
import { getCLS, getFID, getFCP, getLCP, getTTFB } from 'web-vitals'

function reportWebVitals(metric) {
  // Enviar métricas a servicio de monitoring
  console.log(metric.name, metric.value)

  // Ejemplo: enviar a DataDog, New Relic, etc.
  fetch('/api/metrics', {
    method: 'POST',
    body: JSON.stringify({
      name: metric.name,
      value: metric.value,
      timestamp: Date.now()
    })
  })
}

// Medir Core Web Vitals
getCLS(reportWebVitals)
getFID(reportWebVitals)
getFCP(reportWebVitals)
getLCP(reportWebVitals)
getTTFB(reportWebVitals)
```

### 7. Memory Leak Testing
```javascript
// memory-leak-test.js
const puppeteer = require('puppeteer')

async function checkMemoryLeaks(url) {
  const browser = await puppeteer.launch()
  const page = await browser.newPage()

  // Tomar snapshot inicial de memoria
  const initialMemory = await page.metrics()

  // Navegar a la página
  await page.goto(url, { waitUntil: 'networkidle0' })

  // Simular interacciones que podrían causar memory leaks
  for (let i = 0; i < 100; i++) {
    await page.click('#some-button')
    await page.waitForTimeout(100)
  }

  // Tomar snapshot final
  const finalMemory = await page.metrics()

  console.log('Memory usage:', {
    initial: initialMemory.JSHeapUsedSize,
    final: finalMemory.JSHeapUsedSize,
    difference: finalMemory.JSHeapUsedSize - initialMemory.JSHeapUsedSize
  })

  await browser.close()
}
```

### 8. Bundle Size Analysis
```javascript
// bundle-analysis.js
const { execSync } = require('child_process')
const fs = require('fs')

function analyzeBundle() {
  // Ejecutar build
  execSync('npm run build', { stdio: 'inherit' })

  // Leer archivo de stats si existe
  const statsPath = './dist/static/js/*.js'
  const files = fs.readdirSync('./dist/static/js/')

  files.forEach(file => {
    const stats = fs.statSync(`./dist/static/js/${file}`)
    console.log(`${file}: ${(stats.size / 1024 / 1024).toFixed(2)} MB`)
  })
}

analyzeBundle()
```

### 9. CI/CD Integration
```yaml
# .github/workflows/performance.yml
name: Performance Tests
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: 18
      - name: Install dependencies
        run: npm ci
      - name: Build
        run: npm run build
      - name: Serve and test
        run: |
          npm run serve &
          npx lighthouse http://localhost:3000 --output json --output-path ./lighthouse-results.json

  load-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup k6
        uses: grafana/setup-k6-action@v1
      - name: Run load test
        run: k6 run load-test.js
```

### 10. Alertas y Monitoreo
```javascript
// performance-alerts.js
const thresholds = {
  responseTime: 500, // ms
  errorRate: 0.05,   // 5%
  memoryUsage: 100,  // MB
}

function checkThresholds(metrics) {
  const alerts = []

  if (metrics.responseTime > thresholds.responseTime) {
    alerts.push(`High response time: ${metrics.responseTime}ms`)
  }

  if (metrics.errorRate > thresholds.errorRate) {
    alerts.push(`High error rate: ${(metrics.errorRate * 100).toFixed(2)}%`)
  }

  if (metrics.memoryUsage > thresholds.memoryUsage) {
    alerts.push(`High memory usage: ${metrics.memoryUsage}MB`)
  }

  return alerts
}
```

### 11. Checklist de Performance
- [ ] Lighthouse score > 90 en todas las categorías
- [ ] Core Web Vitals dentro de rangos aceptables
- [ ] Load testing pasa con 1000+ usuarios concurrentes
- [ ] Memory leaks detectados y corregidos
- [ ] Bundle size optimizado (< 500KB gzipped)
- [ ] API response times < 200ms
- [ ] Time to Interactive < 3s
- [ ] Zero regressions en performance

### 12. Optimizaciones Comunes
- Code splitting y lazy loading
- Image optimization (WebP, responsive images)
- CDN configuration
- Caching strategies (HTTP, service worker)
- Database query optimization
- Bundle analysis y tree shaking
