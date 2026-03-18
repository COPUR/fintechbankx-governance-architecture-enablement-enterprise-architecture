# Microservices Transformation Plan

## Purpose

This plan defines the strategy for splitting the current monorepo into separate, deployable repositories that follow the Spotify model, DDD bounded contexts, and event-driven integration.

The plan is not a code implementation document. It is the execution contract for repository design, ownership, sequencing, and governance.

## Spotify-Aligned Operating Model

| Unit | Accountability |
| --- | --- |
| Tribe | Owns portfolio direction, sequencing, and major dependency decisions. |
| Squad | Owns a bounded-context repo, its backlog, tests, docs, and release readiness. |
| Guild | Owns shared standards, templates, and policy guardrails. |
| Board | Owns exception approval, cross-tribe arbitration, and architecture sign-off. |

## Repository Ownership Rules

1. One bounded context maps to one primary repo.
2. One primary squad owns each repo.
3. One tribe owns the squad portfolio.
4. One data owner owns each database or schema boundary.
5. One review cadence applies to each repo and is recorded in README and CODEOWNERS.
6. Platform repos, contract repos, and governance repos follow the same ownership model.

## Canonical Repo Families

### Open Finance Tribe
- `fintechbankx-openfinance-consent-auth-service`
- `fintechbankx-openfinance-retail-data-personal-financial`
- `fintechbankx-openfinance-corporate-data-business-financial`
- `fintechbankx-openfinance-payee-metadata-payee-verification`
- `fintechbankx-openfinance-payee-metadata-banking-metadata`
- `fintechbankx-openfinance-open-data-products-catalog`
- `fintechbankx-openfinance-open-data-atm-directory`

### Lending and Payments Tribe
- `fintechbankx-lendingpayments-loan-lifecycle-core`
- `fintechbankx-lendingpayments-payment-orchestration-initiation-settlement`
- `fintechbankx-lendingpayments-payment-orchestration-recurring-mandates`
- `fintechbankx-lendingpayments-payment-orchestration-bulk-orchestration`
- `fintechbankx-lendingpayments-payment-orchestration-request-to-pay`

### Customer, Risk, and Compliance
- `fintechbankx-customer-profile-kyc-core`
- `fintechbankx-riskcompliance-risk-decisioning-core`
- `fintechbankx-riskcompliance-compliance-evidence-core`

### Platform and Reliability Tribe
- `fintechbankx-platform-identity-iam-keycloak-ldap`
- `fintechbankx-platform-mesh-security-service-mesh`
- `fintechbankx-platform-event-streaming-kafka`
- `fintechbankx-platform-observability-sre-operations`
- `fintechbankx-platform-delivery-iac-cicd-templates`
- `fintechbankx-platform-delivery-iac-terraform-modules`

### Governance and Contract Control
- `fintechbankx-governance-api-contracts-openapi-catalog`
- `fintechbankx-governance-api-contracts-asyncapi-catalog`
- `fintechbankx-governance-api-contracts-schema-registry`
- `fintechbankx-governance-architecture-enablement-adr-runbooks`
- `fintechbankx-governance-architecture-enablement-enterprise-architecture`

## Transformation Waves

| Wave | Primary Goal | Primary Owners | Output |
| --- | --- | --- | --- |
| Wave 0 | Establish platform guardrails | Platform and Reliability Tribe | Secure CI/CD templates, identity, mesh, eventing, observability, IaC repos |
| Wave 1 | Harden Open Finance edge services | Open Finance squads | Consent, payee, metadata, open data repos with ownership blocks and contract gates |
| Wave 2 | Split financial data services | Open Finance squads | Retail and corporate data repos with explicit schema ownership and event contracts |
| Wave 3 | Split lending and payment services | Lending and Payments squads | Loan, initiation, recurring, bulk, and request-to-pay repos |
| Wave 4 | Complete customer, risk, compliance, contracts, and governance | Customer/Risk/Compliance squads, guilds, board | Customer, risk, compliance, contract catalog, and governance repos |

## Design Rules

1. Use business capability names, not use-case numbers.
2. Prefer one deployable service per repo.
3. Keep data ownership local to the repo.
4. Publish events as domain facts in past tense.
5. Version APIs and events explicitly.
6. Require branch protection and required checks before repo creation.
7. Add ownership metadata to README, CODEOWNERS, and execution artifacts.

## Execution Artifacts

- `docs/enterprisearchitecture/implementation-development/MICROSERVICES_TRANSFORMATION_TASK_LIST.md`
- `docs/enterprisearchitecture/implementation-development/SERVICE_DATA_OWNERSHIP_MATRIX.md`
- `docs/enterprisearchitecture/implementation-development/SERVICE_API_CONTRACTS_INDEX.md`
- `docs/architecture/overview/SECURE_MICROSERVICES_ARCHITECTURE.md`
- `docs/enterprisearchitecture/project-management/EXECUTION_STATUS_AND_NEXT_STEPS.md`

## Success Criteria

1. Every target repo has a defined tribe, squad, and review cadence.
2. Every repo has a CODEOWNERS file and a responsibility block in README.
3. Every bounded context has a named data owner and explicit contract ownership.
4. Every repo passes the publication guardrails and security checks.
5. The transformation backlog can be executed without ambiguity in ownership or naming.
