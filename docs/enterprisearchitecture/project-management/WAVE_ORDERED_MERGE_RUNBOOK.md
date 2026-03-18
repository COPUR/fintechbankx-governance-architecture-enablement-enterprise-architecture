# Wave-Ordered Merge Runbook (README Ownership Standard)

Generated at: 2026-03-18T10:17:39.768Z

## Merge Order

Order policy: Wave 0 -> Wave 1 -> Wave 2 -> Wave 3 -> Wave 4.

| Order | Wave | Repository | Owner Squad | PR | Merge State |
|---:|---:|---|---|---|---|
| 1 | 0 | fintechbankx-platform-delivery-iac-cicd-templates | DevSecOps Enablement Squad | [#8](https://github.com/COPUR/fintechbankx-platform-delivery-iac-cicd-templates/pull/8) | DIRTY |
| 2 | 0 | fintechbankx-platform-delivery-iac-terraform-modules | Infrastructure and Data Platform Squad | [#8](https://github.com/COPUR/fintechbankx-platform-delivery-iac-terraform-modules/pull/8) | DIRTY |
| 3 | 0 | fintechbankx-platform-event-streaming-kafka | Event Platform Squad | [#8](https://github.com/COPUR/fintechbankx-platform-event-streaming-kafka/pull/8) | DIRTY |
| 4 | 0 | fintechbankx-platform-identity-iam-keycloak-ldap | Identity Platform Squad | [#8](https://github.com/COPUR/fintechbankx-platform-identity-iam-keycloak-ldap/pull/8) | DIRTY |
| 5 | 0 | fintechbankx-platform-mesh-security-service-mesh | Mesh Security Squad | [#8](https://github.com/COPUR/fintechbankx-platform-mesh-security-service-mesh/pull/8) | DIRTY |
| 6 | 0 | fintechbankx-platform-observability-sre-operations | Observability and SRE Squad | [#8](https://github.com/COPUR/fintechbankx-platform-observability-sre-operations/pull/8) | DIRTY |
| 7 | 1 | fintechbankx-openfinance-open-data-atm-directory | Open Data Squad | [#11](https://github.com/COPUR/fintechbankx-openfinance-open-data-atm-directory/pull/11) | DIRTY |
| 8 | 1 | fintechbankx-openfinance-open-data-products-catalog | Open Data Squad | [#11](https://github.com/COPUR/fintechbankx-openfinance-open-data-products-catalog/pull/11) | DIRTY |
| 9 | 1 | fintechbankx-openfinance-payee-metadata-payee-verification | Payee and Metadata Squad | [#10](https://github.com/COPUR/fintechbankx-openfinance-payee-metadata-payee-verification/pull/10) | DIRTY |
| 10 | 2 | fintechbankx-openfinance-consent-auth-service | Consent and Authorization Squad | [#10](https://github.com/COPUR/fintechbankx-openfinance-consent-auth-service/pull/10) | DIRTY |
| 11 | 2 | fintechbankx-openfinance-corporate-data-business-financial | Corporate Financial Data Squad | [#11](https://github.com/COPUR/fintechbankx-openfinance-corporate-data-business-financial/pull/11) | DIRTY |
| 12 | 2 | fintechbankx-openfinance-payee-metadata-banking-metadata | Payee and Metadata Squad | [#11](https://github.com/COPUR/fintechbankx-openfinance-payee-metadata-banking-metadata/pull/11) | DIRTY |
| 13 | 2 | fintechbankx-openfinance-retail-data-personal-financial | Retail Financial Data Squad | [#11](https://github.com/COPUR/fintechbankx-openfinance-retail-data-personal-financial/pull/11) | DIRTY |
| 14 | 3 | fintechbankx-lendingpayments-loan-lifecycle-core | Loan Lifecycle Squad | [#12](https://github.com/COPUR/fintechbankx-lendingpayments-loan-lifecycle-core/pull/12) | DIRTY |
| 15 | 3 | fintechbankx-lendingpayments-payment-orchestration-bulk-orchestration | Recurring and Bulk Payments Squad | [#10](https://github.com/COPUR/fintechbankx-lendingpayments-payment-orchestration-bulk-orchestration/pull/10) | BLOCKED |
| 16 | 3 | fintechbankx-lendingpayments-payment-orchestration-initiation-settlement | Payment Orchestration Squad | [#12](https://github.com/COPUR/fintechbankx-lendingpayments-payment-orchestration-initiation-settlement/pull/12) | DIRTY |
| 17 | 3 | fintechbankx-lendingpayments-payment-orchestration-recurring-mandates | Recurring and Bulk Payments Squad | [#10](https://github.com/COPUR/fintechbankx-lendingpayments-payment-orchestration-recurring-mandates/pull/10) | BLOCKED |
| 18 | 3 | fintechbankx-lendingpayments-payment-orchestration-request-to-pay | Recurring and Bulk Payments Squad | [#10](https://github.com/COPUR/fintechbankx-lendingpayments-payment-orchestration-request-to-pay/pull/10) | BLOCKED |
| 19 | 4 | fintechbankx-customer-profile-kyc-core | Customer and KYC Squad | [#9](https://github.com/COPUR/fintechbankx-customer-profile-kyc-core/pull/9) | DIRTY |
| 20 | 4 | fintechbankx-governance-api-contracts-asyncapi-catalog | API Governance Guild | [#6](https://github.com/COPUR/fintechbankx-governance-api-contracts-asyncapi-catalog/pull/6) | BLOCKED |
| 21 | 4 | fintechbankx-governance-api-contracts-openapi-catalog | API Governance Guild | [#10](https://github.com/COPUR/fintechbankx-governance-api-contracts-openapi-catalog/pull/10) | DIRTY |
| 22 | 4 | fintechbankx-governance-api-contracts-schema-registry | API Governance Guild | [#6](https://github.com/COPUR/fintechbankx-governance-api-contracts-schema-registry/pull/6) | BLOCKED |
| 23 | 4 | fintechbankx-governance-architecture-enablement-adr-runbooks | Architecture Board | [#6](https://github.com/COPUR/fintechbankx-governance-architecture-enablement-adr-runbooks/pull/6) | BLOCKED |
| 24 | 4 | fintechbankx-governance-architecture-enablement-enterprise-architecture | Architecture Enablement Squad | [#11](https://github.com/COPUR/fintechbankx-governance-architecture-enablement-enterprise-architecture/pull/11) | DIRTY |
| 25 | 4 | fintechbankx-riskcompliance-compliance-evidence-core | Risk and Compliance Decisioning Squad | [#9](https://github.com/COPUR/fintechbankx-riskcompliance-compliance-evidence-core/pull/9) | DIRTY |
| 26 | 4 | fintechbankx-riskcompliance-risk-decisioning-core | Risk and Compliance Decisioning Squad | [#9](https://github.com/COPUR/fintechbankx-riskcompliance-risk-decisioning-core/pull/9) | DIRTY |

## Command Pack

```bash
# Merge in wave order (admin mode if protection blocks)
for repo in \
  fintechbankx-platform-delivery-iac-cicd-templates \
  fintechbankx-platform-delivery-iac-terraform-modules \
  fintechbankx-platform-event-streaming-kafka \
  fintechbankx-platform-identity-iam-keycloak-ldap \
  fintechbankx-platform-mesh-security-service-mesh \
  fintechbankx-platform-observability-sre-operations \
  fintechbankx-openfinance-open-data-atm-directory \
  fintechbankx-openfinance-open-data-products-catalog \
  fintechbankx-openfinance-payee-metadata-payee-verification \
  fintechbankx-openfinance-consent-auth-service \
  fintechbankx-openfinance-corporate-data-business-financial \
  fintechbankx-openfinance-payee-metadata-banking-metadata \
  fintechbankx-openfinance-retail-data-personal-financial \
  fintechbankx-lendingpayments-loan-lifecycle-core \
  fintechbankx-lendingpayments-payment-orchestration-bulk-orchestration \
  fintechbankx-lendingpayments-payment-orchestration-initiation-settlement \
  fintechbankx-lendingpayments-payment-orchestration-recurring-mandates \
  fintechbankx-lendingpayments-payment-orchestration-request-to-pay \
  fintechbankx-customer-profile-kyc-core \
  fintechbankx-governance-api-contracts-asyncapi-catalog \
  fintechbankx-governance-api-contracts-openapi-catalog \
  fintechbankx-governance-api-contracts-schema-registry \
  fintechbankx-governance-architecture-enablement-adr-runbooks \
  fintechbankx-governance-architecture-enablement-enterprise-architecture \
  fintechbankx-riskcompliance-compliance-evidence-core \
  fintechbankx-riskcompliance-risk-decisioning-core
do
  pr=$(gh pr list --repo COPUR/$repo --state open --head codex/readme-ownership-docs --json number --jq ".[0].number")
  [ -z "$pr" ] && echo "NO_PR $repo" && continue
  gh pr merge --repo COPUR/$repo $pr --squash --delete-branch --admin || gh pr merge --repo COPUR/$repo $pr --auto --squash --delete-branch
done

# Post-merge baseline tag
for repo in \
  fintechbankx-platform-delivery-iac-cicd-templates \
  fintechbankx-platform-delivery-iac-terraform-modules \
  fintechbankx-platform-event-streaming-kafka \
  fintechbankx-platform-identity-iam-keycloak-ldap \
  fintechbankx-platform-mesh-security-service-mesh \
  fintechbankx-platform-observability-sre-operations \
  fintechbankx-openfinance-open-data-atm-directory \
  fintechbankx-openfinance-open-data-products-catalog \
  fintechbankx-openfinance-payee-metadata-payee-verification \
  fintechbankx-openfinance-consent-auth-service \
  fintechbankx-openfinance-corporate-data-business-financial \
  fintechbankx-openfinance-payee-metadata-banking-metadata \
  fintechbankx-openfinance-retail-data-personal-financial \
  fintechbankx-lendingpayments-loan-lifecycle-core \
  fintechbankx-lendingpayments-payment-orchestration-bulk-orchestration \
  fintechbankx-lendingpayments-payment-orchestration-initiation-settlement \
  fintechbankx-lendingpayments-payment-orchestration-recurring-mandates \
  fintechbankx-lendingpayments-payment-orchestration-request-to-pay \
  fintechbankx-customer-profile-kyc-core \
  fintechbankx-governance-api-contracts-asyncapi-catalog \
  fintechbankx-governance-api-contracts-openapi-catalog \
  fintechbankx-governance-api-contracts-schema-registry \
  fintechbankx-governance-architecture-enablement-adr-runbooks \
  fintechbankx-governance-architecture-enablement-enterprise-architecture \
  fintechbankx-riskcompliance-compliance-evidence-core \
  fintechbankx-riskcompliance-risk-decisioning-core
do
  if [ -d "/Users/alicopur/Documents/GitHub/fintechbankx-wave0-platform/$repo/.git" ]; then p="/Users/alicopur/Documents/GitHub/fintechbankx-wave0-platform/$repo";
  elif [ -d "/Users/alicopur/Documents/GitHub/fintechbankx-wave2-ref/$repo/.git" ]; then p="/Users/alicopur/Documents/GitHub/fintechbankx-wave2-ref/$repo";
  elif [ -d "/Users/alicopur/Documents/GitHub/fintechbankx-wave3/$repo/.git" ]; then p="/Users/alicopur/Documents/GitHub/fintechbankx-wave3/$repo";
  elif [ -d "/Users/alicopur/Documents/GitHub/fintechbankx-wave4/$repo/.git" ]; then p="/Users/alicopur/Documents/GitHub/fintechbankx-wave4/$repo";
  elif [ -d "/Users/alicopur/Documents/GitHub/fintechbankx-wave4-catalogs/$repo/.git" ]; then p="/Users/alicopur/Documents/GitHub/fintechbankx-wave4-catalogs/$repo";
  elif [ -d "/Users/alicopur/Documents/GitHub/fintechbankx-phase5/$repo/.git" ]; then p="/Users/alicopur/Documents/GitHub/fintechbankx-phase5/$repo";
  elif [ -d "/Users/alicopur/Documents/GitHub/repo-work/$repo/.git" ]; then p="/Users/alicopur/Documents/GitHub/repo-work/$repo";
  else echo "MISSING_LOCAL $repo"; continue; fi
  git -C "$p" fetch origin --tags
  git -C "$p" checkout main
  git -C "$p" pull --ff-only origin main
  git -C "$p" tag -a docs-guardrails-v1 -m "Docs ownership guardrails baseline" 2>/dev/null || true
  git -C "$p" push origin docs-guardrails-v1 2>/dev/null || true
done
```
