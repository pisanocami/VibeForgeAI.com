---
description: Environment Setup - Configuración automatizada para nuevos developers
---

# Environment Setup Workflow

Configuración completa y automatizada del ambiente de desarrollo para nuevos miembros del equipo.

## Pre-requisitos
- Sistema operativo soportado (Windows/Mac/Linux)
- Privilegios de administrador para instalación de herramientas
- Conexión a internet para descargas
- Cuenta en repositorios necesarios

## Pasos del Workflow

### 1. Verificación de Requisitos del Sistema
```bash
#!/bin/bash
# check-requirements.sh

echo "🔍 Verificando requisitos del sistema..."

# Verificar OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS="windows"
else
    echo "❌ Sistema operativo no soportado: $OSTYPE"
    exit 1
fi
echo "✅ Sistema operativo detectado: $OS"

# Verificar arquitectura
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "arm64" ]] || [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
fi
echo "✅ Arquitectura detectada: $ARCH"

# Verificar memoria
MEM_GB=$(free -g | awk 'NR==2{printf "%.0f", $2}')
if [ "$MEM_GB" -lt 8 ]; then
    echo "⚠️  Memoria baja detectada: ${MEM_GB}GB (recomendado: 16GB+)"
else
    echo "✅ Memoria suficiente: ${MEM_GB}GB"
fi

# Verificar espacio en disco
DISK_GB=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
if [ "$DISK_GB" -lt 20 ]; then
    echo "⚠️  Espacio en disco bajo: ${DISK_GB}GB (recomendado: 50GB+)"
else
    echo "✅ Espacio en disco suficiente: ${DISK_GB}GB"
fi

echo "✅ Verificación de requisitos completada"
```

### 2. Instalación Automática de Herramientas
```bash
#!/bin/bash
# setup-dev-environment.sh

set -e

echo "🚀 Iniciando configuración del ambiente de desarrollo..."

# Detectar OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS="windows"
else
    echo "❌ Sistema operativo no soportado"
    exit 1
fi

# Función para instalar herramientas
install_tool() {
    local tool=$1
    local install_cmd=$2
    local check_cmd=$3

    echo "📦 Instalando $tool..."
    if eval "$check_cmd" &> /dev/null; then
        echo "✅ $tool ya está instalado"
    else
        eval "$install_cmd"
        echo "✅ $tool instalado exitosamente"
    fi
}

# Instalar Git
if [[ "$OS" == "macos" ]]; then
    install_tool "Git" "brew install git" "git --version"
elif [[ "$OS" == "linux" ]]; then
    install_tool "Git" "sudo apt-get update && sudo apt-get install -y git" "git --version"
elif [[ "$OS" == "windows" ]]; then
    install_tool "Git" "winget install --id Git.Git -e --source winget" "git --version"
fi

# Instalar Node.js (usando nvm para mejor control de versiones)
install_tool "NVM" "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash" "nvm --version"

# Recargar shell para nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Instalar Node.js LTS
nvm install --lts
nvm use --lts
nvm alias default node

# Instalar Yarn
if [[ "$OS" == "macos" ]]; then
    install_tool "Yarn" "brew install yarn" "yarn --version"
elif [[ "$OS" == "linux" ]]; then
    install_tool "Yarn" "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && echo 'deb https://dl.yarnpkg.com/debian/ stable main' | sudo tee /etc/apt/sources.list.d/yarn.list && sudo apt-get update && sudo apt-get install -y yarn" "yarn --version"
elif [[ "$OS" == "windows" ]]; then
    install_tool "Yarn" "winget install --id Yarn.Yarn -e --source winget" "yarn --version"
fi

# Instalar Docker
if [[ "$OS" == "macos" ]]; then
    install_tool "Docker" "brew install --cask docker" "docker --version"
elif [[ "$OS" == "linux" ]]; then
    install_tool "Docker" "curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh" "docker --version"
elif [[ "$OS" == "windows" ]]; then
    install_tool "Docker" "winget install --id Docker.DockerDesktop -e --source winget" "docker --version"
fi

# Instalar VS Code
if [[ "$OS" == "macos" ]]; then
    install_tool "VS Code" "brew install --cask visual-studio-code" "code --version"
elif [[ "$OS" == "linux" ]]; then
    install_tool "VS Code" "wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && sudo sh -c 'echo \"deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main\" > /etc/apt/sources.list.d/vscode.list' && sudo apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install -y code" "code --version"
elif [[ "$OS" == "windows" ]]; then
    install_tool "VS Code" "winget install --id Microsoft.VisualStudioCode -e --source winget" "code --version"
fi

echo "✅ Instalación de herramientas completada"
echo "🔄 Configurando Git..."

# Configurar Git
read -p "Ingresa tu nombre completo: " git_name
read -p "Ingresa tu email: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global core.autocrlf input
git config --global init.defaultBranch main
git config --global pull.rebase true

echo "✅ Git configurado"
```

### 3. Configuración del Proyecto
```bash
#!/bin/bash
# setup-project.sh

set -e

echo "📁 Configurando proyecto..."

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo "❌ package.json no encontrado. Asegúrate de estar en el directorio del proyecto"
    exit 1
fi

# Instalar dependencias
echo "📦 Instalando dependencias..."
if [ -f "yarn.lock" ]; then
    yarn install
elif [ -f "package-lock.json" ]; then
    npm ci
else
    npm install
fi

# Configurar environment files
echo "🔧 Configurando variables de entorno..."

if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "✅ .env creado desde .env.example"
        echo "⚠️  Recuerda configurar tus variables de entorno en .env"
    else
        echo "⚠️  No se encontró .env.example. Crea .env manualmente"
    fi
fi

# Configurar Git hooks
if [ -f "package.json" ]; then
    if grep -q "husky" package.json; then
        echo "🔗 Configurando Git hooks..."
        npm run prepare
        echo "✅ Git hooks configurados"
    fi
fi

# Verificar configuración de base de datos
if grep -q "DATABASE_URL" .env 2>/dev/null; then
    echo "🗄️  Configuración de base de datos detectada"
    echo "⚠️  Asegúrate de que la base de datos esté corriendo"
fi

# Ejecutar setup scripts si existen
if [ -f "scripts/setup.js" ]; then
    echo "⚙️  Ejecutando script de setup..."
    node scripts/setup.js
fi

if [ -f "scripts/setup.sh" ]; then
    echo "⚙️  Ejecutando script de setup..."
    bash scripts/setup.sh
fi

echo "✅ Configuración del proyecto completada"
```

### 4. Configuración de VS Code
```json
// .vscode/settings.json
{
    // Editor settings
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true,
        "source.organizeImports": true
    },
    "editor.defaultFormatter": "esbenp.prettier-vscode",

    // File associations
    "files.associations": {
        "*.md": "markdown",
        ".env": "properties",
        ".env.*": "properties"
    },

    // Exclude files
    "files.exclude": {
        "**/node_modules": true,
        "**/dist": true,
        "**/.git": false,
        "**/.DS_Store": true
    },

    // Search exclude
    "search.exclude": {
        "**/node_modules": true,
        "**/dist": true,
        "**/coverage": true
    },

    // Extensions recommendations
    "recommendations": [
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint",
        "bradlc.vscode-tailwindcss",
        "ms-vscode.vscode-typescript-next",
        "christian-kohler.path-intellisense",
        "ms-vscode.vscode-json",
        "formulahendry.auto-rename-tag",
        "christian-kohler.npm-intellisense"
    ]
}
```

```json
// .vscode/extensions.json
{
    "recommendations": [
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint",
        "bradlc.vscode-tailwindcss",
        "ms-vscode.vscode-typescript-next",
        "christian-kohler.path-intellisense",
        "ms-vscode.vscode-json",
        "formulahendry.auto-rename-tag",
        "christian-kohler.npm-intellisense",
        "ms-vscode.vscode-chrome-debug-core",
        "ms-vscode.vscode-edge-devtools",
        "humao.rest-client",
        "ms-vscode.vscode-pull-request-github",
        "gruntfuggly.todo-tree",
        "ms-vscode.vscode-git-graph"
    ],
    "unwantedRecommendations": [
        "ms-vscode.vscode-typescript",
        "hookyqr.beautify"
    ]
}
```

```json
// .vscode/launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch Dev Server",
            "type": "node",
            "request": "launch",
            "program": "${workspaceFolder}/node_modules/.bin/vite",
            "args": ["--host", "0.0.0.0"],
            "env": {
                "NODE_ENV": "development"
            },
            "console": "integratedTerminal"
        },
        {
            "name": "Debug Tests",
            "type": "node",
            "request": "launch",
            "program": "${workspaceFolder}/node_modules/.bin/vitest",
            "args": ["run"],
            "console": "integratedTerminal"
        },
        {
            "name": "Attach to Chrome",
            "type": "chrome",
            "request": "attach",
            "port": 9222,
            "webRoot": "${workspaceFolder}/src",
            "url": "http://localhost:3000"
        }
    ]
}
```

### 5. Script de Verificación de Setup
```javascript
// scripts/verify-setup.js
const { execSync } = require('child_process')
const fs = require('fs')
const path = require('path')

class SetupVerifier {
  constructor() {
    this.checks = []
    this.errors = []
  }

  check(name, condition, errorMessage) {
    try {
      const result = condition()
      this.checks.push({
        name,
        status: result ? '✅' : '❌',
        message: result ? 'OK' : errorMessage
      })
      if (!result) {
        this.errors.push(errorMessage)
      }
      return result
    } catch (error) {
      this.checks.push({
        name,
        status: '❌',
        message: error.message
      })
      this.errors.push(error.message)
      return false
    }
  }

  async runAllChecks() {
    console.log('🔍 Verificando configuración del ambiente...\n')

    // Node.js y npm
    this.check(
      'Node.js instalado',
      () => {
        const version = execSync('node --version', { encoding: 'utf8' }).trim()
        return version.startsWith('v')
      },
      'Node.js no está instalado o no funciona correctamente'
    )

    this.check(
      'npm instalado',
      () => {
        const version = execSync('npm --version', { encoding: 'utf8' }).trim()
        return version.length > 0
      },
      'npm no está instalado'
    )

    // Git
    this.check(
      'Git instalado',
      () => {
        const version = execSync('git --version', { encoding: 'utf8' }).trim()
        return version.includes('git version')
      },
      'Git no está instalado'
    )

    this.check(
      'Git configurado',
      () => {
        const name = execSync('git config user.name', { encoding: 'utf8' }).trim()
        const email = execSync('git config user.email', { encoding: 'utf8' }).trim()
        return name.length > 0 && email.length > 0
      },
      'Git user.name y user.email no están configurados'
    )

    // Proyecto
    this.check(
      'Proyecto clonado',
      () => fs.existsSync('package.json'),
      'package.json no encontrado. ¿Estás en el directorio correcto?'
    )

    this.check(
      'Dependencias instaladas',
      () => fs.existsSync('node_modules'),
      'node_modules no encontrado. Ejecuta npm install'
    )

    this.check(
      'Archivo .env existe',
      () => fs.existsSync('.env'),
      '.env no encontrado. Crea el archivo desde .env.example'
    )

    // Verificar scripts de package.json
    if (fs.existsSync('package.json')) {
      const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'))

      this.check(
        'Script dev existe',
        () => packageJson.scripts && packageJson.scripts.dev,
        'Script "dev" no encontrado en package.json'
      )

      this.check(
        'Script build existe',
        () => packageJson.scripts && packageJson.scripts.build,
        'Script "build" no encontrado en package.json'
      )

      this.check(
        'Script test existe',
        () => packageJson.scripts && packageJson.scripts.test,
        'Script "test" no encontrado en package.json'
      )
    }

    // Verificar VS Code settings
    this.check(
      'VS Code settings configurados',
      () => fs.existsSync('.vscode/settings.json'),
      '.vscode/settings.json no encontrado'
    )

    this.displayResults()
  }

  displayResults() {
    console.log('📊 Resultados de verificación:')
    console.log('==============================')

    this.checks.forEach(check => {
      console.log(`${check.status} ${check.name}: ${check.message}`)
    })

    console.log('\n' + '='.repeat(40))

    if (this.errors.length === 0) {
      console.log('🎉 ¡Todas las verificaciones pasaron!')
      console.log('\n🚀 Tu ambiente está listo. Puedes ejecutar:')
      console.log('  npm run dev    # Iniciar servidor de desarrollo')
      console.log('  npm run build  # Construir para producción')
      console.log('  npm test       # Ejecutar tests')
    } else {
      console.log(`❌ ${this.errors.length} errores encontrados:`)
      this.errors.forEach(error => {
        console.log(`  • ${error}`)
      })
      console.log('\n🔧 Corrige los errores antes de continuar.')
    }
  }
}

// Ejecutar verificación
const verifier = new SetupVerifier()
verifier.runAllChecks()
```

### 6. Documentación para Nuevos Developers
```markdown
# Guía de Setup para Nuevos Developers

## 🚀 Inicio Rápido

### Opción 1: Setup Automático (Recomendado)
```bash
# 1. Clonar el repositorio
git clone <repository-url>
cd <project-directory>

# 2. Ejecutar setup automático
curl -fsSL https://raw.githubusercontent.com/<org>/<repo>/main/setup-dev-environment.sh | bash

# 3. Configurar proyecto
bash setup-project.sh

# 4. Verificar setup
npm run verify-setup
```

### Opción 2: Setup Manual

#### Paso 1: Instalar Herramientas Básicas
- **Node.js**: Descargar desde [nodejs.org](https://nodejs.org) (LTS)
- **Git**: Descargar desde [git-scm.com](https://git-scm.com)
- **VS Code**: Descargar desde [code.visualstudio.com](https://code.visualstudio.com)

#### Paso 2: Instalar Extensiones de VS Code
Abre VS Code y instala estas extensiones:
- Prettier
- ESLint
- Tailwind CSS IntelliSense
- TypeScript Importer
- Path Intellisense

#### Paso 3: Configurar el Proyecto
```bash
# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env
# Edita .env con tus configuraciones

# Verificar que todo funciona
npm run dev
```

## 🔧 Troubleshooting

### Problema: "node command not found"
**Solución**: Reinicia tu terminal o reinicia tu sistema después de instalar Node.js

### Problema: "Permission denied" en npm install
**Solución**:
```bash
# En Linux/Mac
sudo chown -R $(whoami) ~/.npm

# En Windows (como administrador)
npm config set prefix %APPDATA%\npm
```

### Problema: Git no reconoce credenciales
**Solución**:
```bash
# Configurar credenciales
git config --global credential.helper store

# O usar SSH en lugar de HTTPS
git remote set-url origin git@github.com:<org>/<repo>.git
```

### Problema: VS Code no reconoce TypeScript
**Solución**: Asegúrate de que la extensión "TypeScript Importer" esté instalada y activada

## 📚 Recursos Adicionales

- [Documentación del Proyecto](./README.md)
- [Guía de Contribución](./CONTRIBUTING.md)
- [Convenciones de Código](./CODESTYLE.md)
- [Preguntas Frecuentes](./FAQ.md)

## 🆘 ¿Necesitas Ayuda?

Si encuentras problemas durante el setup:

1. Revisa esta guía completa
2. Busca en los issues existentes del repositorio
3. Crea un nuevo issue con:
   - Tu sistema operativo y versión
   - Los comandos que ejecutaste
   - El error completo que recibiste
   - Los pasos que ya intentaste

¡Bienvenido al equipo! 👋
```

### 7. CI/CD para Verificación de Setup
```yaml
# .github/workflows/setup-verification.yml
name: Setup Verification
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  verify-setup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Cache node modules
        uses: actions/cache@v3
        with:
          path: ~/.npm
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-

      - name: Install dependencies
        run: npm ci

      - name: Verify setup
        run: node scripts/verify-setup.js

      - name: Check environment files
        run: |
          if [ ! -f ".env.example" ]; then
            echo "⚠️ .env.example not found"
            exit 1
          fi

      - name: Verify VS Code configuration
        run: |
          if [ ! -f ".vscode/settings.json" ]; then
            echo "⚠️ VS Code settings not found"
            exit 1
          fi

          if [ ! -f ".vscode/extensions.json" ]; then
            echo "⚠️ VS Code extensions recommendations not found"
            exit 1
          fi

      - name: Check documentation
        run: |
          if [ ! -f "README.md" ]; then
            echo "⚠️ README.md not found"
            exit 1
          fi

          if [ ! -f "CONTRIBUTING.md" ]; then
            echo "ℹ️ CONTRIBUTING.md not found - consider adding it"
          fi
```

### 8. Template de Issues para Setup
```markdown
<!-- .github/ISSUE_TEMPLATE/setup-issue.md -->
---
name: Setup Issue
about: Problemas durante la configuración del ambiente de desarrollo
title: "[SETUP] "
labels: setup, help wanted
---

## 🐛 Problema de Setup

**Describe el problema:**
Una descripción clara del problema que estás experimentando durante el setup.

**Comandos ejecutados:**
```bash
# Copia y pega los comandos que ejecutaste
```

**Error recibido:**
```
# Copia y pega el error completo
```

**Ambiente:**
- OS: [Windows/Mac/Linux]
- Versión de OS: [ej: Windows 11, macOS 12.1, Ubuntu 20.04]
- Node.js versión: [ej: v18.12.0]
- npm versión: [ej: 8.19.2]
- Git versión: [ej: 2.37.1]

**Pasos intentados para solucionarlo:**
- [ ] Reiniciar terminal
- [ ] Reinstalar Node.js
- [ ] Limpiar cache de npm (`npm cache clean --force`)
- [ ] Eliminar node_modules y package-lock.json
- [ ] Verificar permisos de archivos

**Archivos de configuración:**
- [ ] .env configurado
- [ ] .vscode/settings.json existe
- [ ] Todas las extensiones de VS Code instaladas

**Información adicional:**
Cualquier otra información relevante sobre tu setup.
```

### 9. Checklist de Setup Completo
- [ ] **Herramientas instaladas**: Node.js, npm, Git, VS Code
- [ ] **Dependencias instaladas**: npm install ejecutado exitosamente
- [ ] **Variables de entorno**: .env configurado correctamente
- [ ] **VS Code configurado**: Extensiones y settings aplicados
- [ ] **Git configurado**: user.name y user.email configurados
- [ ] **Proyecto funcional**: npm run dev funciona sin errores
- [ ] **Tests pasan**: npm test ejecuta sin errores
- [ ] **Build funciona**: npm run build funciona correctamente
- [ ] **Documentación leída**: README y guías revisadas

### 10. Automatización con Makefile (para equipos avanzados)
```makefile
# Makefile
.PHONY: setup setup-dev setup-tools verify clean

# Setup completo
setup: setup-tools setup-dev verify

# Instalar herramientas del sistema
setup-tools:
	@echo "📦 Instalando herramientas del sistema..."
	@./scripts/setup-dev-environment.sh

# Configurar proyecto
setup-dev:
	@echo "⚙️ Configurando proyecto..."
	@./scripts/setup-project.sh

# Verificar configuración
verify:
	@echo "🔍 Verificando configuración..."
	@node scripts/verify-setup.js

# Limpiar instalación
clean:
	@echo "🧹 Limpiando instalación..."
	@rm -rf node_modules
	@rm -f package-lock.json
	@rm -f yarn.lock
	@rm -f .env
	@echo "✅ Instalación limpiada"

# Ayuda
help:
	@echo "Comandos disponibles:"
	@echo "  make setup     - Setup completo del proyecto"
	@echo "  make setup-tools - Instalar herramientas del sistema"
	@echo "  make setup-dev - Configurar proyecto específico"
	@echo "  make verify    - Verificar configuración"
	@echo "  make clean     - Limpiar instalación"
	@echo "  make help      - Mostrar esta ayuda"
```

### 11. Mejores Prácticas
- **Documentación clara**: Guías paso a paso para diferentes sistemas operativos
- **Automatización**: Scripts que reduzcan la fricción del setup
- **Verificación**: Chequeos automáticos para asegurar configuración correcta
- **Soporte**: Canales claros para pedir ayuda con problemas de setup
- **Mantenimiento**: Mantener scripts de setup actualizados con cambios del proyecto
- **Versionado**: Especificar versiones exactas de herramientas para consistencia

### 12. Recursos Adicionales
- [Node.js Download](https://nodejs.org/en/download/)
- [Git Download](https://git-scm.com/downloads)
- [VS Code Download](https://code.visualstudio.com/download)
- [NVM Documentation](https://github.com/nvm-sh/nvm)
- [Yarn Installation](https://yarnpkg.com/getting-started/install)
