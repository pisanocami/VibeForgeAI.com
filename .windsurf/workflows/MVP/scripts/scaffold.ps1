# scaffold.ps1 - Funciones de scaffolding y copia de templates
# Requiere: config.ps1

function Copy-Template {
    param(
        [string]$TemplatePath,
        [string]$TargetDir,
        [switch]$Force
    )

    if (-not (Test-Path $TemplatePath)) {
        Write-Log "Template no encontrado: $TemplatePath" "ERROR"
        return $false
    }

    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
        Write-Log "Directorio creado: $TargetDir" "OK"
    }

    try {
        Copy-Item -Path "$TemplatePath/*" -Destination $TargetDir -Recurse -Force:$Force
        Write-Log "Template copiado exitosamente de $TemplatePath a $TargetDir" "OK"
        return $true
    } catch {
        Write-Log "Error copiando template: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Create-ProjectStructure {
    param([string]$TargetDir = ".")

    Write-Log "Creando estructura de proyecto en $TargetDir..." "INFO"

    $directories = @(
        "src/lib",
        "src/components",
        "src/pages",
        "src/hooks",
        "src/types",
        "src/components/ui"
    )

    foreach ($dir in $directories) {
        $fullPath = Join-Path $TargetDir $dir
        if (-not (Test-Path $fullPath)) {
            New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
            Write-Log "Directorio creado: $dir" "OK"
        } else {
            Write-Log "Directorio ya existe: $dir" "INFO"
        }
    }
}

function Scaffold-Frontend {
    param(
        [string]$Tech,
        [string]$UILibs,
        [string]$TargetDir = ".",
        [string]$TemplateBase = "templates/front"
    )

    Write-Log "Iniciando scaffolding para $Tech + $UILibs..." "INFO"

    # Crear estructura base
    Create-ProjectStructure -TargetDir $TargetDir

    # Copiar template base
    $templatePath = Join-Path $PSScriptRoot ".." $TemplateBase
    if (Copy-Template -TemplatePath $templatePath -TargetDir $TargetDir) {
        Write-Log "Template base copiado exitosamente" "OK"
    } else {
        Write-Log "Error copiando template base" "WARN"
    }

    # Crear archivos específicos según tecnología
    switch ($Tech) {
        "react-vite" {
            Create-ReactViteFiles -TargetDir $TargetDir
        }
        "nextjs" {
            Create-NextJsFiles -TargetDir $TargetDir
        }
        "sveltekit" {
            Create-SvelteKitFiles -TargetDir $TargetDir
        }
        "angular" {
            Create-AngularFiles -TargetDir $TargetDir
        }
        default {
            Write-Log "Tecnología no soportada: $Tech" "WARN"
        }
    }

    # Configurar UI específica
    switch ($UILibs) {
        "tailwind+shadcn" {
            Configure-TailwindShadcn -TargetDir $TargetDir
        }
        "tailwind" {
            Configure-Tailwind -TargetDir $TargetDir
        }
        "none" {
            Write-Log "Sin configuración UI adicional" "INFO"
        }
        default {
            Write-Log "Configuración UI no soportada: $UILibs" "WARN"
        }
    }

    Write-Log "Scaffolding completado exitosamente" "OK"
}

function Create-ReactViteFiles {
    param([string]$TargetDir)

    Write-Log "Creando archivos específicos para React + Vite..." "INFO"

    $files = @{
        "src/vite-env.d.ts" = @"
// vite-env.d.ts
/// <reference types="vite/client" />
@

        "src/index.css" = @"
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  font-family: Inter, system-ui, Avenir, Helvetica, Arial, sans-serif;
  line-height: 1.5;
  font-weight: 400;

  color-scheme: light dark;
  color: rgba(255, 255, 255, 0.87);
  background-color: #242424;

  font-synthesis: none;
  text-rendering: optimizeLegibility;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  -webkit-text-size-adjust: 100%;
}

a {
  font-weight: 500;
  color: #646cff;
  text-decoration: inherit;
}
a:hover {
  color: #535bf2;
}

body {
  margin: 0;
  display: flex;
  place-items: center;
  min-width: 320px;
  min-height: 100vh;
}

#root {
  max-width: 1280px;
  margin: 0 auto;
  padding: 2rem;
  text-align: center;
}

@media (prefers-color-scheme: light) {
  :root {
    color: #213547;
    background-color: #ffffff;
  }
  a:hover {
    color: #747bff;
  }
}
"@

        "index.html" = @"
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MVP App</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
"@
    }

    foreach ($file in $files.GetEnumerator()) {
        $filePath = Join-Path $TargetDir $file.Key
        $fileDir = Split-Path $filePath -Parent

        if (-not (Test-Path $fileDir)) {
            New-Item -ItemType Directory -Path $fileDir -Force | Out-Null
        }

        $file.Value | Out-File -Encoding UTF8 -FilePath $filePath
        Write-Log "Archivo creado: $($file.Key)" "OK"
    }
}

function Configure-TailwindShadcn {
    param([string]$TargetDir)

    Write-Log "Configurando Tailwind + shadcn/ui..." "INFO"

    $tailwindConfig = @"
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ["class"],
  content: [
    './pages/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './app/**/*.{ts,tsx}',
    './src/**/*.{ts,tsx}',
	],
  prefix: "",
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: "0" },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: "0" },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
}
"@

    $configPath = Join-Path $TargetDir "tailwind.config.js"
    $tailwindConfig | Out-File -Encoding UTF8 -FilePath $configPath

    Write-Log "Tailwind + shadcn configurado" "OK"
}

function Configure-Tailwind {
    param([string]$TargetDir)

    Write-Log "Configurando Tailwind básico..." "INFO"

    $tailwindConfig = @"
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
"@

    $configPath = Join-Path $TargetDir "tailwind.config.js"
    $tailwindConfig | Out-File -Encoding UTF8 -FilePath $configPath

    Write-Log "Tailwind configurado" "OK"
}
