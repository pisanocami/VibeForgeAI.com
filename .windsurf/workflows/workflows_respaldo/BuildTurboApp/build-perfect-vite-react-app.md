---
description: Build Perfect Vite + React App — Arquitectura primero, Auth con Neon, ejecutable end‑to‑end (Windows-friendly)
---

# Build Perfect Vite + React App (Arquitectura Primero, Auth con Neon)

Este workflow crea una aplicación completa con Vite + React + TypeScript priorizando arquitectura (rutas, páginas, componentes, estado) y dejando lista la integración de autenticación basada en Neon (PostgreSQL). Es reproducible en Windows y evita dependencias "mágicas".


## 0) Intake de Requerimientos (texto → arquitectura)

- Estructura clara a derivar de los requerimientos del usuario:
  - Dominio: entidades y relaciones (p. ej., Usuario, Proyecto, Tarea)
  - Páginas: paths, layout, protección (privadas/públicas)
  - Componentes: UI y features por página
  - Estado: slices globales y locales, persistencia
  - API: endpoints CRUD necesarios

Plantilla:
- Entidades: ...
- Páginas: ...
- Rutas: ...
- Componentes: ...
- Estado: ...
- Endpoints: ...


## 1) Scaffold del Proyecto

- Requisitos: Node 18+, npm

```powershell
# Windows PowerShell
npm create vite@latest app -- --template react-ts
cd app
npm i
```

Instalar dependencias base:
```powershell
npm i react-router-dom zod zustand axios
npm i -D @types/node @types/react @types/react-dom vite-tsconfig-paths
```

Opcionales de UI (recomendado):
```powershell
npm i clsx tailwind-merge
# Tailwind opcional (si se requiere utilidades CSS)
npm i -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

Configurar paths de TS (tsconfig.json):
```jsonc
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/app/*": ["src/app/*"],
      "@/pages/*": ["src/pages/*"],
      "@/components/*": ["src/components/*"],
      "@/features/*": ["src/features/*"],
      "@/lib/*": ["src/lib/*"],
      "@/state/*": ["src/state/*"]
    }
  }
}
```

Vite config con alias:
```ts
// vite.config.ts
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tsconfigPaths from 'vite-tsconfig-paths'

export default defineConfig({
  plugins: [react(), tsconfigPaths()],
})
```


## 2) Arquitectura de Carpetas (prioridad)

Estructura propuesta `src/`:
```
src/
  app/
    router.tsx
    providers.tsx
    layout.tsx
  pages/
    HomePage.tsx
    LoginPage.tsx
    RegisterPage.tsx
    DashboardPage.tsx
  components/
    ui/
      Button.tsx
      Input.tsx
      Card.tsx
    common/
      Navbar.tsx
      Protected.tsx
  features/
    auth/
      api.ts
      hooks.ts
      types.ts
    tasks/  (ejemplo de dominio)
      api.ts
      components/
      hooks.ts
  lib/
    api-client.ts
    neon.ts
    validation.ts
    jwt.ts
  state/
    store.ts
    authSlice.ts
```

Puntos clave:
- `app/router.tsx`: define rutas y protección.
- `components/common/Protected.tsx`: Higher-Order-Component/Wrapper para rutas privadas.
- `state/authSlice.ts`: estado y acciones de autenticación.


## 3) Routing con React Router

```tsx
// src/app/router.tsx
import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import HomePage from '@/pages/HomePage'
import LoginPage from '@/pages/LoginPage'
import RegisterPage from '@/pages/RegisterPage'
import DashboardPage from '@/pages/DashboardPage'
import Protected from '@/components/common/Protected'

const router = createBrowserRouter([
  { path: '/', element: <HomePage /> },
  { path: '/login', element: <LoginPage /> },
  { path: '/register', element: <RegisterPage /> },
  { path: '/dashboard', element: (
      <Protected>
        <DashboardPage />
      </Protected>
    )
  },
])

export default function AppRouter() {
  return <RouterProvider router={router} />
}
```

Montaje en `main.tsx`:
```tsx
// src/main.tsx
import React from 'react'
import ReactDOM from 'react-dom/client'
import AppRouter from '@/app/router'
import Providers from '@/app/providers'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <Providers>
      <AppRouter />
    </Providers>
  </React.StrictMode>
)
```


## 4) Estado Global con Zustand (auth primero)

```ts
// src/state/store.ts
import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface AuthState {
  token: string | null
  user: { id: string; email: string } | null
  login: (payload: { token: string; user: { id: string; email: string } }) => void
  logout: () => void
}

export const useAuth = create<AuthState>()(persist((set) => ({
  token: null,
  user: null,
  login: ({ token, user }) => set({ token, user }),
  logout: () => set({ token: null, user: null }),
}), { name: 'auth' }))
```

`Protected` para rutas privadas:
```tsx
// src/components/common/Protected.tsx
import { ReactNode } from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { useAuth } from '@/state/store'

export default function Protected({ children }: { children: ReactNode }) {
  const token = useAuth((s) => s.token)
  const location = useLocation()
  if (!token) return <Navigate to="/login" state={{ from: location }} replace />
  return <>{children}</>
}
```


## 5) Auth con Neon (backend ligero Fastify)

Nota: Vite no provee backend. Crearemos `server/` con Fastify + Neon para endpoints de auth (register/login/me). Base segura con Zod, bcrypt y JWT (jose).

```powershell
# En la carpeta del proyecto (app)
mkdir server
cd server
npm init -y
npm i fastify fastify-cors zod bcryptjs jose @neondatabase/serverless dotenv
npm i -D tsx typescript @types/bcryptjs @types/node
npx tsc --init
```

Estructura `server/`:
```
server/
  src/
    index.ts
    env.ts
    db.ts
    auth.ts
    routes/
      auth.ts
```

`env.ts` (cargar variables):
```ts
// server/src/env.ts
import 'dotenv/config'

export const ENV = {
  DATABASE_URL: process.env.DATABASE_URL!,
  JWT_SECRET: process.env.JWT_SECRET!,
  PORT: Number(process.env.PORT || 4000),
}
```

`db.ts` (cliente Neon):
```ts
// server/src/db.ts
import { neon } from '@neondatabase/serverless'
import { ENV } from './env'
export const sql = neon(ENV.DATABASE_URL)
```

`auth.ts` (helpers):
```ts
// server/src/auth.ts
import bcrypt from 'bcryptjs'
import * as jose from 'jose'
import { ENV } from './env'

export async function hashPassword(pw: string) {
  return bcrypt.hash(pw, 10)
}
export async function verifyPassword(pw: string, hash: string) {
  return bcrypt.compare(pw, hash)
}
export async function signJwt(payload: object) {
  const secret = new TextEncoder().encode(ENV.JWT_SECRET)
  return new jose.SignJWT(payload)
    .setProtectedHeader({ alg: 'HS256' })
    .setIssuedAt()
    .setExpirationTime('30d')
    .sign(secret)
}
export async function verifyJwt(token: string) {
  const secret = new TextEncoder().encode(ENV.JWT_SECRET)
  return jose.jwtVerify(token, secret)
}
```

Rutas de auth:
```ts
// server/src/routes/auth.ts
import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { sql } from '../db'
import { hashPassword, verifyPassword, signJwt } from '../auth'

const RegisterSchema = z.object({ email: z.string().email(), password: z.string().min(8) })
const LoginSchema = z.object({ email: z.string().email(), password: z.string().min(1) })

export async function authRoutes(app: FastifyInstance) {
  app.post('/register', async (req, reply) => {
    const body = RegisterSchema.parse(req.body)
    const existing = await sql`SELECT id FROM users WHERE email = ${body.email}`
    if (existing.length) return reply.code(409).send({ message: 'Email already registered' })
    const password_hash = await hashPassword(body.password)
    const rows = await sql`INSERT INTO users (email, password_hash) VALUES (${body.email}, ${password_hash}) RETURNING id, email`
    const user = rows[0]
    const token = await signJwt({ sub: user.id, email: user.email })
    return { token, user }
  })

  app.post('/login', async (req, reply) => {
    const body = LoginSchema.parse(req.body)
    const rows = await sql`SELECT id, email, password_hash FROM users WHERE email = ${body.email}`
    const user = rows[0]
    if (!user) return reply.code(401).send({ message: 'Invalid credentials' })
    const ok = await verifyPassword(body.password, user.password_hash)
    if (!ok) return reply.code(401).send({ message: 'Invalid credentials' })
    const token = await signJwt({ sub: user.id, email: user.email })
    return { token, user: { id: user.id, email: user.email } }
  })

  app.get('/me', async (req, reply) => {
    // Optional: parse Bearer token, verify and return user
    return { ok: true }
  })
}
```

Servidor:
```ts
// server/src/index.ts
import Fastify from 'fastify'
import cors from 'fastify-cors'
import { ENV } from './env'
import { authRoutes } from './routes/auth'

const app = Fastify({ logger: true })
app.register(cors, { origin: true })
app.register(authRoutes, { prefix: '/auth' })

app.listen(ENV.PORT, '0.0.0.0').then(() => {
  console.log(`API running on http://localhost:${ENV.PORT}`)
})
```

Scripts `server/package.json`:
```json
{
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "start": "node --env-file=.env dist/index.js"
  }
}
```

Base de datos (Neon): ejecutar una vez en tu Neon Project:
```sql
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email varchar(255) UNIQUE NOT NULL,
  password_hash varchar(255) NOT NULL,
  created_at timestamp DEFAULT now()
);
```

Variables de entorno (`server/.env`):
```
DATABASE_URL=postgres://... # de Neon
JWT_SECRET=tu-secreto-largo
PORT=4000
```


## 6) Frontend: integración de Auth

Cliente API:
```ts
// src/lib/api-client.ts
import axios from 'axios'

export const api = axios.create({ baseURL: 'http://localhost:4000' })
```

Feature Auth:
```ts
// src/features/auth/api.ts
import { api } from '@/lib/api-client'

export async function register(data: { email: string; password: string }) {
  const res = await api.post('/auth/register', data)
  return res.data as { token: string; user: { id: string; email: string } }
}
export async function login(data: { email: string; password: string }) {
  const res = await api.post('/auth/login', data)
  return res.data as { token: string; user: { id: string; email: string } }
}
```

Hook:
```ts
// src/features/auth/hooks.ts
import { useAuth } from '@/state/store'
import { login as loginApi, register as registerApi } from './api'

export function useAuthActions() {
  const loginState = useAuth((s) => s.login)
  const logoutState = useAuth((s) => s.logout)
  return {
    async login(email: string, password: string) {
      const { token, user } = await loginApi({ email, password })
      loginState({ token, user })
    },
    async register(email: string, password: string) {
      const { token, user } = await registerApi({ email, password })
      loginState({ token, user })
    },
    logout: logoutState,
  }
}
```

Páginas:
```tsx
// src/pages/LoginPage.tsx
import { useState } from 'react'
import { useAuthActions } from '@/features/auth/hooks'

export default function LoginPage() {
  const { login } = useAuthActions()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError(null)
    try {
      await login(email, password)
    } catch (err: any) {
      setError(err?.response?.data?.message || 'Error')
    } finally { setLoading(false) }
  }

  return (
    <form onSubmit={onSubmit}>
      <input value={email} onChange={(e) => setEmail(e.target.value)} placeholder="Email" />
      <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Password" />
      <button disabled={loading} type="submit">Login</button>
      {error && <p>{error}</p>}
    </form>
  )
}
```


## 7) Scripts de desarrollo

- Frontend:
```powershell
npm run dev
```
- Backend (en `server/`):
```powershell
npm run dev
```

Opcional: usar `concurrently` en raíz para levantar ambos a la vez.


## 8) Validación, Accesibilidad y UI

- Zod ya se usa en el backend; en frontend usar `zod` + `react-hook-form` si se desea.
- Componentes base accesibles en `components/ui/` (botón, input, card), estados de loading y error.


## 9) Testing (Vitest + RTL)

```powershell
npm i -D vitest @testing-library/react @testing-library/jest-dom jsdom
```

Ejemplo config `vite.config.ts` (testing):
```ts
// ...
export default defineConfig({
  plugins: [react(), tsconfigPaths()],
  test: {
    environment: 'jsdom',
    setupFiles: './src/test/setup.ts',
  },
})
```


## 10) CI/CD y Deploy

- Frontend: Vercel/Netlify sirven Vite build estático.
- Backend: desplegar `server/` en Render/Fly/Railway u otra plataforma con Node y variables de entorno (DATABASE_URL/JWT_SECRET).


## 11) Checklist Final

- Arquitectura y rutas creadas
- Páginas base (Home/Login/Register/Dashboard)
- Estado global auth con persistencia
- Backend Fastify con Neon (users, register, login)
- Validación Zod y hashing seguro
- JWT con `jose`
- Variables de entorno documentadas
- Scripts de desarrollo funcionando
- Tests mínimos configurados


## Apéndice: Migraciones (Opcional con Drizzle)

Si quieres migraciones reproducibles:
```powershell
# en server/
npm i drizzle-orm drizzle-kit
```
Configurar `drizzle.config.ts`, definir esquema y correr migraciones. (Sección opcional para mantener foco en arquitectura primero.)
