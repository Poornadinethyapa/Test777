# Contributing to Predict and Win

Thank you for your interest in contributing to Predict and Win! This document provides guidelines and instructions for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/predict-and-win.git`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Commit your changes: `git commit -m "Add your feature"`
6. Push to your fork: `git push origin feature/your-feature-name`
7. Create a Pull Request

## Development Setup

See the [README.md](README.md) for detailed setup instructions.

## Code Style

### Smart Contracts

- Follow the [Solidity Style Guide](https://docs.soliditylang.org/en/v0.8.19/style-guide.html)
- Use meaningful variable and function names
- Add NatSpec comments for all public functions
- Write comprehensive tests for all new features

### Frontend

- Follow the existing TypeScript and React patterns
- Use functional components with hooks
- Follow the existing file structure
- Add proper TypeScript types
- Use Tailwind CSS for styling

## Testing

### Smart Contracts

All new features must include tests:

```bash
cd contracts
forge test
```

### Frontend

Ensure the frontend builds without errors:

```bash
cd frontend
npm run lint
npm run build
```

## Pull Request Process

1. Ensure all tests pass
2. Update documentation if needed
3. Ensure your code follows the project's style guidelines
4. Provide a clear description of your changes
5. Reference any related issues

## Reporting Bugs

When reporting bugs, please include:

- A clear description of the bug
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Environment details (OS, browser, Node version, etc.)

## Feature Requests

When suggesting features:

- Provide a clear description of the feature
- Explain why it would be useful
- Consider implementation complexity
- Provide examples if possible

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect different viewpoints and experiences

Thank you for contributing!

