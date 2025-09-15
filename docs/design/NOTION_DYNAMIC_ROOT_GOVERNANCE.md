# Notion Dynamic Root Governance — vibeforgeai.com

Policy Date: 2025-09-15T09:18:01-03:00

## Rule
- Every script that creates Notion pages must create a NEW dynamic root page at each execution.
- Do not use hardcoded IDs or previous context IDs.

## Implementation Requirements
1. Script reads workspace container from environment variables.
2. Script creates a new root page in that workspace.
3. Script fetches the new root page ID dynamically.
4. Script uses that ID for all subpages.

## Audit Checklist
- [ ] No hardcoded IDs in code
- [ ] Root page created on each run
- [ ] Root ID captured dynamically
- [ ] ID logged at `project-logs/product/notion-root-{timestamp}.json`

## Error Handling
- Provide clear error messages with remediation steps (invalid token, permissions, network).
- Never continue if dynamic root creation fails.

## Documentation
- All scripts must include usage docs, prerequisites, and error handling notes.
