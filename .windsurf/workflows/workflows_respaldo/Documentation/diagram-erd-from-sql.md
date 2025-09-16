---
description: Generate Mermaid ERD (Entity‑Relationship Diagram) from SQL schema
---

# ERD from SQL — Quick Workflow

Create a Mermaid ERD based on your Postgres schema (tables, PKs/FKs). Works great with files like `scripts/neon/schema.sql`.

## Preflight (Windows PowerShell)
// turbo
```powershell
$dir = 'docs/diagrams'
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
```

## Steps (Semi‑auto)
1) Open `scripts/neon/schema.sql`.
2) Identify tables, primary keys, and foreign keys.
3) Create `docs/diagrams/erd.mmd` and paste the template below.
4) Add classes for each table (attributes as fields) and relations for FKs.

## Template (Mermaid classDiagram)
```mermaid
classDiagram
  class users {
    uuid id PK
    text email UNIQUE
    text password_hash
    text name
    text role
    text avatar
    boolean is_online
    timestamptz last_seen
    text company_name
    text company_logo
    text job_title
    text[] skills
    numeric hourly_rate
    timestamptz created_at
    timestamptz updated_at
  }

  class projects {
    uuid id PK
    text title
    text description
    text status
    text budget_type
    numeric amount
    text currency
    text[] skills_required
    timestamptz start_date
    timestamptz end_date
    uuid company_id FK -> users.id
    timestamptz created_at
    timestamptz updated_at
  }

  class conversations {
    uuid id PK
    uuid project_id FK -> projects.id
    timestamptz created_at
    timestamptz updated_at
  }

  class conversation_participants {
    uuid conversation_id FK -> conversations.id
    uuid user_id FK -> users.id
    <<PK (conversation_id, user_id)>>
  }

  class messages {
    uuid id PK
    text content
    uuid sender_id FK -> users.id
    uuid conversation_id FK -> conversations.id
    boolean is_read
    timestamptz created_at
  }

  class payments {
    uuid id PK
    numeric amount
    text currency
    text status
    text type
    text description
    jsonb metadata
    uuid from_id FK -> users.id
    uuid to_id FK -> users.id
    timestamptz created_at
    timestamptz updated_at
  }

  class notifications {
    uuid id PK
    uuid user_id FK -> users.id
    text type
    text title
    text message
    boolean is_read
    text action_url
    timestamptz created_at
  }

  %% Relations (Mermaid: A --> B means A depends on B)
  projects --> users : company_id
  conversations --> projects : project_id
  conversation_participants --> conversations : conversation_id
  conversation_participants --> users : user_id
  messages --> users : sender_id
  messages --> conversations : conversation_id
  payments --> users : from_id
  payments --> users : to_id
  notifications --> users : user_id
```

## Tips
- Use `<<PK>>` to annotate composite primary keys.
- Keep field types to help future readers.
- If schema changes, update this file and commit with the same PR as the migration.
