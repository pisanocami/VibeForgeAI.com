---
description: Workflow sistemático para identificar, diagnosticar y resolver errores en aplicaciones
---

### Paso 1: Recopilar Información del Error
Reúne toda la información relevante sobre el error:
- Mensaje de error completo
- Stack trace si aplica
- Contexto donde ocurre (acción del usuario, endpoint, componente)
- Variables relevantes en ese momento
- Logs del sistema/consola

### Paso 2: Clasificar el Tipo de Error
Determina la categoría del error:
- **Errores de sintaxis**: Problemas en el código fuente
- **Errores de runtime**: Ocurren durante la ejecución
- **Errores lógicos**: Código funciona pero produce resultados incorrectos
- **Errores de integración**: Problemas entre componentes/servicios
- **Errores de configuración**: Variables de entorno, dependencias, etc.
- **Errores de red**: Conexiones, timeouts, respuestas HTTP
- **Errores de base de datos**: Consultas, conexiones, esquemas

### Paso 3: Reproducir el Error
Intenta reproducir el error de manera consistente:
- Identifica los pasos exactos para trigger el error
- Crea un caso de prueba mínimo que reproduzca el problema
- Verifica si ocurre en diferentes entornos (desarrollo, staging, producción)

### Paso 4: Análisis Inicial
Realiza una primera inspección del código:
- Revisa el código donde ocurre el error
- Busca patrones similares en el codebase
- Verifica dependencias y versiones
- Revisa configuraciones relacionadas

### Paso 5: Debugging Profundizado
Aplica técnicas de debugging apropiadas:
- **Para errores de código:**
  - Agrega logs de debug en puntos estratégicos
  - Usa breakpoints y herramientas de debugging
  - Revisa variables y estado en tiempo de ejecución
- **Para errores de red:**
  - Verifica conectividad y endpoints
  - Revisa headers y payloads de requests
  - Verifica certificados y configuración SSL
- **Para errores de base de datos:**
  - Verifica conexiones y queries
  - Revisa esquemas y migraciones
  - Verifica permisos y usuarios

### Paso 6: Proponer e Implementar Solución
- Identifica la causa raíz del error
- Propone una o más soluciones posibles
- Implementa la solución más apropiada
- Asegura que la solución no introduzca nuevos problemas

### Paso 7: Pruebas y Validación
Verifica que la solución funcione correctamente:
- Repite los pasos que causaban el error
- Ejecuta tests relevantes
- Verifica en diferentes entornos si aplica
- Monitorea logs para asegurar no hay regresiones

### Paso 8: Documentación y Prevención
- Documenta el error y su solución
- Agrega tests para prevenir regresiones
- Actualiza documentación si es necesario
- Identifica mejoras preventivas (linting, type checking, etc.)

### Herramientas Recomendadas
- **Debugging:** Chrome DevTools, VS Code Debugger, console.log
- **Monitoreo:** Sentry, LogRocket, DataDog
- **Testing:** Jest, Cypress, Postman
- **Linters:** ESLint, Prettier, TypeScript
- **Version Control:** Git para rastrear cambios

### Checklist Final
- [ ] Error identificado y clasificado
- [ ] Error reproducible consistentemente
- [ ] Causa raíz encontrada
- [ ] Solución implementada
- [ ] Solución probada exhaustivamente
- [ ] Documentación actualizada
- [ ] Tests agregados para prevenir regresiones
