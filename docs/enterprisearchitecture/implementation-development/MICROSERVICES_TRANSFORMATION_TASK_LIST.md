# Microservices Transformation Task List

## Purpose

This task list turns the Spotify-aligned repo strategy into executable work items. Each item is written to preserve clear ownership, traceability, and repository boundaries.

## Workstream A: Governance And Naming

| Task | Primary Owner | Output | Done When |
| --- | --- | --- | --- |
| Publish the repo naming and ownership strategy | Architecture Enablement Squad | Strategy doc | The repo naming, tribe, squad, and governance model is documented and linked from the root README. |
| Standardize the ubiquitous language for owners | Architecture Enablement Squad | Glossary section | `Primary Owner`, `Owning Tribe`, `Owning Squad`, and `Owning Guild` are used consistently in backlog and execution docs. |
| Define CODEOWNERS and ownership blocks | Architecture Enablement Squad | CODEOWNERS template | Every target repo can inherit the same ownership metadata pattern. |
| Record review cadence rules | Architecture Board | Review policy | Domain repos, platform repos, and governance repos each have a defined review cadence. |

## Workstream B: Platform Baseline

| Task | Primary Owner | Output | Done When |
| --- | --- | --- | --- |
| Bootstrap identity repo | Identity Platform Squad | `fintechbankx-platform-identity-iam-keycloak-ldap` | Repo contains README, ownership block, CI template, and initial ADR link. |
| Bootstrap mesh security repo | Mesh Security Squad | `fintechbankx-platform-mesh-security-service-mesh` | Repo contains policy baseline and mesh guardrail documentation. |
| Bootstrap event streaming repo | Event Platform Squad | `fintechbankx-platform-event-streaming-kafka` | Repo contains AsyncAPI, schema governance, and event naming rules. |
| Bootstrap observability repo | Observability and SRE Squad | `fintechbankx-platform-observability-sre-operations` | Repo contains telemetry baseline, dashboards, and alerting guidance. |
| Bootstrap delivery templates repo | DevSecOps Enablement Squad | `fintechbankx-platform-delivery-iac-cicd-templates` | Repo contains reusable CI templates and publication-safe release gates. |
| Bootstrap Terraform modules repo | Infrastructure and Data Platform Squad | `fintechbankx-platform-delivery-iac-terraform-modules` | Repo contains reusable IaC modules with ownership and versioning rules. |

## Workstream C: Open Finance Repo Split

| Task | Primary Owner | Output | Done When |
| --- | --- | --- | --- |
| Split consent and personal data repos | Consent and Authorization Squad, Retail Financial Data Squad | Consent and retail financial data repos | Repo boundaries match one bounded context per repo and each repo has a named data owner. |
| Split corporate data and payee/metadata repos | Corporate Financial Data Squad, Payee and Metadata Squad | Corporate data and payee/metadata repos | Repo ownership blocks and event contracts are aligned to the new repo names. |
| Split open data repos | Open Data Squad | Product catalog and ATM directory repos | Each repo has a README, CODEOWNERS, and contract inventory entry. |

## Workstream D: Lending And Payments Repo Split

| Task | Primary Owner | Output | Done When |
| --- | --- | --- | --- |
| Split loan lifecycle repo | Loan Lifecycle Squad | Loan repo | Loan state, schedule, and servicing ownership are explicitly documented. |
| Split payment initiation and settlement repo | Payment Orchestration Squad | Payment initiation repo | Payment orchestration and settlement contracts are mapped to the repo. |
| Split recurring, bulk, and request-to-pay repos | Recurring and Bulk Payments Squad | Three payment repos | Each payment capability has its own repository and ownership block. |

## Workstream E: Customer, Risk, And Compliance

| Task | Primary Owner | Output | Done When |
| --- | --- | --- | --- |
| Split customer profile and KYC repo | Customer and KYC Squad | Customer repo | Customer ownership, identity dependencies, and release cadence are documented. |
| Split risk repo | Risk and Compliance Decisioning Squad | Risk repo | Risk inputs and outputs are tied to explicit event contracts and data ownership. |
| Split compliance evidence repo | Risk and Compliance Decisioning Squad | Compliance repo | Audit evidence ownership and evidence lifecycle are described. |

## Workstream F: Contract And Governance Repos

| Task | Primary Owner | Output | Done When |
| --- | --- | --- | --- |
| Bootstrap OpenAPI catalog repo | API Governance Guild | OpenAPI catalog repo | OpenAPI lint, versioning, and compatibility checks are documented and enforceable. |
| Bootstrap AsyncAPI catalog repo | API Governance Guild | AsyncAPI catalog repo | AsyncAPI naming, topic structure, and schema versioning are documented. |
| Bootstrap schema registry repo | API Governance Guild | Schema registry repo | Schema lifecycle and compatibility policy are published. |
| Bootstrap architecture runbooks repo | Architecture Board | ADR and runbooks repo | Architecture decisions, guardrails, and exception handling are in one controlled repo. |

## Workstream G: Cutover And Governance

| Task | Primary Owner | Output | Done When |
| --- | --- | --- | --- |
| Publish execution status and next steps | Architecture Enablement Squad | Execution summary | Completed, In Progress, and Next actions are recorded in a dedicated project-management doc. |
| Normalize backlog language | Architecture Enablement Squad | Backlog docs | Legacy team-oriented language is replaced with Primary Owner terminology. |
| Validate publication guardrails | DevSecOps Enablement Squad | Guardrail checks | Docs contain no local paths, personal identifiers, or secret material. |

## Exit Criteria

1. Each target repo has a named owner and review cadence.
2. Each repo has a responsibility block, CODEOWNERS, and guardrail links.
3. Each doc uses the same ownership vocabulary.
4. The backlog can be executed without ambiguity about who owns what.
