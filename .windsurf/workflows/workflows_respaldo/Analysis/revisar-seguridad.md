---
description: Revisa la aplicación en busca de vulnerabilidades de seguridad y sugiere mejoras.
---

### Paso 1: Análisis de dependencias
Ejecutar auditoría de seguridad:
```bash
npm audit
npm audit fix
```

### Paso 2: Revisar variables de entorno
Analizar archivos `.env`:
- Verificar que no hay secrets expuestos
- Comprobar que las claves están en `.gitignore`
- Validar configuración de CORS
- Revisar configuración de autenticación

### Paso 3: Análisis de código cliente
Buscar problemas comunes:
- XSS: Uso inseguro de `dangerouslySetInnerHTML`
- Exposición de datos sensibles en localStorage
- Validación de inputs del usuario
- Sanitización de datos

### Paso 4: Análisis de código servidor
Revisar backend:
- Validación de inputs en endpoints
- Autenticación y autorización
- Rate limiting
- Headers de seguridad (CORS, CSP, etc.)
- Sanitización de queries SQL

### Paso 5: Configuración de headers de seguridad
Verificar headers HTTP:
```javascript
// Content-Security-Policy
// X-Frame-Options
// X-Content-Type-Options
// Strict-Transport-Security
```

### Paso 6: Generar reporte de seguridad
Crear documento con:
- Vulnerabilidades encontradas (críticas, altas, medias)
- Recomendaciones específicas
- Código de ejemplo para fixes
- Checklist de seguridad para futuras features
