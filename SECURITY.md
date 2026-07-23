# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this repository, please report it responsibly. **Do not open a public GitHub issue for security vulnerabilities.**

### How to Report

1. **Email**: Send details to the repository maintainers
2. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Acknowledgment**: We will acknowledge receipt within 48 hours
- **Assessment**: We will evaluate the report and determine severity
- **Resolution**: We will work on a fix and coordinate disclosure
- **Credit**: With your permission, we will credit you in the release notes

## Scope

This security policy covers:

- Vulnerabilities in automation scripts (Ansible playbooks, PowerShell scripts)
- Incorrect security configurations in documentation that could lead to insecure deployments
- Supply chain issues in recommended tools or packages

## Out of Scope

- Vulnerabilities in third-party tools referenced in documentation
- General security questions (please use GitHub Issues for those)

## Best Practices for Contributors

When contributing security-related content:

- **Never commit real credentials** - Use placeholder values in examples
- **Test all commands** - Verify commands work as documented before submitting
- **Reference authoritative sources** - Link to official documentation (CIS Benchmarks, vendor docs)
- **Consider edge cases** - Note when configurations may not apply to all environments
