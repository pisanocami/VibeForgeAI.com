---
description: Component State Diagrams (Mermaid stateDiagram)
---

# Component State Diagrams — Quick Workflow

Create Mermaid state diagrams for component lifecycles (Loading → Ready → Error, etc.).

## Preflight (Windows PowerShell)
// turbo
```powershell
$dir = 'docs/state'
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
```

## Steps
1) Pick a component/page (e.g., `CompanyDashboard`).
2) Create `docs/state/<component-name>-state.mmd`.
3) Start from the template and tailor transitions/notes.

## Template (Mermaid)
```mermaid
stateDiagram-v2
  [*] --> Mounted
  Mounted --> Loading: init()
  Loading --> Ready: fetch success
  Loading --> Error: fetch fail

  Ready --> Updating: user action
  Updating --> Ready: success
  Updating --> Error: failure

  Error --> Retrying: retry()
  Retrying --> Ready: success
  Retrying --> Error: failure

  Ready --> [*]: unmount
  Error --> [*]: unmount

  note right of Loading
    Show skeleton/spinner
    Disable interactions
  end note

  note right of Ready
    Render data
    Enable interactions
  end note

  note right of Error
    Show error message
    Provide retry
  end note
```

## Tips
- Add guards for permissions/feature flags as separate states.
- Use sub‑states if the component has tabs or multi‑step flows.
