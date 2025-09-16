import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  timeout: 15000,
})

api.interceptors.response.use(
  (res) => res,
  (err) => {
    // Basic error passthrough for now
    return Promise.reject(err)
  }
)

export default api
