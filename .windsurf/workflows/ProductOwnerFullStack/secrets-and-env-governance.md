---
description: Gobernanza de secretos y entornos (.env, rotación, acceso, CI) para reducir riesgo operacional
---

# /secrets-and-env-governance

## Objetivo
Establecer prácticas seguras para gestionar secretos y variables de entorno en local, CI/CD y producción, con rotación y auditoría.

## Principios
- Nunca commitear secretos en el repo.
- Uso de variables de entorno en runtime y/o secret manager.
- Rotación periódica y mínima exposición (principio de menor privilegio).

## Entradas
- Lista de secretos actuales (solo nombres, no valores)
- Entornos: local, CI, staging, prod

## Pasos
1) Inventario de secretos
- Crear `docs/security/secrets.md` con tabla: NOMBRE, USO, OWNER, ENTORNOS, ROTACIÓN.
- Ejemplos: `GEMINI_API_KEY`, `NOTION_TOKEN`, `DATABASE_URL`.

2) Repo hygiene
- Verificar `.gitignore` incluye `.env*`.
- Buscar secretos accidentalmente versionados y rotarlos si aplica.

3) Carga segura en local
- Usar `.env` local solo en dev; no subirlo al repo.
- Documentar variables requeridas en `docs/.env.sample` (sin valores reales).

4) CI/CD
- Configurar secretos en el proveedor de CI.
- Exportarlos como variables de entorno del job (nunca en texto plano en logs).
- Asegurar masking y evitar `echo` de valores.

5) Rotación y vencimiento
- Definir política (p.ej., cada 90 días) y responsables.
- Registrar rotaciones en `project-logs/secret-rotations.md` (solo metadata: fecha, quién, qué secreto).

6) Validación automática
- Añadir check en CI para confirmar que `.env` no está versionado.
- Script opcional: validar presencia de variables requeridas antes de arrancar.

## Aceptación
- `docs/security/secrets.md` creado con inventario y owners.
- `docs/.env.sample` presente con claves requeridas (sin valores).
- CI configurado con secretos y masking.
- Política de rotación documentada y primer registro en `project-logs/secret-rotations.md`.

## Notas
- Para Notion (Regla 1): usar `NOTION_WORKSPACE_PAGE_ID` como entrada y crear raíz dinámica por ejecución; nunca persistir IDs en código.
