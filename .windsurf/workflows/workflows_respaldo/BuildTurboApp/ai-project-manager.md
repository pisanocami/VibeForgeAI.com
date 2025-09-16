---
description: AI Project Manager que toma decisiones automáticas sobre qué workflows ejecutar y cuándo.
---

### Paso 1: Análisis de input del usuario
Analizar la solicitud del usuario para determinar:
- Tipo de proyecto (web app, API, mobile, etc.)
- Complejidad estimada (1-10)
- Timeline disponible
- Recursos necesarios

### Paso 2: Cálculo de Complexity Score
Usar la fórmula:
```
COMPLEXITY_SCORE = 
  (features_count * 2) + 
  (integrations_needed * 3) + 
  (custom_ui_requirements * 2) + 
  (backend_complexity * 4)
```

### Paso 3: Decisión de Path
- Si COMPLEXITY_SCORE <= 15 AND timeline <= 48h: **Rapid Path**
- Si COMPLEXITY_SCORE > 15 AND timeline > 48h: **Master Path**
- Si timeline crítico: **Rapid Path** (con features reducidas)

### Paso 4: Ejecución automática
Ejecutar el workflow correspondiente:
- `/vibe-coder-rapid` para Rapid Path
- `/vibe-coder-master` para Master Path
- `/orchestrator` para proyectos complejos que requieren coordinación

### Paso 5: Logging y métricas
- Crear archivo de log en `project-logs/`
- Actualizar métricas del proyecto en tiempo real
- Documentar decisiones y progreso

### Fase 2: Delegación Inteligente
**Decision Tree:**
```
START
├── Complexity Analysis
│   ├── Simple (Score 1-5) → Rapid Path
│   ├── Medium (Score 6-10) → Hybrid Path
│   └── Complex (Score 11+) → Master Path
│
├── Timeline Analysis
│   ├── <24h → Force Rapid Path
│   ├── 24-72h → Rapid or Hybrid
│   └── >72h → Master Path
│
└── Resource Analysis
    ├── Solo developer → Streamlined workflows
    ├── Small team → Parallel workflows
    └── Large team → Full orchestration
```

### Fase 3: Ejecución Paralela
**Workflows que pueden ejecutarse en paralelo:**
- `/crear-componente` + `/generar-tipos`
- `/crear-endpoint-api` + `/escribir-prueba`
- `/documentar-codigo` + `/revisar-seguridad`

**Workflows secuenciales (dependencias):**
1. `/vibe-coder-intelligence` → Path selection
2. Component creation → Testing
3. Development → Optimization
4. Optimization → Final analysis

### Fase 4: Quality Assurance Automática
**Checkpoints automáticos:**
- Después de cada componente: Ejecutar tests
- Después de 5 componentes: Refactor check
- Al 50% del desarrollo: Performance audit
- Al 80% del desarrollo: Security review
- Pre-deploy: Complete analysis con `/agent`

### Fase 5: Adaptive Learning
**El AI PM aprende de cada proyecto:**
- Qué workflows fueron más efectivos
- Cuánto tiempo tomó cada fase
- Qué problemas surgieron más frecuentemente
- Ajusta futuras decisiones basado en historial

### Comandos de Control
- `PAUSE` - Pausa la ejecución automática
- `SKIP [workflow]` - Omite un workflow específico
- `FORCE [workflow]` - Fuerza ejecución de workflow
- `STATUS` - Muestra progreso actual
- `ROLLBACK [step]` - Revierte a paso anterior
