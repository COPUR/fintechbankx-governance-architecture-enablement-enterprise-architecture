# Phase C Wave-Ordered Merge Runbook (2026-03-17)

This runbook provides the exact merge and release-tag command sequence for the current open transformation PR set.

## Preconditions
- All required checks are green on each PR.
- Required reviewers approve PRs (repos are review-gated).
- Merge strategy: `--squash --delete-branch`.

Preflight check command (optional):

```bash
gh pr checks -R COPUR/<repo> <pr_number>
```

## Merge and Tag Order

### Wave 0 (Platform Foundations)
1. `fintechbankx-platform-terraform-modules` PR #6
```bash
gh pr merge -R COPUR/fintechbankx-platform-terraform-modules 6 --squash --delete-branch
gh release view docs-guardrails-v1 -R COPUR/fintechbankx-platform-terraform-modules >/dev/null 2>&1 || \
  gh release create docs-guardrails-v1 -R COPUR/fintechbankx-platform-terraform-modules --target main \
  --title "docs-guardrails-v1" --notes "Wave 0 platform guardrails baseline."
```

2. `fintechbankx-platform-delivery-templates` PR #6
```bash
gh pr merge -R COPUR/fintechbankx-platform-delivery-templates 6 --squash --delete-branch
gh release view docs-guardrails-v1 -R COPUR/fintechbankx-platform-delivery-templates >/dev/null 2>&1 || \
  gh release create docs-guardrails-v1 -R COPUR/fintechbankx-platform-delivery-templates --target main \
  --title "docs-guardrails-v1" --notes "Wave 0 platform guardrails baseline."
```

3. `fintechbankx-platform-identity-keycloak-ldap` PR #6
```bash
gh pr merge -R COPUR/fintechbankx-platform-identity-keycloak-ldap 6 --squash --delete-branch
gh release view docs-guardrails-v1 -R COPUR/fintechbankx-platform-identity-keycloak-ldap >/dev/null 2>&1 || \
  gh release create docs-guardrails-v1 -R COPUR/fintechbankx-platform-identity-keycloak-ldap --target main \
  --title "docs-guardrails-v1" --notes "Wave 0 platform guardrails baseline."
```

4. `fintechbankx-platform-service-mesh-security` PR #6
```bash
gh pr merge -R COPUR/fintechbankx-platform-service-mesh-security 6 --squash --delete-branch
gh release view docs-guardrails-v1 -R COPUR/fintechbankx-platform-service-mesh-security >/dev/null 2>&1 || \
  gh release create docs-guardrails-v1 -R COPUR/fintechbankx-platform-service-mesh-security --target main \
  --title "docs-guardrails-v1" --notes "Wave 0 platform guardrails baseline."
```

5. `fintechbankx-platform-event-streaming` PR #6
```bash
gh pr merge -R COPUR/fintechbankx-platform-event-streaming 6 --squash --delete-branch
gh release view docs-guardrails-v1 -R COPUR/fintechbankx-platform-event-streaming >/dev/null 2>&1 || \
  gh release create docs-guardrails-v1 -R COPUR/fintechbankx-platform-event-streaming --target main \
  --title "docs-guardrails-v1" --notes "Wave 0 platform guardrails baseline."
```

6. `fintechbankx-platform-observability-sre` PR #6
```bash
gh pr merge -R COPUR/fintechbankx-platform-observability-sre 6 --squash --delete-branch
gh release view docs-guardrails-v1 -R COPUR/fintechbankx-platform-observability-sre >/dev/null 2>&1 || \
  gh release create docs-guardrails-v1 -R COPUR/fintechbankx-platform-observability-sre --target main \
  --title "docs-guardrails-v1" --notes "Wave 0 platform guardrails baseline."
```

### Wave 1 (Open Data and Payee)
7. `fintechbankx-openfinance-payee-verification-service` PR #8
```bash
gh pr merge -R COPUR/fintechbankx-openfinance-payee-verification-service 8 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-payee-verification-service >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-payee-verification-service --target main \
  --title "docs-guardrails-v2" --notes "Wave 1 publication guardrails hardening."
```

8. `fintechbankx-openfinance-open-products-catalog-service` PR #9
```bash
gh pr merge -R COPUR/fintechbankx-openfinance-open-products-catalog-service 9 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-open-products-catalog-service >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-open-products-catalog-service --target main \
  --title "docs-guardrails-v2" --notes "Wave 1 publication guardrails hardening."
```

9. `fintechbankx-openfinance-atm-directory-service` PR #9
```bash
gh pr merge -R COPUR/fintechbankx-openfinance-atm-directory-service 9 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-atm-directory-service >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-atm-directory-service --target main \
  --title "docs-guardrails-v2" --notes "Wave 1 publication guardrails hardening."
```

### Wave 2 (Consent and Financial Data)
10. `fintechbankx-openfinance-consent-authorization-service` PR #8
```bash
gh pr merge -R COPUR/fintechbankx-openfinance-consent-authorization-service 8 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-consent-authorization-service >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-consent-authorization-service --target main \
  --title "docs-guardrails-v2" --notes "Wave 2 publication guardrails hardening."
```

11. `fintechbankx-openfinance-personal-financial-data-service` PR #9
```bash
gh pr merge -R COPUR/fintechbankx-openfinance-personal-financial-data-service 9 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-personal-financial-data-service >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-personal-financial-data-service --target main \
  --title "docs-guardrails-v2" --notes "Wave 2 publication guardrails hardening."
```

12. `fintechbankx-openfinance-business-financial-data-service` PR #9
```bash
gh pr merge -R COPUR/fintechbankx-openfinance-business-financial-data-service 9 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-business-financial-data-service >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-business-financial-data-service --target main \
  --title "docs-guardrails-v2" --notes "Wave 2 publication guardrails hardening."
```

13. `fintechbankx-openfinance-banking-metadata-service` PR #9
```bash
gh pr merge -R COPUR/fintechbankx-openfinance-banking-metadata-service 9 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-banking-metadata-service >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-openfinance-banking-metadata-service --target main \
  --title "docs-guardrails-v2" --notes "Wave 2 publication guardrails hardening."
```

### Wave 3 (Lending and Payments)
14. `fintechbankx-payments-initiation-settlement-service` PR #10
```bash
gh pr merge -R COPUR/fintechbankx-payments-initiation-settlement-service 10 --squash --delete-branch
gh release view v0.3.2 -R COPUR/fintechbankx-payments-initiation-settlement-service >/dev/null 2>&1 || \
  gh release create v0.3.2 -R COPUR/fintechbankx-payments-initiation-settlement-service --target main \
  --title "v0.3.2" --notes "Guardrails and contract governance updates."
```

15. `fintechbankx-lending-loan-lifecycle-service` PR #10
```bash
gh pr merge -R COPUR/fintechbankx-lending-loan-lifecycle-service 10 --squash --delete-branch
gh release view v0.3.2 -R COPUR/fintechbankx-lending-loan-lifecycle-service >/dev/null 2>&1 || \
  gh release create v0.3.2 -R COPUR/fintechbankx-lending-loan-lifecycle-service --target main \
  --title "v0.3.2" --notes "Guardrails and contract governance updates."
```

### Wave 4 (Customer, Risk, Compliance, Governance)
16. `fintechbankx-contracts-openapi-catalog` PR #8
```bash
gh pr merge -R COPUR/fintechbankx-contracts-openapi-catalog 8 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-contracts-openapi-catalog >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-contracts-openapi-catalog --target main \
  --title "docs-guardrails-v2" --notes "Wave 4 governance and contract catalog updates."
```

17. `fintechbankx-customer-profile-kyc-service` PR #7
```bash
gh pr merge -R COPUR/fintechbankx-customer-profile-kyc-service 7 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-customer-profile-kyc-service >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-customer-profile-kyc-service --target main \
  --title "docs-guardrails-v2" --notes "Wave 4 publication guardrails hardening."
```

18. `fintechbankx-risk-decisioning-service` PR #7
```bash
gh pr merge -R COPUR/fintechbankx-risk-decisioning-service 7 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-risk-decisioning-service >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-risk-decisioning-service --target main \
  --title "docs-guardrails-v2" --notes "Wave 4 publication guardrails hardening."
```

19. `fintechbankx-compliance-evidence-service` PR #7
```bash
gh pr merge -R COPUR/fintechbankx-compliance-evidence-service 7 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-compliance-evidence-service >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-compliance-evidence-service --target main \
  --title "docs-guardrails-v2" --notes "Wave 4 publication guardrails hardening."
```

20. `fintechbankx-enterprise-architecture` PR #6
```bash
gh pr merge -R COPUR/fintechbankx-enterprise-architecture 6 --squash --delete-branch
gh release view docs-guardrails-v2 -R COPUR/fintechbankx-enterprise-architecture >/dev/null 2>&1 || \
  gh release create docs-guardrails-v2 -R COPUR/fintechbankx-enterprise-architecture --target main \
  --title "docs-guardrails-v2" --notes "Transformation governance evidence and closure reports."
```

## Repositories With No Open PR in This Cycle
- `fintechbankx-payments-recurring-mandates-service` (latest tag: `v0.4.1`)
- `fintechbankx-payments-bulk-orchestration-service` (latest tag: `v0.4.1`)
- `fintechbankx-payments-request-to-pay-service` (latest tag: `v0.4.1`)
- `fintechbankx-contracts-asyncapi-catalog` (no tag yet)
- `fintechbankx-contracts-schema-registry` (no tag yet)
- `fintechbankx-governance-architecture-adr-runbooks` (no tag yet)

Optional verification only:

```bash
gh release list -R COPUR/<repo> --limit 5
```

## Post-Execution Evidence Capture
Run after each merge:

```bash
gh pr view -R COPUR/<repo> <pr_number> --json number,state,mergedAt,mergeCommit,url
gh release view <tag> -R COPUR/<repo>
```

