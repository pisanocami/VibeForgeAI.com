import React from 'react'
import { Link } from 'react-router-dom'

export default function RegisterPage() {
  return (
    <main style={{ padding: 24 }}>
      <h1>Register</h1>
      <p>Registration flow is coming soon.</p>
      <p>
        Already have an account? <Link to="/login">Login</Link>
      </p>
    </main>
  )
}
