import { create } from 'zustand'
import { createAuthSlice } from '@/state/authSlice'

export const useAppStore = create((set, get, api) => ({
  ...createAuthSlice(set, get, api),
}))
