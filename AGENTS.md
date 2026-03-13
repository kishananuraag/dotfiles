# AGENTS.md - Agent Coding Guidelines

This file provides guidelines for agentic coding agents operating in this repository.

## Build, Lint, and Test Commands

### Running the Project

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

### Linting and Type Checking

```bash
# Run linter
npm run lint

# Run type checker
npm run typecheck

# Run both lint and typecheck
npm run check
```

### Testing

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage

# Run a single test file
npm test -- path/to/testfile.test.ts

# Run a specific test by name
npm test -- --testNamePattern="test name"
```

## Code Style Guidelines

### General Principles

- Write clean, readable, and maintainable code
- Keep functions small and focused (single responsibility)
- Use meaningful variable and function names
- Avoid magic numbers - use constants
- Comment complex logic, not obvious code

### Imports

- Use absolute imports when possible (configure path aliases in tsconfig)
- Order imports: external libraries → internal modules → relative imports
- Group imports: React/framework → utilities → components → styles
- Use named exports for better tree-shaking and debugging

```typescript
// Good
import { useState, useEffect } from 'react'
import { formatDate } from '@/utils/date'
import { Button } from '@/components/Button'
import './Button.css'

// Avoid
import * as React from 'react'
import { Button } from '../components/Button'
```

### Formatting

- Use 2 spaces for indentation (or 4 - match project convention)
- Use single quotes for strings (unless avoiding escaping)
- Add trailing commas in multiline objects/arrays
- Use semicolons consistently
- Maximum line length: 100 characters

### TypeScript

- Always define types for function parameters and return values
- Use interfaces for object shapes, types for unions/intersections
- Avoid `any` - use `unknown` when type is truly unknown
- Use `as` type assertions only when absolutely necessary
- Enable strict mode in tsconfig

```typescript
// Good
interface User {
  id: string
  name: string
  email: string
}

function getUser(id: string): Promise<User> {
  // ...
}

// Avoid
function getUser(id: any): any {
  // ...
}
```

### Naming Conventions

- **Files**: kebab-case for utilities, PascalCase for components, camelCase for hooks
- **Variables/functions**: camelCase
- **Constants**: SCREAMING_SNAKE_CASE
- **Components/Classes**: PascalCase
- **Hooks**: camelCase starting with `use`
- **Booleans**: Use prefixes like `is`, `has`, `should`, `can`

```typescript
// Variables
const userName = 'John'
const isActive = true
const hasPermission = false

// Functions
function calculateTotal(items: Item[]): number
function isUserValid(user: User): boolean

// Constants
const MAX_RETRY_COUNT = 3
const API_BASE_URL = '/api/v1'
```

### React/Component Guidelines

- Use functional components with hooks
- Keep components small (under 200 lines)
- Extract reusable logic into custom hooks
- Use Composition over Inheritance
- Memoize expensive computations with `useMemo`/`useCallback`
- colortize list items with unique keys

```typescript
// Good component structure
export function UserCard({ user, onSelect }: UserCardProps) {
  const [isExpanded, setIsExpanded] = useState(false)
  
  const handleClick = useCallback(() => {
    onSelect(user.id)
  }, [user.id, onSelect])
  
  return (
    <div className="user-card">
      <h3>{user.name}</h3>
      {/* ... */}
    </div>
  )
}
```

### Error Handling

- Always handle async errors with try/catch
- Use custom error classes for domain-specific errors
- Log errors appropriately (console.error in development, error tracking service in prod)
- Never expose sensitive information in error messages
- Provide user-friendly error messages

```typescript
// Good
try {
  const data = await fetchUser(id)
  return data
} catch (error) {
  if (error instanceof NetworkError) {
    return fallbackData
  }
  console.error('Failed to fetch user:', error)
  throw new UserFriendlyError('Unable to load user. Please try again.')
}
```

### Git Conventions

- Use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`
- Keep commits atomic and focused
- Write meaningful commit messages
- Reference issue numbers in commit body

## Testing Guidelines

### Test Structure

- Follow AAA pattern: Arrange, Act, Assert
- Test behavior, not implementation
- Use descriptive test names
- One expectation per test when possible

```typescript
describe('calculateTotal', () => {
  it('should return 0 for empty array', () => {
    const result = calculateTotal([])
    expect(result).toBe(0)
  })
  
  it('should sum all item prices', () => {
    const items = [{ price: 10 }, { price: 20 }]
    const result = calculateTotal(items)
    expect(result).toBe(30)
  })
})
```

### Test Coverage

- Aim for high coverage on business logic
- Test edge cases and error paths
- Mock external dependencies (API calls, file system, etc.)
- Use integration tests for critical user flows

## File Organization

```
src/
├── components/     # Reusable UI components
├── hooks/          # Custom React hooks
├── utils/          # Utility functions
├── services/       # API and external services
├── types/          # TypeScript type definitions
├── constants/      # Application constants
└── pages/          # Page components
```

## Environment Variables

- Never commit secrets to version control
- Use `.env.local` for local development
- Document required environment variables in `.env.example`
- Prefix custom variables with `VITE_` for Vite projects

## Performance Guidelines

- Lazy load routes and heavy components
- Optimize images (use WebP, appropriate sizes)
- Avoid unnecessary re-renders
- Use virtualization for long lists
- Monitor bundle size

## Security

- Sanitize user inputs
- Use parameterized queries for database operations
- Implement proper authentication/authorization
- Keep dependencies updated
- Never log sensitive data
