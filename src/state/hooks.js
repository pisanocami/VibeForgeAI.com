import { useAppStore } from '@/state/store'

export const useAuth = () =>
  useAppStore((s) => ({
    isAuthenticated: s.isAuthenticated,
    user: s.user,
    login: s.login,
    logout: s.logout,
  }))
