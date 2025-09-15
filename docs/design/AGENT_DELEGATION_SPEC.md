# Agent Delegation Spec — vibeforgeai.com

Date: 2025-09-15T09:18:01-03:00
Owner: Branding Orchestrator

## Roles
- Brand Intake Agent
- Brand Definition Agent
- Tokenization Agent (Design Systems)
- Visual Identity Agent
- Voice & Messaging Agent
- Asset Kit Agent
- Validation & Handoff Agent

## RACI
- Orchestrator: A
- Assigned Agent: R
- Reviewer: C
- Dev Integrator: I

## Inputs per Agent
- Intake: stakeholder notes, market refs
- Definition: intake output
- Tokens: definition output + UI constraints
- Visual Identity: tokens + definition
- Voice: definition + intake
- Asset Kit: tokens + identity + voice
- Handoff: all previous outputs

## Outputs per Agent
- As specified in `/branding-orchestrator`; stored in `project-logs/product/*-{timestamp}.md`.

## Prompts and Acceptance Criteria
- Each agent uses the matching template in `docs/design/templates/` and must fill all sections.
- Each output must include timestamp, version, open issues, next steps.
- AA/AAA contrast evidence is mandatory for token colors.

## Governance
- No hardcoded Notion IDs. Use Dynamic Root script if Notion pages are created.
- File naming: kebab-case + ISO timestamp.

## Handoffs
- Push assets to `public/brand/` and log manifest paths.
- Update `project-logs/product/brand-handoff-{timestamp}.md` with links.
