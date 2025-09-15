// Simple theme mapping using CSS variables
export const theme = {
  colors: {
    primary: "var(--color-primary)",
    secondary: "var(--color-secondary)",
    accent: "var(--color-accent)",
    success: "var(--color-success)",
    warning: "var(--color-warning)",
    danger: "var(--color-danger)",
    neutral: {
      50: "var(--color-neutral-50)",
      100: "var(--color-neutral-100)",
      200: "var(--color-neutral-200)",
      300: "var(--color-neutral-300)",
      400: "var(--color-neutral-400)",
      500: "var(--color-neutral-500)",
      600: "var(--color-neutral-600)",
      700: "var(--color-neutral-700)",
      800: "var(--color-neutral-800)",
      900: "var(--color-neutral-900)",
    },
  },
  fonts: {
    primary: "var(--font-primary)",
    secondary: "var(--font-secondary)",
  },
  radius: {
    sm: "var(--radius-sm)",
    md: "var(--radius-md)",
    lg: "var(--radius-lg)",
    xl: "var(--radius-xl)",
    full: "var(--radius-full)",
  },
  shadow: {
    sm: "var(--shadow-sm)",
    md: "var(--shadow-md)",
    lg: "var(--shadow-lg)",
    xl: "var(--shadow-xl)",
  },
};

export default theme;