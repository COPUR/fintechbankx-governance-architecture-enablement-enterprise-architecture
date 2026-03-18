# Spotify Tribe, Squad, and Repository Strategy

## Purpose

This document defines the canonical strategy for the Spotify-aligned repository split. It is the public-facing alias for the repo naming and ownership model.
It is the source of truth for:

1. Repository naming
2. Repo ownership
3. Tribe and squad mapping
4. Review cadence and accountability
5. Repository-level operating rules

The intent is to make repo creation deterministic and auditable before code is extracted.

## Design Goals

1. One repository maps to one bounded context or one platform capability.
2. One primary squad owns one repository.
3. Tribes provide portfolio direction and prioritization.
4. Guilds and boards provide standards, control points, and exception handling.
5. Naming must be consistent enough for automation, branch protection, and CODEOWNERS generation.

## Canonical Naming Model

### Runtime repositories

Use this pattern for deployable service repos:

`fintechbankx-<domain>-<capability>-service`

Examples:

1. `fintechbankx-openfinance-consent-authorization-service`
2. `fintechbankx-payments-initiation-settlement-service`
3. `fintechbankx-customer-profile-kyc-service`

### Platform repositories

Use this pattern for shared runtime and delivery capabilities:

`fintechbankx-platform-<capability>`

Examples:

1. `fintechbankx-platform-identity-keycloak-ldap`
2. `fintechbankx-platform-service-mesh-security`
3. `fintechbankx-platform-event-streaming`
4. `fintechbankx-platform-observability-sre`
5. `fintechbankx-platform-delivery-templates`
6. `fintechbankx-platform-terraform-modules`

### Contract repositories

Use this pattern for contract and registry repositories:

`fintechbankx-contracts-<capability>`

Examples:

1. `fintechbankx-contracts-openapi-catalog`
2. `fintechbankx-contracts-asyncapi-catalog`
3. `fintechbankx-contracts-schema-registry`

### Governance repositories

Use this pattern for enterprise governance and architecture control repos:

`fintechbankx-governance-<capability>`

Example:

1. `fintechbankx-governance-architecture-adr-runbooks`

## Ownership Model

### Responsibility tiers

1. **Tribe**
   - Owns the product or platform portfolio.
   - Sets roadmap priorities and major dependency decisions.
   - Resolves cross-squad conflicts.

2. **Squad**
   - Owns the repo, backlog, and delivery cadence.
   - Maintains repository standards, docs, tests, and release readiness.
   - Serves as the primary review and change control group.

3. **Guild / Board**
   - Owns technical standards, guardrails, and exception handling.
   - Approves shared patterns, controls, and architectural policy.
   - Does not own routine feature delivery.

### Ownership rules

1. Every repo must have exactly one primary owning squad.
2. Every repo must have exactly one primary tribe or governance home.
3. Every repo must declare one data owner for its schema or storage boundary.
4. Every repo must declare its published and consumed event contracts.
5. Every repo must have a review cadence in `README` and `CODEOWNERS`.
6. Platform, contract, and governance repos still follow the same ownership discipline.

## Tribe and Squad Map

### Open Finance Tribe

| Squad | Primary Repo(s) | Scope | Primary Responsibility |
| --- | --- | --- | --- |
| Consent and Authorization Squad | `fintechbankx-openfinance-consent-authorization-service` | Consent lifecycle and authorization | Consent policy, OAuth/FAPI behavior, and authorization flows |
| Retail Financial Data Squad | `fintechbankx-openfinance-personal-financial-data-service` | Personal financial data aggregation | Account and transaction read models |
| Corporate Financial Data Squad | `fintechbankx-openfinance-business-financial-data-service` | Business financial data aggregation | Business account and liquidity read models |
| Payee and Metadata Squad | `fintechbankx-openfinance-payee-verification-service`, `fintechbankx-openfinance-banking-metadata-service` | Payee verification and bank metadata | Confirmation of payee and metadata enrichment |
| Open Data Squad | `fintechbankx-openfinance-open-products-catalog-service`, `fintechbankx-openfinance-atm-directory-service` | Public product and ATM data | Published catalog and directory data |

### Lending and Money Movement Tribe

| Squad | Primary Repo(s) | Scope | Primary Responsibility |
| --- | --- | --- | --- |
| Loan Lifecycle Squad | `fintechbankx-lending-loan-lifecycle-service` | Loan origination and servicing | Loan lifecycle, schedules, and servicing rules |
| Payment Orchestration Squad | `fintechbankx-payments-initiation-settlement-service` | Payment initiation and settlement | Payment orchestration, execution, and settlement |
| Recurring and Bulk Payments Squad | `fintechbankx-payments-recurring-mandates-service`, `fintechbankx-payments-bulk-orchestration-service`, `fintechbankx-payments-request-to-pay-service` | Mandates, bulk, and RtP | Recurring, file/bulk, and request-to-pay flows |
| Customer and KYC Squad | `fintechbankx-customer-profile-kyc-service` | Customer profile and onboarding | Customer profile, KYC, and identity intake |
| Risk and Compliance Decisioning Squad | `fintechbankx-risk-decisioning-service`, `fintechbankx-compliance-evidence-service` | Risk and compliance evidence | Decisioning, audit evidence, and control records |

### Platform and Reliability Tribe

| Squad | Primary Repo(s) | Scope | Primary Responsibility |
| --- | --- | --- | --- |
| Identity Platform Squad | `fintechbankx-platform-identity-keycloak-ldap` | Identity services | Identity baseline, federation, and token policies |
| Mesh Security Squad | `fintechbankx-platform-service-mesh-security` | Service mesh security | Strict mTLS, authz policy, and network baseline |
| Event Platform Squad | `fintechbankx-platform-event-streaming` | Eventing platform | Kafka, schema governance, and async contract tooling |
| DevSecOps Enablement Squad | `fintechbankx-platform-delivery-templates` | Delivery templates | CI/CD templates, quality gates, and guardrails |
| Observability and SRE Squad | `fintechbankx-platform-observability-sre` | Observability baseline | Telemetry, SLOs, and incident response assets |
| Infrastructure and Data Platform Squad | `fintechbankx-platform-terraform-modules` | Infrastructure modules | Terraform module standards and reusable IaC |

### Governance and Contract Control

| Owner | Primary Repo(s) | Scope | Primary Responsibility |
| --- | --- | --- | --- |
| API Governance Guild | `fintechbankx-contracts-openapi-catalog`, `fintechbankx-contracts-asyncapi-catalog`, `fintechbankx-contracts-schema-registry` | Contract catalog and registry | API and event contract governance |
| Architecture Board | `fintechbankx-governance-architecture-adr-runbooks` | Governance and runbooks | ADRs, guardrails, exception handling, and runbooks |

## Repository Operating Rules

1. Repositories are created only after tribe and squad ownership are approved.
2. New repos must start with README, CODEOWNERS, ADR/runbook links, and pipeline bootstrap.
3. Ownership metadata must include `bounded_context`, `owning_squad`, `owning_tribe`, `data_owner`, `published_events`, and `consumed_events`.
4. Contracts are versioned independently of code and must be enforced by CI.
5. Domain repos must not depend on another domain repo's database or schema.
6. Shared platform repos may expose reusable infrastructure, but not domain logic.
7. Every repo must declare a review cadence and an escalation path for ownership disputes.

## Review Cadence

1. Domain repos: bi-weekly squad review plus monthly architecture review.
2. Platform repos: weekly platform review plus monthly architecture review.
3. Contract and governance repos: weekly governance review plus monthly architecture review.

## Change Control

1. Any repo naming exception requires Architecture Board approval.
2. Any ownership transfer requires tribe lead sign-off and CODEOWNERS update.
3. Any new capability that does not fit the canonical patterns must be normalized before repository creation.
4. Repository names are frozen once the repo is published externally or referenced by downstream automation.

## Outcome

Following this strategy keeps repo names predictable, prevents ownership drift, and gives automation a stable contract for creating repos, branch protections, CODEOWNERS, and backlog records.
