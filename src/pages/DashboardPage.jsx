import React from 'react'
import { useAuth } from '@/state/authSlice'

export default function DashboardPage() {
  const { user, logout } = useAuth()

  return (
    <main style={{ padding: 24 }}>
      <h1>Dashboard</h1>
      <p>Welcome {user?.userId || 'User'}!</p>
      <button onClick={logout}>Logout</button>
    </main>
  )
}
