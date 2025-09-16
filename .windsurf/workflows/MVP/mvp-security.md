---
description: MVP — Auditoría de seguridad básica (deps, SAST opcional, secretos, a11y)
category: mvp
stability: stable
---

# /mvp-security — Seguridad básica para MVP

Ejecuta chequeos rápidos de seguridad para el MVP: dependencias vulnerables, escaneo estático opcional, gobierno de secretos y verificación de accesibilidad básica.

Related: `/revisar-seguridad`, `/secrets-and-env-governance`, `/a11y-checklist`

## Preflight (Windows PowerShell) — seguro para auto‑ejecutar
// turbo
```powershell
$paths = @('project-logs/security')
$paths | ForEach-Object { if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ | Out-Null } }
```

## Pasos
1) Dependencias
   - Node: `npm audit --json | Out-File -Encoding UTF8 project-logs/security/npm-audit.json`
   - Python (si aplica): `pip list --outdated > project-logs/security/pip-outdated.txt`
2) SAST (opcional)
   - Semgrep (si instalado): `semgrep --config p/owasp-top-ten --json > project-logs/security/semgrep.json`
3) Secretos y entornos
   - Ejecuta `/secrets-and-env-governance` y registra hallazgos.
4) A11y rápida (frontend)
   - Ejecuta `/a11y-checklist`.

## Artefactos
- `project-logs/security/*.json|*.txt`
- Resumen `project-logs/security/summary-{date}.md`

## Aceptación (Done)
- Reporte de deps guardado
- (Si aplica) reporte SAST guardado
- Checklist de secretos y a11y ejecutados
