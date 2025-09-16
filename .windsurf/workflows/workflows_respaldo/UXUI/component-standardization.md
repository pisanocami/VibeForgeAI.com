---
description: UI Component Standardization Workflow
---

# UI Component Standardization

Workflow para crear y mantener una librería de componentes UI consistentes.

## 🎯 Objetivo
Crear componentes reutilizables que eliminen la inconsistencia entre páginas.

## 📋 Componentes Críticos a Crear

### 1. Layout Components
```typescript
// src/components/layout/PageLayout.tsx
interface PageLayoutProps {
  title: string;
  children: React.ReactNode;
  showNavigation?: boolean;
}

export const PageLayout = ({ title, children, showNavigation = true }: PageLayoutProps) => {
  return (
    <div className="min-h-screen bg-gray-50">
      {showNavigation && <Navigation />}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-8">{title}</h1>
        {children}
      </main>
    </div>
  );
};
```

### 2. Content Components
```typescript
// src/components/ui/ContentCard.tsx
interface ContentCardProps {
  title: string;
  description?: string;
  children: React.ReactNode;
  variant?: 'default' | 'featured' | 'compact';
}

export const ContentCard = ({ title, description, children, variant = 'default' }: ContentCardProps) => {
  const variants = {
    default: 'bg-white rounded-lg shadow-sm border p-6',
    featured: 'bg-gradient-to-r from-blue-50 to-indigo-50 rounded-lg shadow-md border-2 border-blue-200 p-8',
    compact: 'bg-white rounded-md shadow-sm p-4'
  };

  return (
    <div className={variants[variant]}>
      <h3 className="text-xl font-semibold text-gray-900 mb-2">{title}</h3>
      {description && <p className="text-gray-600 mb-4">{description}</p>}
      {children}
    </div>
  );
};
```

### 3. Navigation Components
```typescript
// src/components/ui/NavLink.tsx
interface NavLinkProps {
  to: string;
  children: React.ReactNode;
  isActive?: boolean;
}

export const NavLink = ({ to, children, isActive }: NavLinkProps) => {
  return (
    <Link
      to={to}
      className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
        isActive
          ? 'bg-blue-100 text-blue-700'
          : 'text-gray-700 hover:text-blue-600 hover:bg-gray-100'
      }`}
    >
      {children}
    </Link>
  );
};
```

### 4. Interactive Components
```typescript
// src/components/ui/ActionButton.tsx
interface ActionButtonProps {
  onClick: () => void;
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
}

export const ActionButton = ({ onClick, children, variant = 'primary', size = 'md', disabled }: ActionButtonProps) => {
  const baseClasses = 'inline-flex items-center justify-center rounded-md font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed';
  const variants = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500',
    secondary: 'bg-gray-600 text-white hover:bg-gray-700 focus:ring-gray-500',
    outline: 'border border-gray-300 bg-white text-gray-700 hover:bg-gray-50 focus:ring-blue-500'
  };
  const sizes = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg'
  };

  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`${baseClasses} ${variants[variant]} ${sizes[size]}`}
    >
      {children}
    </button>
  );
};
```

### 5. Data Display Components
```typescript
// src/components/ui/MetricCard.tsx
interface MetricCardProps {
  title: string;
  value: string | number;
  change?: string;
  icon?: React.ReactNode;
}

export const MetricCard = ({ title, value, change, icon }: MetricCardProps) => {
  return (
    <div className="bg-white rounded-lg shadow-sm border p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-gray-600">{title}</p>
          <p className="text-2xl font-bold text-gray-900">{value}</p>
          {change && (
            <p className={`text-sm ${change.startsWith('+') ? 'text-green-600' : 'text-red-600'}`}>
              {change}
            </p>
          )}
        </div>
        {icon && <div className="text-gray-400">{icon}</div>}
      </div>
    </div>
  );
};
```

## 🔄 Implementación por Página

### Strategic Consulting Page
```typescript
// src/pages/StrategicConsulting.tsx
import { PageLayout, ContentCard, ActionButton } from '../components/ui';

export const StrategicConsulting = () => {
  return (
    <PageLayout title="Strategic AI Transformation Consulting">
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <ContentCard title="AI Readiness Audit">
          <p>Comprehensive assessment of your AI maturity</p>
        </ContentCard>
        <ContentCard title="AI Strategy Workshop">
          <p>Collaborative strategy development session</p>
        </ContentCard>
        <ContentCard title="Full Transformation Program">
          <p>End-to-end AI implementation and scaling</p>
        </ContentCard>
      </div>
      <div className="mt-8">
        <ActionButton onClick={() => console.log('CTA clicked')}>
          Start Your AI Journey
        </ActionButton>
      </div>
    </PageLayout>
  );
};
```

### Talent Marketplace Page
```typescript
// src/pages/TalentMarketplace.tsx
import { PageLayout, ContentCard, MetricCard } from '../components/ui';

export const TalentMarketplace = () => {
  return (
    <PageLayout title="Elite AI Talent Marketplace">
      <div className="mb-8">
        <MetricCard title="AI Specialists Found" value="3" />
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Specialist cards using ContentCard */}
      </div>
    </PageLayout>
  );
};
```

## 📊 Beneficios
- ✅ Consistencia visual perfecta
- ✅ Mantenimiento más fácil
- ✅ Desarrollo más rápido
- ✅ Mejor experiencia de usuario
- ✅ Código más limpio y reutilizable

## 🚀 Próximos Pasos
1. Implementar componentes base
2. Refactorizar páginas existentes
3. Crear Storybook para documentación
4. Establecer guidelines de uso
