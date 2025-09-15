import './App.css'
import { theme } from './theme.js'

export default function App() {
  return (
    <main>
      <div className="hello-world-container">
        <h1 className="hello-title">¡Hola Mundo!</h1>
        <p className="hello-subtitle">
          Sistema de Temas usando CSS Variables
        </p>
        
        <div className="theme-showcase">
          <div className="color-box color-primary">
            Primary
          </div>
          <div className="color-box color-secondary">
            Secondary
          </div>
          <div className="color-box color-accent">
            Success
          </div>
          <div className="color-box color-warning">
            Warning
          </div>
          <div className="color-box color-danger">
            Danger
          </div>
        </div>
        
        <button 
          className="demo-button"
          onClick={() => {
            console.log('Theme object:', theme);
            alert(`Los colores del tema están disponibles:\n• Primary: ${theme.colors.primary}\n• Secondary: ${theme.colors.secondary}\n• Accent: ${theme.colors.accent}`);
          }}
        >
          Ver Tema en Consola
        </button>
        
        <div className="tech-info">
          React ⚛️ + Vite ⚡ + Replit! + Sistema de Temas 🎨
        </div>
      </div>
    </main>
  )
}
