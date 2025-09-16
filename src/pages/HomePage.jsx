import React from 'react'
import { Link } from 'react-router-dom'

export default function HomePage() {
  return (
    <main style={{ padding: 24 }}>
      <h1>VibeForgeAI — Home</h1>
      <p>Welcome. Use the links below to navigate.</p>
      <nav style={{ display: 'grid', gap: 8, marginTop: 12 }}>
        <Link to="/login">Login</Link>
        <Link to="/register">Register</Link>
        <Link to="/dashboard">Dashboard</Link>
      </nav>
    </main>
  )
}
