import React from 'react'
import { createBrowserRouter, RouterProvider, Navigate } from 'react-router-dom'
import HomePage from '@/pages/HomePage'
import LoginPage from '@/pages/LoginPage'
import RegisterPage from '@/pages/RegisterPage'
import DashboardPage from '@/pages/DashboardPage'
import Protected from '@/components/common/Protected'

const router = createBrowserRouter([
  { path: '/', element: <HomePage /> },
  { path: '/login', element: <LoginPage /> },
  { path: '/register', element: <RegisterPage /> },
  {
    path: '/dashboard',
    element: (
      <Protected>
        <DashboardPage />
      </Protected>
    ),
  },
  { path: '*', element: <Navigate to="/" replace /> },
])

export default function AppRouter() {
  return <RouterProvider router={router} />
}
