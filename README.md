# FinTechBankX Enterprise Architecture

This repository is the enterprise architecture source of truth for FinTechBankX. It is aligned to the Spotify model at the governance layer: each repo has one primary tribe, one primary squad, one bounded context, and one accountable review cadence.

## Sorumluluk ve Sahiplik

| Layer | Responsibility |
| --- | --- |
| Architecture & Governance Tribe | Owns the transformation portfolio, priorities, and cross-repo tradeoffs. |
| Architecture Enablement Squad | Owns the repository-level strategy, backlog alignment, and execution governance for this repo. |
| Domain Squads | Own their bounded-context repositories, code, contracts, tests, and release readiness. |
| Platform Squads | Own shared platform repos for identity, mesh, eventing, observability, delivery, and IaC. |
| Governance Guilds | Own contract standards, naming conventions, and policy guardrails. |

## Scope

This repository contains:
- Target-state architecture and transformation strategy
- Capability maps and service catalogues
- Technical debt analysis and remediation plans
- Security architecture and service-mesh blueprints
- Governance, ADR/runbook references, and implementation standards
- Repository naming, ownership, and execution guidance for the Spotify-aligned model

## Dokümantasyon ve Referanslar

- [Repo Naming & Ownership Strategy](docs/enterprisearchitecture/implementation-development/transformation/SPOTIFY_TRIBE_SQUAD_REPOSITORY_STRATEGY.md)
- [Microservices Transformation Plan](docs/enterprisearchitecture/implementation-development/MICROSERVICES_TRANSFORMATION_PLAN.md)
- [Microservices Transformation Task List](docs/enterprisearchitecture/implementation-development/MICROSERVICES_TRANSFORMATION_TASK_LIST.md)
- [Secure Microservices Architecture](docs/architecture/overview/SECURE_MICROSERVICES_ARCHITECTURE.md)
- [Execution Status and Next Steps](docs/enterprisearchitecture/project-management/EXECUTION_STATUS_AND_NEXT_STEPS.md)
- [Service Data Ownership Matrix](docs/enterprisearchitecture/implementation-development/SERVICE_DATA_OWNERSHIP_MATRIX.md)
- [Service API Contracts Index](docs/enterprisearchitecture/implementation-development/SERVICE_API_CONTRACTS_INDEX.md)

## Structure

- `docs/architecture/overview`: architecture catalogue and secure architecture references
- `docs/enterprisearchitecture`: implementation plans, checklists, transformation outputs, and project tracking
- `docs/puml`: system, security, and service-mesh PlantUML sources

## Publication Guardrails

- No local-machine absolute paths in committed docs
- No personal identifiers in architecture/test artifacts
- No secret material in source-controlled content
- Use environment placeholders for operational paths and credentials
- Do not weaken ownership or contract controls without an ADR and explicit review approval

## Cell-Based Architecture

This repository participates in the FinTechBankX cell-based resilience program.

- Plan: \
- Backlog: \

<!-- cell-architecture-start -->
## Cell-Based Architecture

This repository participates in the FinTechBankX cell-based resilience program.

- Plan: docs/architecture/CELL_BASED_ARCHITECTURE_IMPLEMENTATION_PLAN.md
- Backlog: docs/project-management/CELL_ARCHITECTURE_BACKLOG_BOARD.md
<!-- cell-architecture-end -->
