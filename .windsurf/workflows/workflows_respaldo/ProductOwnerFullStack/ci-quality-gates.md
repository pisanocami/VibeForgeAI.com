---
description: CI/CD Básico de Calidad con gates para types, tests, deps y artefactos de logs
---

# /ci-quality-gates

## Objetivo
Configurar un pipeline de CI que bloquee PRs si fallan tipos, tests o chequeos heurísticos de dependencias/exports, y que adjunte artefactos de diagnóstico.

## Entradas
- Repositorio con `package.json`
- Scripts o comandos equivalentes disponibles

## Pasos
1) Definir scripts locales (si no existen)
- `"ci:types": "tsc --noEmit"`
- `"ci:test": "vitest run --reporter=verbose || true"` (ajusta runner)
- `"ci:depcheck": "depcheck"`
- `"ci:tsprune": "ts-prune"`
- `"ci:lint": "eslint ."` (opcional)

2) Pipeline (vendor-agnostic)
- Job: Types
  - Ejecuta `npm run ci:types`
  - Guarda salida en `project-logs/ts-diagnostics.txt`
- Job: Tests
  - Ejecuta `npm run ci:test`
  - Guarda reporte en `project-logs/tests.txt`
- Job: Deps/Exports
  - Ejecuta `npm run ci:depcheck` y `npm run ci:tsprune`
  - Guarda `project-logs/depcheck.txt` y `project-logs/ts-prune.txt`
- Job: Lint (opcional)
  - Ejecuta `npm run ci:lint` y guarda `project-logs/lint.txt`
- Publica artefactos `project-logs/*`

3) Gates
- Fallar el pipeline si `ci:types` retorna error
- Fallar si tests retornan error (si decides hacerlo estricto)
- Permitir warnings en depcheck/ts-prune pero dejar evidencia en artefactos

4) Integración con PRs
- Requerir que el workflow CI pase para poder mergear
- Mostrar enlaces a artefactos y a `orchestrator-status` si se ejecuta en CI

## Aceptación
- Workflow CI activo que ejecuta los 3 checks y adjunta `project-logs/*`
- PRs bloqueados si tipos o tests fallan
- Documentación en `docs/ci.md` con cómo correrlo localmente

## Notas
- Ajusta runner de tests a tu stack (vitest/jest).
- En proyectos sin tests, deja el job como `allowed-to-fail` temporalmente, pero crea un ticket para activarlo.
