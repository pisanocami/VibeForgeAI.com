---
description: Data Flow Diagrams between components and services
---

# Data Flow Diagrams — Quick Workflow

Create Mermaid flowcharts to visualize how data moves across UI, Contexts, API, and DB.

## Preflight (Windows PowerShell)
// turbo
```powershell
$dirs = @('docs/data-flow','project-logs/data-flow')
$dirs | ForEach-Object { if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ | Out-Null } }
```

## Steps
1) Pick a name (kebab-case), e.g. `messaging-flow` or `notifications-flow`.
2) Create `docs/data-flow/<name>.mmd`.
3) Start from the template and adapt nodes/edges to your case.

## Template (Mermaid)
```mermaid
flowchart TD
  subgraph UI[Frontend]
    App[App Root] --> Page[Feature Page]
    Page --> Ctx[React Context / Hook]
  end

  Ctx -->|fetch| API[Backend API]
  API --> DB[(Postgres / Data API)]
  DB --> API
  API -->|JSON| Ctx
  Ctx --> Page

  %% Optional external services
  API -.-> LLM[(LLM: Gemini/OpenAI)]
  API -.-> Notion[Notion API]

  classDef ui fill:#eef7ff,stroke:#1b4b91
  classDef bff fill:#fff7e6,stroke:#9e6c00
  classDef db fill:#e6fffa,stroke:#285e61
  class App,Page,Ctx ui
  class API bff
  class DB db
```

## Tips
- Keep arrows directional according to real request/response.
- Use subgraphs to group areas (UI/API/DB/External).
- Add notes for caching, retries, and error paths.
