# FinTechBankX Enterprise Architecture

Enterprise architecture source-of-truth repository for FinTechBankX transformation and publication-safe artifacts.

## Scope

This repository contains:
- Target-state architecture and transformation strategy
- Capability maps and service catalogues
- Technical debt analysis and remediation plans
- Security architecture and service-mesh blueprints
- Governance, ADR/runbook references, and implementation standards

## Structure

- `docs/architecture/overview`: architecture catalogue and secure architecture references
- `docs/enterprisearchitecture`: implementation plans, checklists, transformation outputs, and project tracking
- `docs/puml`: system, security, and service-mesh PlantUML sources

## Key References

- [Architecture Catalogue](docs/architecture/overview/ARCHITECTURE_CATALOGUE.md)
- [Secure Microservices Architecture](docs/architecture/overview/SECURE_MICROSERVICES_ARCHITECTURE.md)
- [Repo Naming & Ownership Strategy](docs/enterprisearchitecture/implementation-development/transformation/workspace-ddd-eda-2026-03-13/REPO_NAMING_AND_OWNERSHIP_STRATEGY.md)
- [Service Data Ownership Matrix](docs/enterprisearchitecture/implementation-development/SERVICE_DATA_OWNERSHIP_MATRIX.md)
- [Service API Contracts Index](docs/enterprisearchitecture/implementation-development/SERVICE_API_CONTRACTS_INDEX.md)
- [Transformation Plan](docs/enterprisearchitecture/implementation-development/MICROSERVICES_TRANSFORMATION_PLAN.md)

## Publication Guardrails

- No local-machine absolute paths in committed docs
- No personal identifiers in architecture/test artifacts
- No secret material (keys/tokens/passwords) in source-controlled content
- Use environment placeholders for operational paths and credentials
