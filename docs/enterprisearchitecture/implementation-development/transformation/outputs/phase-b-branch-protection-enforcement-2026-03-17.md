# Phase B Branch Protection Enforcement Report (2026-03-17)

## Scope
- Enforced required status checks on `main`, `dev`, `staging`.
- Wave 0 platform repos include `strict-mtls` as required check.
- Phase 5 + enterprise repos include publication checks as required checks.

## Wave 0 PR Status
| Repository | PR | State | Merge State | Review Decision |
| --- | --- | --- | --- | --- |
| fintechbankx-platform-terraform-modules | [#6](https://github.com/COPUR/fintechbankx-platform-terraform-modules/pull/6) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-platform-delivery-templates | [#6](https://github.com/COPUR/fintechbankx-platform-delivery-templates/pull/6) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-platform-observability-sre | [#6](https://github.com/COPUR/fintechbankx-platform-observability-sre/pull/6) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-platform-event-streaming | [#6](https://github.com/COPUR/fintechbankx-platform-event-streaming/pull/6) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-platform-service-mesh-security | [#6](https://github.com/COPUR/fintechbankx-platform-service-mesh-security/pull/6) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-platform-identity-keycloak-ldap | [#6](https://github.com/COPUR/fintechbankx-platform-identity-keycloak-ldap/pull/6) | OPEN | BLOCKED | REVIEW_REQUIRED |

## Phase 5 + Enterprise PR Status
| Repository | PR | State | Merge State | Review Decision |
| --- | --- | --- | --- | --- |
| fintechbankx-enterprise-architecture | [#6](https://github.com/COPUR/fintechbankx-enterprise-architecture/pull/6) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-compliance-evidence-service | [#7](https://github.com/COPUR/fintechbankx-compliance-evidence-service/pull/7) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-contracts-openapi-catalog | [#8](https://github.com/COPUR/fintechbankx-contracts-openapi-catalog/pull/8) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-customer-profile-kyc-service | [#7](https://github.com/COPUR/fintechbankx-customer-profile-kyc-service/pull/7) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-lending-loan-lifecycle-service | [#10](https://github.com/COPUR/fintechbankx-lending-loan-lifecycle-service/pull/10) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-openfinance-atm-directory-service | [#9](https://github.com/COPUR/fintechbankx-openfinance-atm-directory-service/pull/9) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-openfinance-banking-metadata-service | [#9](https://github.com/COPUR/fintechbankx-openfinance-banking-metadata-service/pull/9) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-openfinance-business-financial-data-service | [#9](https://github.com/COPUR/fintechbankx-openfinance-business-financial-data-service/pull/9) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-openfinance-consent-authorization-service | [#8](https://github.com/COPUR/fintechbankx-openfinance-consent-authorization-service/pull/8) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-openfinance-open-products-catalog-service | [#9](https://github.com/COPUR/fintechbankx-openfinance-open-products-catalog-service/pull/9) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-openfinance-payee-verification-service | [#8](https://github.com/COPUR/fintechbankx-openfinance-payee-verification-service/pull/8) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-openfinance-personal-financial-data-service | [#9](https://github.com/COPUR/fintechbankx-openfinance-personal-financial-data-service/pull/9) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-payments-initiation-settlement-service | [#10](https://github.com/COPUR/fintechbankx-payments-initiation-settlement-service/pull/10) | OPEN | BLOCKED | REVIEW_REQUIRED |
| fintechbankx-risk-decisioning-service | [#7](https://github.com/COPUR/fintechbankx-risk-decisioning-service/pull/7) | OPEN | BLOCKED | REVIEW_REQUIRED |

## Branch Protection Checksets
### Wave 0 (required: ci + strict-mtls + publication)
| Repository | Branch | Strict | Required Contexts |
| --- | --- | --- | --- |
| fintechbankx-platform-terraform-modules | main | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-terraform-modules | dev | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-terraform-modules | staging | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-delivery-templates | main | true | strict-mtls, ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-delivery-templates | dev | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-delivery-templates | staging | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-observability-sre | main | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-observability-sre | dev | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-observability-sre | staging | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-event-streaming | main | true | strict-mtls, ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-event-streaming | dev | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-event-streaming | staging | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-service-mesh-security | main | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-service-mesh-security | dev | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-service-mesh-security | staging | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-identity-keycloak-ldap | main | true | strict-mtls, ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-identity-keycloak-ldap | dev | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-platform-identity-keycloak-ldap | staging | true | ci/build, ci/test, ci/security, strict-mtls, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |

### Phase 5 + Enterprise (required: ci + publication)
| Repository | Branch | Strict | Required Contexts |
| --- | --- | --- | --- |
| fintechbankx-enterprise-architecture | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-enterprise-architecture | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-enterprise-architecture | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-compliance-evidence-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-compliance-evidence-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-compliance-evidence-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-contracts-openapi-catalog | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-contracts-openapi-catalog | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-contracts-openapi-catalog | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-customer-profile-kyc-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-customer-profile-kyc-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-customer-profile-kyc-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-lending-loan-lifecycle-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-lending-loan-lifecycle-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-lending-loan-lifecycle-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-atm-directory-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-atm-directory-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-atm-directory-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-banking-metadata-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-banking-metadata-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-banking-metadata-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-business-financial-data-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-business-financial-data-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-business-financial-data-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-consent-authorization-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-consent-authorization-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-consent-authorization-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-open-products-catalog-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-open-products-catalog-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-open-products-catalog-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-payee-verification-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-payee-verification-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-payee-verification-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-personal-financial-data-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-personal-financial-data-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-openfinance-personal-financial-data-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-payments-initiation-settlement-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-payments-initiation-settlement-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-payments-initiation-settlement-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-risk-decisioning-service | main | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-risk-decisioning-service | dev | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |
| fintechbankx-risk-decisioning-service | staging | true | ci/build, ci/test, ci/security, local-path-leak-check, secret-pattern-scan, readme-doc-link-check |

## Notes
- Open PRs remain review-gated by branch protection policy (expected).
- Required checks are now standardized for Phase B across covered repositories.
- Next action: merge PRs in sequence after checks + approvals, then tag docs baseline refresh if needed.
