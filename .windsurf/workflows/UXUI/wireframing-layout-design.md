---
description: UX/UI Wireframing & Layout Design Workflow
auto_execution_mode: 3
---

# UX/UI Wireframing & Layout Design

Workflow para expertos en UX/UI que necesitan crear wireframes, layouts consistentes y solucionar problemas de estilo inconsistente en aplicaciones React/Vite.

## 🎯 Objetivo
Crear layouts consistentes y wireframes profesionales que resuelvan problemas de estilo entre páginas.

## 📋 Pasos del Workflow

### 1. Análisis de Páginas Existentes
- Abrir todas las páginas de la aplicación en el navegador
- Documentar diferencias de estilo entre páginas
- Identificar patrones inconsistentes (tipografía, espaciado, componentes)

### 2. Diseño del Sistema de Layout
```typescript
// Crear layout consistente en src/components/layout/
- PageLayout.tsx (layout base para todas las páginas)
- NavigationLayout.tsx (navegación consistente)
- ContentGrid.tsx (sistema de grid responsive)
- SectionContainer.tsx (contenedores de sección)
```

### 3. Creación de Componentes Base
- Card components consistentes
- Button variants estandarizados
- Typography hierarchy
- Spacing system (usando Tailwind tokens)

### 4. Wireframing por Página
Para cada página inconsistente:
- Crear wireframe digital
- Definir estructura de componentes
- Aplicar layout consistente
- Testear en diferentes breakpoints

### 5. Implementación del Sistema de Diseño
```bash
# Ejecutar comandos para actualizar estilos
npm run build:css
npm run dev
```

### 6. Validación de Consistencia
- Comparar todas las páginas
- Verificar uso consistente de componentes
- Testear responsive design
- Validar accesibilidad (WCAG)

## 🛠️ Herramientas Recomendadas
- Figma/Adobe XD para wireframing
- Browser DevTools para debugging de estilos
- Tailwind CSS para sistema de diseño
- Storybook para componentes

## 📊 Checklist de Consistencia
- [ ] Navegación consistente en todas las páginas
- [ ] Tipografía unificada (headings, body text)
- [ ] Espaciado consistente (margins, padding)
- [ ] Componentes reutilizables
- [ ] Responsive design funcional
- [ ] Colores y branding consistentes