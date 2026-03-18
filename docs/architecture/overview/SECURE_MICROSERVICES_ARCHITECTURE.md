# Secure Microservices Architecture Baseline

## Purpose

This document defines the security architecture baseline for the Spotify-aligned microservices repository model. It connects the security controls to the ownership model so every repo has a clear accountability path.

## Ownership Model For Security

| Owner | Responsibility |
| --- | --- |
| Architecture Board | Approves exceptions, security policy, and architecture guardrails. |
| Platform and Reliability Tribe | Owns shared security platform controls such as identity, mesh, and observability. |
| Domain Squads | Own authn/authz behavior, contract alignment, secret hygiene, and repo-level security evidence. |
| API Governance Guild | Owns OpenAPI, AsyncAPI, schema rules, and contract lint gates. |
| DevSecOps Enablement Squad | Owns CI/CD policy enforcement, secret scanning, and repository guardrail templates. |

## Applicable Repositories

This baseline applies to:
- Open Finance service repositories
- Lending and payments service repositories
- Customer, risk, and compliance repositories
- Platform repositories for identity, mesh, eventing, observability, delivery, and IaC
- Contract and governance repositories

## Security Principles

1. Contract first: the API contract defines the security requirements as well as the routes.
2. Least privilege: scopes, audiences, and roles are explicit.
3. One repo, one owner: security responsibilities are not shared ambiguously across teams.
4. Evidence by default: guardrails are visible in docs, CODEOWNERS, and CI.
5. Defense in depth: edge, mesh, workload, and data layers each enforce controls.

## Control Planes

### Edge And Ingress
- TLS 1.2+ required.
- mTLS required for protected service-to-service traffic.
- WAF and rate limiting are enforced before routing.
- Request tracing and interaction IDs are normalized at ingress.

### Identity And Authorization
- A centralized identity provider handles authentication.
- OAuth2/OIDC tokens are validated by signature, issuer, audience, and expiry.
- Protected APIs require explicit scope checks.
- Sensitive flows use proof-of-possession or equivalent binding where required by policy.

### Service-To-Service
- Mesh policy enforces strict workload identity.
- Workloads are only allowed to talk to the repos and services documented in the architecture catalogue.
- Outbound calls to external systems must use approved adapters.

### Data Protection
- Data at rest must be encrypted.
- Secrets must be injected at runtime from an approved secret store.
- Logs must mask or redact identifiers, credentials, and personal data.

### Observability And Audit
- Every request must be traceable to a correlation ID.
- Security events must be auditable and searchable.
- Failed authn/authz attempts should be visible in telemetry and dashboards.

## Repository Security Baseline

Each repo must provide:
1. A README ownership block with tribe, squad, and review cadence.
2. A `CODEOWNERS` file or equivalent ownership mapping.
3. CI checks for secret scanning, document link validation, and path leakage.
4. Contract validation for OpenAPI or AsyncAPI assets where applicable.
5. Branch protection with required reviews and required checks.
6. Evidence of data ownership for every schema or storage boundary.

## Service Security Baseline

### Protected APIs
- JWT validation is mandatory.
- Scope checks are mandatory.
- DPoP or another approved proof-of-possession control is mandatory where the API exposes high-risk financial operations.
- Consent decisions must be enforceable at runtime.

### Public APIs
- Public endpoints may be tokenless only when the contract explicitly allows it.
- Even public endpoints must respect rate limits, telemetry, and response-shape contracts.

### Event-Driven Services
- Event topics and schemas are versioned.
- Event publishers must not leak personal data in payloads or headers.
- Consumers must handle unknown fields and backward-compatible evolution.

## Required CI Gates

1. Secret scan
2. Path leakage scan
3. README and doc link validation
4. OpenAPI or AsyncAPI lint
5. Coverage gate
6. Security dependency scan
7. Required review and branch protection checks

## Exception Handling

Any exception to this baseline must be recorded in an ADR and approved by the Architecture Board. Exceptions are time-boxed and must name:
- the repo
- the owner
- the control being waived
- the compensating control
- the expiry date

## Verification

A repo is considered compliant when:
- ownership metadata is present
- required CI checks are enabled
- security controls are documented and testable
- no local paths or personal identifiers appear in committed docs
