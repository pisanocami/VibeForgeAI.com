---
description: E2E con Playwright (Vite + React)
---

Este workflow configura y ejecuta pruebas end‑to‑end (E2E) con Playwright en un proyecto Vite + React + TypeScript.

## Requisitos
- Node 18+ y npm.
- Proyecto Vite + React (ya presente en este repo).

## 1) Instalar el test runner de Playwright
Si aún no está instalado `@playwright/test`:

```bash
npm i -D @playwright/test
```

Instalar navegadores de Playwright:
// turbo
```bash
npx playwright install
```

Opcional (solo si corrés en CI Linux):
```bash
npx playwright install-deps
```

## 2) Scripts recomendados en package.json
Agrega:

```jsonc
{
  "scripts": {
    // ...
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui"
  }
}
```

## 3) Configuración mínima (playwright.config.ts)
Crea `playwright.config.ts` en la raíz con este contenido base:

```ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: 'tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 2 : undefined,
  reporter: [['html', { open: 'never' }], ['list']],
  use: {
    baseURL: 'http://localhost:5173',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  },
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:5173',
    reuseExistingServer: !process.env.CI,
    timeout: 120_000
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] }
    }
  ]
});
```

Notas:
- Para simular entorno productivo en CI, puedes cambiar `webServer.command` a `vite preview` y ejecutar antes `vite build`.

## 4) Prueba de humo (opcional)
Crea `tests/e2e/smoke.spec.ts`:

```ts
import { test, expect } from '@playwright/test';

test('app carga la home', async ({ page }) => {
  await page.goto('/');
  // Asegura que la app respondió y se montó algo en #root
  await expect(page.locator('#root')).toBeVisible();
});
```

Ajusta la aserción según tu UI real (por ejemplo, un texto del header o un selector estable).

## 5) Ejecutar localmente
// turbo
```bash
npm run test:e2e
```

UI interactiva:
```bash
npm run test:e2e:ui
```

## 6) Artefactos y reportes
- Reporte HTML: `playwright-report/` (se abre con `npx playwright show-report`).
- Traces/videos/screenshots en fallos: carpeta `test-results/` y embebidos en el reporte.

## 7) CI (pipeline ejemplo)
YAML genérico (GitHub Actions, similar en otros CI):

```yaml
- name: Install deps
  run: npm ci

- name: Build (opcional para preview)
  run: npm run build

- name: Install Playwright browsers
  run: npx playwright install --with-deps

- name: Run E2E
  run: npm run test:e2e
```

## 8) Buenas prácticas
- Usa selectores accesibles y estables (roles, text, data-testid).
- Evita dependencias frágiles en layout.
- Ejecuta E2E en PRs críticos o nightly para balancear velocidad/calidad.
