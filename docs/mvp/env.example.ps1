# Copia este archivo a env.ps1, ajusta valores y carga en tu sesión con:  . .\env.ps1

# Notion (Regla 1: crear SIEMPRE raíz dinámica)
$env:NOTION_TOKEN = "secret_notion_token"
$env:NOTION_WORKSPACE_PAGE_ID = "parent_page_id"

# Overrides opcionales para orquestador/workflows MVP
# Si defines estos, tienen prioridad sobre el AutoParse
$env:FRONTEND_TECH = "react-vite"   # opciones: react-vite | nextjs | sveltekit | angular
$env:BACKEND_TECH  = "fastify"      # opciones: fastify | express | nest | hono | fastapi
$env:UI_LIBS       = "tailwind+shadcn" # opciones: tailwind+shadcn | tailwind | none
$env:DB            = "neon-postgres"   # opciones: neon-postgres | sqlite | mongodb
$env:TARGET_DIR    = ""             # opcional, e.g. apps/front o apps/back

# Solicitud libre (opcional si usas REQUEST.txt)
$env:MVP_REQUEST   = ""  # Descripción en lenguaje natural del MVP
