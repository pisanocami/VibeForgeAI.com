import React from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { useAuth } from '@/state/authSlice'

export default function Protected({ children }) {
  const location = useLocation()
  const { isAuthenticated } = useAuth()

  if (!isAuthenticated) {
    return <Navigate to="/login" replace state={{ from: location }} />
  }

  return children
}
