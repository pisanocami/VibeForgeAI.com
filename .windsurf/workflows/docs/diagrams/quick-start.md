# Guía Rápida — MVP Workflows

```mermaid
%% Archivo generado desde quick-start.mmd
graph TB
  subgraph hero ["🚀 MVP Workflows"]
    H1["✨ Describe tu app → 📦 Código completo generado"]
  end

  subgraph steps ["🎯 Cómo funciona"]
    direction LR
    S1["1️⃣<br/>💭<br/>Describe<br/><small>'React dashboard'</small>"] 
    S2["2️⃣<br/>▶️<br/>Ejecuta<br/><small>./run-mvp.ps1</small>"] 
    S3["3️⃣<br/>🎉<br/>Despliega<br/><small>Frontend + Backend</small>"]
    S1 --> S2 --> S3
  end

  subgraph examples ["💡 Ejemplos"]
    E1["📝 Blog<br/>'Next.js blog with auth'"]
    E2["📊 Dashboard<br/>'React analytics dashboard'"] 
    E3["🔌 API<br/>'FastAPI with PostgreSQL'"]
  end

  subgraph output ["📦 Obtienes"]
    O1["📁 /client (React+Vite)"]
    O2["📁 /server (Fastify+DB)"]
    O3["📚 /docs (PRD+API)"]
  end

  hero --> steps
  steps --> examples
  examples --> output

  classDef heroStyle fill:#e3f2fd,stroke:#1565c0,stroke-width:3px,font-size:18px
  classDef stepStyle fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
  classDef exampleStyle fill:#fff3e0,stroke:#ef6c00,stroke-width:1px
  classDef outputStyle fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px

  class H1 heroStyle
  class S1,S2,S3 stepStyle  
  class E1,E2,E3 exampleStyle
  class O1,O2,O3 outputStyle
```
