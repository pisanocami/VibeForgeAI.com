# Artifacts, Naming, and Logs — vibeforgeai.com

Date: 2025-09-15T09:18:01-03:00

## Directories
- Logs: `project-logs/**`
- Docs: `docs/design/`
- Public assets: `public/brand/`

## Naming Convention
- `kebab-case` + `{ISO_TIMESTAMP}`
- Examples:
  - `project-logs/product/brand-intake-2025-09-15T12-00-00Z.md`
  - `project-logs/ux/contrast.json`

## Required Artifacts
- Each workflow step produces a `.md` log in `project-logs/product/`.
- Token files and manifests are linked from the logs.

## Versioning
- Include `version:` and `date:` fields at the top of all documents.

## Traceability
- Cross-link between logs and documentation pages in `docs/design/`.
