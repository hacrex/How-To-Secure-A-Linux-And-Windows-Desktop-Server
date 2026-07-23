# 06 - Supply Chain Security

Supply chain attacks target the tools, libraries, and processes used to build and deploy software, rather than the software itself. These attacks have become one of the most damaging threat vectors (SolarWinds, Log4Shell, xz-utils backdoor).

## 1. Understanding Supply Chain Threats

| Threat | Description | Example |
|--------|-------------|---------|
| Dependency confusion | Attacker publishes malicious package with same name as internal package to public registry | npm dependency confusion |
| Typosquatting | Malicious package with name similar to popular package | `colourama` vs `colorama` |
| Compromised maintainer | Trusted maintainer account hijacked, malicious code pushed | ua-parser-js |
| Malicious dependency update | Legitimate package updated with malicious code | event-stream |
| Build system compromise | CI/CD pipeline or build server compromised | SolarWinds |
| Backdoored library | Malicious code injected into open-source library | xz-utils backdoor |
| Dependency chain | Transitive dependency introduces vulnerability | Log4Shell (log4j) |

## 2. Software Bill of Materials (SBOM)

An SBOM is a formal record of components, libraries, and modules used in a software project. It enables vulnerability tracking and license compliance.

### Generate SBOMs

```bash
# Using Syft (recommended)
syft dir:. -o spdx-json > sbom.spdx.json
syft dir:. -o cyclonedx-json > sbom.cyclonedx.json

# Using CycloneDX (npm)
npm install -g @cyclonedx/cyclonedx-npm
cyclonedx-npm --output-file sbom.json

# Using CycloneDX (Python)
pip install cyclonedx-bom
cyclonedx-py environment --output-file sbom.json

# Using Trivy (includes SBOM)
trivy fs --format cyclonedx --output sbom.json .
```

### Verify Dependencies

```bash
# Check for known vulnerabilities in SBOM
trivy sbom sbom.json --severity HIGH,CRITICAL

# Scan npm dependencies
npm audit
npm audit --omit=dev  # production only

# Scan Python dependencies
pip-audit

# Scan Go dependencies
govulncheck ./...
```

## 3. Dependency Security

### Pin Versions

Always use exact version pins or lock files. Never use floating versions (`*`, `latest`, `>=`).

```bash
# npm — always commit package-lock.json
npm ci  # Clean install from lock file (never npm install in CI)

# Python — use pinned requirements
pip install -r requirements.txt  # Generated with pip freeze
pip install -r requirements.txt --require-hashes  # Verify checksums

# Go — go.sum is committed
go mod verify  # Verify module checksums
```

### Verify Package Integrity

```bash
# npm — verify package checksums
npm pack --dry-run  # Verify package contents

# Python — verify GPG signatures
pip install --require-hashes -r requirements.txt

# Container images — verify signatures
cosign verify --key cosign.pub ghcr.io/org/image:tag
```

### Use Private Registries

```bash
# npm — use private registry for internal packages
# .npmrc
registry=https://registry.npmjs.org/
@mycompany:registry=https://npm.mycompany.com/

# Python — use private PyPI
pip install --index-url https://pypi.mycompany.com/simple/ package
```

## 4. Container Image Security

```bash
# Scan images for vulnerabilities
trivy image myapp:latest --severity HIGH,CRITICAL

# Sign images with Cosign
cosign sign --key cosign.key ghcr.io/org/image:tag

# Verify image signatures
cosign verify --key cosign.pub ghcr.io/org/image:tag

# Use minimal base images
# Good: alpine, distroless, scratch
# Avoid: ubuntu, debian (large attack surface)

# Pin image digests (not tags)
# Use: myapp@sha256:abc123...
# Not: myapp:latest
```

## 5. CI/CD Pipeline Security

| Control | Implementation |
|---------|---------------|
| Pin action versions | Use commit SHA, not tags (e.g., `actions/checkout@abc123`) |
| Audit workflow permissions | Use `permissions:` to restrict GITHUB_TOKEN scope |
| Scan before build | Run SAST/SCA in PR checks |
| Sign build artifacts | Use Sigstore/Cosign to sign releases |
| Isolate build environments | Use ephemeral runners, don't reuse build agents |
| Restrict push access | Require PR reviews for main branch |
| Verify provenance | Generate SLSA provenance attestations |

### GitHub Actions Hardening

```yaml
# Pin actions to commit SHA
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1

# Restrict permissions
permissions:
  contents: read
  packages: write

# Use OIDC for cloud authentication (no long-lived secrets)
- uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::123456789:role/deploy
    aws-region: us-east-1
```

## 6. SLSA (Supply-chain Levels for Software Artifacts)

SLSA is a framework for ensuring the integrity of software artifacts throughout the supply chain.

| Level | Description | Key Controls |
|-------|-------------|-------------|
| SLSA 1 | Documented build process | Build script exists, hosted platform |
| SLSA 2 | Hardened build platform | Hosted build service, signed provenance |
| SLSA 3 | Hardened + auditable | Non-fresh build, isolated build, verified source |
| SLSA 4 | Hermetic + reproducible | Fully hermetic build, two-party review |

### Generate SLSA Provenance

```bash
# Using slsa-verifier
slsa-verifier verify-artifact artifact.txt \
  --provenance-path provenance.json \
  --source-uri github.com/org/repo
```

## 7. Open Source Security

| Practice | Tool/Method |
|----------|-------------|
| License compliance | `license-checker`, FOSSA, Snyk |
| Vulnerability monitoring | Dependabot, Renovate, Snyk |
| Malware scanning | Socket.dev, npm audit |
| Maintainer reputation | Check maintainer history, download counts |
| Dependency review | `gh dependency-review` (GitHub) |

```bash
# Enable Dependabot (GitHub)
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
```

## 8. Incident Response for Supply Chain Attacks

If you suspect a supply chain compromise:

1. **Isolate** — Take affected systems offline immediately
2. **Identify** — Determine which versions/commits are affected
3. **Verify** — Check SBOMs, lock files, and dependency trees
4. **Rollback** — Revert to last known-good version
5. **Rotate** — Rotate all secrets, tokens, and keys that may have been exposed
6. **Scan** — Run full vulnerability scan across all systems
7. **Notify** — Inform customers, partners, and regulators if data was affected
8. **Document** — Record lessons learned, update controls

## 9. Quick Checklist

- [ ] SBOM generated and stored for all projects
- [ ] Dependencies pinned with lock files
- [ ] Vulnerability scanning in CI/CD pipeline
- [ ] Container images signed and verified
- [ ] GitHub Actions pinned to commit SHA
- [ ] Dependabot/Renovate enabled for automated updates
- [ ] Private registry used for internal packages
- [ ] Build provenance generated (SLSA level 2+)
- [ ] License compliance checked
- [ ] Incident response plan covers supply chain scenarios

## 10. References

*   [SLSA Framework](https://slsa.dev/)
*   [OWASP Software Component Verification Standard](https://scvs.owasp.org/)
*   [NIST SP 800-161 - Supply Chain Risk Management](https://csrc.nist.gov/publications/detail/sp/800-161/rev-1/final)
*   [OpenSSF Best Practices](https://www.bestpractices.dev/)
*   [GitHub Supply Chain Security](https://docs.github.com/en/code-security/supply-chain-security)
