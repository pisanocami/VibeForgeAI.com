import React from 'react'
import { useAuth } from '@/state/hooks'
import { useNavigate, Link } from 'react-router-dom'

export default function LoginPage() {
  const navigate = useNavigate()
  const { isAuthenticated, login } = useAuth()

  const handleLogin = () => {
    login({ userId: 'demo' })
    navigate('/dashboard')
  }

  return (
    <main style={{ padding: 24 }}>
      <h1>Login</h1>
      {isAuthenticated ? (
        <p>You are already logged in. Go to <Link to="/dashboard">Dashboard</Link>.</p>
      ) : (
        <button onClick={handleLogin}>Login (Demo)</button>
      )}
    </main>
  )
}
