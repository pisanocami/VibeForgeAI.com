---
description: Unit tests con Vitest + Testing Library (Vite + React + TS)
---

Este workflow agrega pruebas unitarias con Vitest, Testing Library y JSDOM.

## Requisitos
- Node 18+
- Vite + React + TS (ya presente)

## 1) Instalar dependencias
// turbo
```bash
npm i -D vitest @testing-library/react @testing-library/jest-dom @testing-library/user-event jsdom
```

## 2) Scripts en package.json
Agrega:

```jsonc
{
  "scripts": {
    // ...
    "test": "vitest run",
    "test:watch": "vitest",
    "test:ui": "vitest --ui",
    "coverage": "vitest run --coverage"
  }
}
```

## 3) Configuración (vitest.config.ts)
Crea `vitest.config.ts` en la raíz:

```ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'jsdom',
    setupFiles: './src/test/setup.ts',
    css: true,
    globals: true,
    coverage: {
      reporter: ['text', 'html', 'lcov']
    }
  }
});
```

## 4) Setup de pruebas
Crea `src/test/setup.ts`:

```ts
import '@testing-library/jest-dom/vitest';
```

## 5) Ejemplo mínimo de test
Crea `src/sample/Hello.test.tsx`:

```tsx
import { render, screen } from '@testing-library/react';

function Hello() {
  return <h1>Hola Vitest</h1>;
}

test('renderiza encabezado', () => {
  render(<Hello />);
  expect(screen.getByText('Hola Vitest')).toBeInTheDocument();
});
```

## 6) Ejecutar
- Unit tests (una sola vez):
// turbo
```bash
npm run test
```

- Modo watch:
```bash
npm run test:watch
```

- UI interactiva:
```bash
npm run test:ui
```

- Cobertura:
```bash
npm run coverage
```

## 7) Buenas prácticas
- Un test por unidad lógica (componente/hook/utils).
- Usa `screen` y queries accesibles (`getByRole`, `getByLabelText`).
- Aísla side-effects; considera MSW para mocks de red si haces integración.

## 8) CI (resumen)
```yaml
- name: Install deps
  run: npm ci

- name: Unit tests
  run: npm run test
```
