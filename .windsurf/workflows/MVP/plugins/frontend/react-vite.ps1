# React + Vite Plugin
# Plugin para scaffold de frontend con React + Vite

param(
    [string]$TargetDir = "client",
    [string]$UIFramework = "tailwind+shadcn",
    [switch]$TypeScript = $true
)

function Install-ReactViteFrontend {
    param(
        [string]$TargetDir = "client",
        [string]$UIFramework = "tailwind+shadcn",
        [bool]$TypeScript = $true
    )

    Write-Host "⚛️ Instalando React + Vite en $TargetDir"

    # Crear proyecto con Vite
    $template = if ($TypeScript) { "react-ts" } else { "react" }
    npm create vite@latest $TargetDir -- --template $template --yes

    # Entrar al directorio
    Push-Location $TargetDir

    # Instalar dependencias
    npm install

    # Instalar UI framework
    switch ($UIFramework) {
        "tailwind+shadcn" {
            Write-Host "🎨 Instalando Tailwind CSS + shadcn/ui"
            npm install -D tailwindcss postcss autoprefixer
            npm install @radix-ui/react-dialog lucide-react class-variance-authority clsx tailwind-merge
            npx tailwindcss init -p

            # Configurar Tailwind
            $tailwindConfig = @"
module.exports = {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
}
"@
            $tailwindConfig | Out-File -Encoding UTF8 "tailwind.config.js"

            $cssContent = @"
@tailwind base;
@tailwind components;
@tailwind utilities;
"@
            $cssContent | Out-File -Encoding UTF8 "src/index.css"
        }
        "tailwind" {
            Write-Host "🎨 Instalando solo Tailwind CSS"
            npm install -D tailwindcss postcss autoprefixer
            npx tailwindcss init -p

            $tailwindConfig = @"
module.exports = {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
}
"@
            $tailwindConfig | Out-File -Encoding UTF8 "tailwind.config.js"

            $cssContent = @"
@tailwind base;
@tailwind components;
@tailwind utilities;
"@
            $cssContent | Out-File -Encoding UTF8 "src/index.css"
        }
        default {
            Write-Host "🎨 Sin framework UI adicional"
        }
    }

    # Instalar dependencias comunes
    npm install @tanstack/react-query axios

    Pop-Location

    Write-Host "✅ Frontend React + Vite instalado en $TargetDir"
}

# Ejecutar si se llama directamente
Install-ReactViteFrontend -TargetDir $TargetDir -UIFramework $UIFramework -TypeScript $TypeScript
