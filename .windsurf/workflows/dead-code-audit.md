---
description: Dead Code Audit — Encuentra archivos/exports no usados e importaciones y dependencias huérfanas (TypeScript + Vite + React)
---

Este workflow te guía para detectar y limpiar “código basura” en proyectos TypeScript/React (Vite) usando varias herramientas complementarias. No ejecuta nada automáticamente; cada paso indica comandos seguros para Windows.

Resultados esperados:
- Reportes JSON/HTML en `project-logs/ci/` para revisión.
- Mapa del bundle y módulos no utilizados.
- Lista de archivos/exports no usados, imports sin uso y dependencias no referenciadas.

Requisitos previos:
- Node.js y npm instalados.
- El repo debe instalar dependencias con `npm install` previamente.

Estructura de reportes sugerida:
- `project-logs/ci/knip-report.json` — análisis de usos (files/exports/scripts)
- `project-logs/ci/ts-prune.json` — exports TypeScript no usados
- `project-logs/ci/depcheck.json` — dependencias no usadas/faltantes
- `project-logs/ci/unimported.json` — archivos no importados y ciclos
- `project-logs/ci/bundle/` — visualización del bundle

Nota: Si una herramienta no está instalada localmente, usa `npx <tool>`; npx la descargará temporalmente.

Paso 0 — Crear carpeta de reportes
1. Crea la carpeta si no existe: `project-logs/ci/bundle`

Paso 1 — Knip: archivos/exports/scripts no usados
- Instalar (opcional, o usa npx): `npm i -D knip`
- Ejecutar:
  - `npx knip --reporter json > project-logs/ci/knip-report.json`
  - Para un resumen en consola: `npx knip`
- Consejos de config (opcional, `knip.json` en la raíz):
```
{
  "$schema": "https://unpkg.com/knip@latest/schema.json",
  "entry": ["src/main.tsx", "vite.config.ts"],
  "ignore": [
    "**/*.d.ts",
    "**/__tests__/**",
    "**/*.stories.*"
  ]
}
```

Paso 2 — ts-prune: exports TS no referenciados
- Instalar (opcional): `npm i -D ts-prune`
- Ejecutar (JSON):
  - `npx ts-prune --ignore "src/**/__tests__/**" --json > project-logs/ci/ts-prune.json`
- Ejecutar (legible):
  - `npx ts-prune | tee project-logs/ci/ts-prune.txt`

Paso 3 — depcheck: dependencias huérfanas o faltantes
- Instalar (opcional): `npm i -D depcheck`
- Ejecutar:
  - `npx depcheck --json > project-logs/ci/depcheck.json`
- Si hay falsos positivos (p. ej. imports dinámicos), agrega excepciones en `package.json`:
```
{
  "depcheck": {
    "ignores": ["some-runtime-only-pkg"],
    "ignoreMatches": ["@types/*"]
  }
}
```

Paso 4 — unimported: archivos no importados, importaciones rotas y ciclos
- Instalar (opcional): `npm i -D unimported`
- Ejecutar (JSON):
  - `npx unimported --flow strict --ignore "src/**/*.d.ts" --update-repo=false --reporter json > project-logs/ci/unimported.json`
- Ejecutar (interactivo):
  - `npx unimported`

Paso 5 — ESLint: imports/vars no usados en código
- Asegúrate de tener ESLint configurado. Reglas recomendadas en `eslint.config.js`:
```
import unusedImports from "eslint-plugin-unused-imports";

export default [
  // ...tu config base
  {
    plugins: { "unused-imports": unusedImports },
    rules: {
      "no-unused-vars": "off",
      "@typescript-eslint/no-unused-vars": "off",
      "unused-imports/no-unused-imports": "error",
      "unused-imports/no-unused-vars": [
        "warn",
        { args: "after-used", argsIgnorePattern: "^_", varsIgnorePattern: "^_" }
      ]
    }
  }
];
```
- Ejecutar:
  - `npm run lint` (o `npx eslint "src/**/*.{ts,tsx}"`)

Paso 6 — Visualizar bundle y detectar módulos pesados/no usados (Vite/Rollup)
- Instalar (opcional): `npm i -D rollup-plugin-visualizer`
- Edita `vite.config.ts` para incluir el plugin en `build.rollupOptions.plugins` (modo analyze). Ejemplo:
```
import { visualizer } from "rollup-plugin-visualizer";

export default defineConfig({
  plugins: [
    react(),
    visualizer({ open: false, filename: "project-logs/ci/bundle/stats.html", gzipSize: true, brotliSize: true })
  ],
});
```
- Construir:
  - `npm run build`
- Abrir el reporte: `project-logs/ci/bundle/stats.html`

Paso 7 — TypeScript: detectar no usados a nivel de compilador
- Activar en `tsconfig.json` (o `tsconfig.app.json` según el proyecto):
```
{
  "compilerOptions": {
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  }
}
```
- Ejecutar typecheck estricto (sin emitir):
  - `npx tsc --noEmit`

Paso 8 — Revisión y limpieza segura
- Orden sugerido de actuación:
  1) Revisa `ts-prune.json` y elimina exports no usados (o marca como `@public` si aplica futuro uso).
  2) Revisa `knip-report.json` para archivos/exports/scrips no referenciados.
  3) Revisa `unimported.json` para archivos huérfanos o ciclos. Considera mover a `__archive__/` si no estás 100% seguro.
  4) Revisa `depcheck.json` y elimina dependencias realmente no usadas. Valida en CI que el build siga OK.
  5) Corre `npm run lint` para aplicar/auto-fix donde posible.
- Mantén commits pequeños y con descripciones claras. Ejecuta `npm run build` y pruebas después de cada ronda de limpieza.

Paso 9 — Integración en CI (opcional)
- Falla el job si se detectan hallazgos críticos. Ejemplos:
  - `npx knip --reporter json | node scripts/ci/fail-on-knip.js`
  - `npx ts-prune --error` (falla si hay exports no usados)

Notas y buenas prácticas
- Usa `// eslint-disable-next-line` y `@ts-ignore` con moderación y justificando en comentario.
- Para feature flags y código temporal, anota con `TODO(date|owner)` y revisa periódicamente.
- Antes de borrar, busca usos dinámicos (p. ej. rutas/cadenas que se resuelven en runtime).

Fin del workflow.
