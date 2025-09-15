---
description: Typecheck estricto con TypeScript (tsc --noEmit)
---

Asegura que el proyecto compila a nivel de tipos sin emitir archivos.

## 1) Script en package.json
Agrega:

```jsonc
{
  "scripts": {
    // ...
    "typecheck": "tsc --noEmit"
  }
}
```

## 2) Ejecutar localmente
```bash
npm run typecheck
```

## 3) Recomendaciones de tsconfig
En `tsconfig.json`, considera habilitar o verificar estas opciones:

```jsonc
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "noFallthroughCasesInSwitch": true,
    "exactOptionalPropertyTypes": true
  }
}
```

Ajusta según tu tolerancia; comienza con `strict: true` y agrega el resto de forma incremental.

## 4) CI (resumen)
```yaml
- name: Typecheck
  run: npm run typecheck
```
