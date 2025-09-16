---
description: Analiza y optimiza el bundle de la aplicación para reducir el tamaño y mejorar el tiempo de carga.
---

### Paso 1: Analizar el bundle actual
Ejecuta comandos para analizar el bundle:
```bash
npm run build
npx vite-bundle-analyzer dist
```

### Paso 2: Identificar archivos pesados
Busca en el proyecto:
- Librerías grandes no utilizadas completamente
- Imágenes sin optimizar
- Código duplicado
- Imports innecesarios

### Paso 3: Analizar dependencias
Revisa `package.json` y busca:
- Dependencias no utilizadas
- Versiones desactualizadas
- Alternativas más ligeras
- Dependencias que deberían ser devDependencies

### Paso 4: Implementar optimizaciones
Aplicar mejoras:
- **Tree shaking**: Importar solo funciones específicas
- **Code splitting**: Dividir rutas con React.lazy()
- **Lazy loading**: Cargar componentes bajo demanda
- **Comprimir imágenes**: Optimizar assets estáticos
- **Remover dependencias**: Eliminar librerías no usadas

### Paso 5: Configurar optimizaciones de build
Actualizar configuración de Vite:
- Configurar chunks óptimos
- Habilitar compresión
- Optimizar CSS
- Configurar cache headers

### Paso 6: Medir mejoras
Comparar métricas antes y después:
- Tamaño del bundle
- Tiempo de carga inicial
- Métricas de Web Vitals
- Puntuación de Lighthouse
