import './App.css'
import { useState, useEffect } from 'react'
import { theme } from './theme.js'

export default function App() {
  const [isDarkMode, setIsDarkMode] = useState(true);

  useEffect(() => {
    document.body.className = isDarkMode ? 'dark-mode' : 'light-mode';
  }, [isDarkMode]);

  return (
    <main>
      <div className="hello-world-container">
        <h1 className="hello-title">Hello World</h1>
        <p className="hello-subtitle">
          VibeForge AI Coding with AI
        </p>
        <button className="demo-button" onClick={() => setIsDarkMode(!isDarkMode)}>
          {isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode'}
        </button>
      </div>
    </main>
  )
}
