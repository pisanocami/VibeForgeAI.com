---
description: UX/UI — Accessibility (a11y) Checklist ejecutable para evaluar y mejorar accesibilidad
---

# UX/UI — Accessibility (a11y) Checklist

Esta checklist te guía para evaluar y mejorar la accesibilidad de una app web. Incluye pasos auditables, criterios de aceptación y acciones sugeridas.

## Alcance

- Navegación por teclado y foco visible
- Roles ARIA y semántica HTML
- Contraste de color WCAG AA/AAA
- Formularios (labels, errores, ayudas)
- Medios (alt text, captions)
- Movimiento/animaciones, prefers-reduced-motion
- i18n, idioma del documento y atributos `lang`

## Pre-flight

- Define páginas/flows críticos a evaluar: Home, Login/Register, Checkout, Página de Detalle (o equivalentes)
- Define breakpoints clave: Mobile (360–414), Tablet (768), Desktop (1024–1440)

## 1) Navegación por teclado

- Recorre la UI con `Tab` y `Shift+Tab`. Sin mouse.
- Criterios:
  - El foco siempre es visible y no queda atrapado
  - Orden de tabulación lógico (DOM/visual coherente)
  - Componentes interactivos son alcanzables (links, botones, inputs, toggles)
- Acciones:
  - Agregar estilos de foco dedicados (no solo outline: none)
  - Asegurar uso de elementos nativos o roles correctos

## 2) Gestión de foco y saltos

- Usa skip links ("Saltar al contenido principal") visibles al enfocar
- Al abrir modales, el foco se mueve al modal y se trapea dentro; al cerrar, vuelve al disparador
- Acciones:
  - Implementar `tabindex="-1"` en contenedores destino para focus programático
  - Trapar foco en modales y menús (FocusTrap)

## 3) Semántica y ARIA

- Verifica uso de landmarks: `header`, `nav`, `main`, `aside`, `footer`
- Usa roles ARIA solo si el elemento no semántico lo requiere
- Atributos `aria-expanded`, `aria-controls`, `aria-live` donde corresponda
- Acciones:
  - Reemplazar divs por elementos semánticos apropiados
  - Añadir relaciones `aria-*` coherentes con el estado del componente

## 4) Contraste de color (WCAG 2.1)

- Texto normal: >= 4.5:1; Texto grande (>= 18.66px/14px bold): >= 3:1
- Iconos/gráficos esenciales: >= 3:1
- Estados (hover/focus/disabled) mantienen contraste suficiente
- Acciones:
  - Ajustar tokens de color y variables CSS
  - Usar esquemas con `prefers-color-scheme` y revisar ambos temas

## 5) Formularios y feedback

- Cada input tiene `label` visible y asociado (por `for`/`id` o envolviendo)
- `aria-describedby` para ayudas y mensajes de error
- Errores son anunciados y descritos, no solo color
- Acciones:
  - Implementar validaciones accesibles y mensajes claros
  - Asegurar lectura por screen readers en cambios importantes

## 6) Imágenes y medios

- `alt` significativo en imágenes informativas; vacío en decorativas (`alt=""`)
- Video con captions/subtítulos y controles accesibles
- Evita parpadeos > 3 Hz

## 7) Movimiento y animaciones

- Respeta `prefers-reduced-motion`; provee alternativas o reduce intensidad
- Evita animaciones que dificulten lectura o provoquen mareo

## 8) Idioma e i18n

- `html lang="es"` (o el idioma principal)
- Cambios de idioma inline: `lang` en spans correspondientes
- Fechas/números/moneda localizados

## 9) Automatización y linting

- Ejecuta linters/analizadores cuando existan:
  - ESLint a11y (jsx-a11y)
  - Stylelint con reglas de contraste (si aplica)
  - Axe DevTools (manual/browser)

// turbo
## 10) Artefactos de salida

- Genera un reporte breve:
  - Lista de hallazgos por severidad (Bloqueantes, Altos, Medios, Bajos)
  - Capturas de pantalla o referencias de componentes afectados
  - Acciones propuestas y dueños

## Criterios de aceptación (DoD)

- No hay bloqueantes en flows críticos
- Contraste cumple AA en textos y controles
- Navegación por teclado completa con foco visible en todos los componentes
- Formularios con labels, ayudas y errores accesibles
- Modales/menús con foco gestionado correctamente

## Recursos recomendados

- WCAG 2.1 Quick Reference: https://www.w3.org/WAI/WCAG21/quickref/
- Deque Axe DevTools: https://www.deque.com/axe/
- Inclusive Components: https://inclusive-components.design/

## Relación con otros workflows

- `Development/design-and-styling.md` — Ajustes de tokens y contraste sistemático
- `Optimization/mejorar-ux-ui.md` — Mejora holística de UX/UI
