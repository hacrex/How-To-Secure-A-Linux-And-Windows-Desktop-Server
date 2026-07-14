# Contributing to How To Secure A Linux & Windows Server

Thank you for your interest in contributing to this repository! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Pull Request Process](#pull-request-process)
- [Style Guidelines](#style-guidelines)
- [Adding New Content](#adding-new-content)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## Code of Conduct

Please be respectful and constructive in all interactions. We welcome contributions from everyone regardless of experience level, background, or identity.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

- Use a clear and descriptive title
- Describe the exact steps to reproduce the problem
- Provide specific examples to demonstrate the steps
- Describe the behavior you observed and what behavior you expected
- Include any relevant logs, screenshots, or configuration files

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- Use a clear and descriptive title
- Provide a detailed description of the suggested enhancement
- Explain why this enhancement would be useful
- List any similar enhancements if they exist

### Pull Requests

The process described here has several goals:

- Maintain the quality of the repository
- Fix problems that are important to users
- Enable a sustainable system for maintainers to review contributions

## Pull Request Process

1. Fork the repository and create your branch from `main`
2. If you've added code that should be tested, add tests
3. If you've changed APIs, update the documentation
4. Ensure the test suite passes
5. Make sure your code follows the style guidelines (see below)
6. Submit the pull request with a clear description of changes

### Pull Request Guidelines

- Fill in the required template
- Do not include issue numbers in the PR title
- Include screenshots and animated GIFs in your pull request whenever possible
- Follow the style guidelines
- End all files with a newline

## Style Guidelines

### Markdown Files

- Use ATX-style headers (`# Header`) rather than setext-style headers
- Use bullet points with `-` rather than `*`
- Keep line length under 100 characters where possible
- Use relative links for internal references
- Include a table of contents for longer documents

### File Naming

- Use lowercase with hyphens for file names (e.g., `security-best-practices.md`)
- Prefix numbered files with two-digit numbers (e.g., `01-initial-setup.md`)
- Use descriptive names that reflect the content

### Content Guidelines

- Write in clear, concise English
- Use active voice when possible
- Include practical examples and commands
- Provide references and sources for claims
- Test all commands and scripts before submitting

## Adding New Content

When adding new security guides or sections:

1. Create the file in the appropriate directory
2. Follow the existing file naming conventions
3. Include a clear introduction and table of contents
4. Add practical examples and verification steps
5. Include references to authoritative sources
6. Update the parent directory's README.md to include your new file
7. Update the main README.md if adding a new section

### Directory Structure

```
/workspace
├── Linux/                    # Linux-specific security guides
├── Windows/                  # Windows-specific security guides
├── Cloud-Security/           # Cloud provider security (AWS, Azure, GCP)
├── Automation/               # Ansible playbooks and PowerShell scripts
│   ├── Linux/
│   └── Windows/
├── Documentation/            # Additional documentation and diagrams
│   ├── Automation/
│   └── Diagrams/
├── Best-Practices/           # General security best practices
├── Threat-Modeling/          # Threat modeling examples
├── Monitoring-and-Logging/   # Monitoring and logging guides
├── Incident-Response/        # Incident response playbooks
└── Advanced/                 # Advanced topics (containers, Kubernetes, etc.)
```

## Verification Steps

Before submitting your contribution:

1. **Check links**: Ensure all hyperlinks are valid and accessible
2. **Test commands**: Verify all commands work on target systems
3. **Validate markdown**: Use a markdown linter to check formatting
4. **Review for duplicates**: Ensure content doesn't duplicate existing guides
5. **Update documentation**: Update relevant README files and tables of contents

## Questions?

Feel free to open an issue if you have any questions about contributing. We're happy to help!

## License

By contributing to this repository, you agree that your contributions will be licensed under the MIT License.
