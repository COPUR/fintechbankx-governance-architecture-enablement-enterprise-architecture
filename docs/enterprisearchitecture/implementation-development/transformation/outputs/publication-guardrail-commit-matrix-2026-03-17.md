# Publication Guardrail Commit Matrix (2026-03-17)

Scope: FinTechBankX phase5 repositories (13) hardened for publication guardrails.

Guardrails applied:
- README publication-guardrail section and local link normalization
- `docs/publication/PUBLICATION_GUARDRAILS.md` baseline in each repo
- Local machine path anonymization in text artifacts
- Missing documentation assets added for broken README links (lending/payments)

Validation gates:
- Local path scan (`/Users/`, `alicopur`, `/home/`) => clean in all 13 repos
- README local-link resolution => clean in all 13 repos

| Repository | Branch | Commit | Push |
| --- | --- | --- | --- |
| fintechbankx-compliance-evidence-service | codex/phase5-contract-fapi-gates | `729c161` | OK |
| fintechbankx-contracts-openapi-catalog | codex/phase5-contract-fapi-gates | `bb041af` | OK |
| fintechbankx-customer-profile-kyc-service | codex/phase5-contract-fapi-gates | `b89a61c` | OK |
| fintechbankx-lending-loan-lifecycle-service | codex/phase5-contract-fapi-gates | `3545274` | OK |
| fintechbankx-openfinance-atm-directory-service | codex/phase5-contract-fapi-gates | `b57721f` | OK |
| fintechbankx-openfinance-banking-metadata-service | codex/phase5-contract-fapi-gates | `6f8cfee` | OK |
| fintechbankx-openfinance-business-financial-data-service | codex/phase5-contract-fapi-gates | `30f2db5` | OK |
| fintechbankx-openfinance-consent-authorization-service | codex/phase5-contract-fapi-gates | `9384beb` | OK |
| fintechbankx-openfinance-open-products-catalog-service | codex/phase5-contract-fapi-gates | `878a2dd` | OK |
| fintechbankx-openfinance-payee-verification-service | codex/phase5-contract-fapi-gates | `d7e5666` | OK |
| fintechbankx-openfinance-personal-financial-data-service | codex/phase5-contract-fapi-gates | `3124744` | OK |
| fintechbankx-payments-initiation-settlement-service | codex/phase5-contract-fapi-gates | `9ec7a5b` | OK |
| fintechbankx-risk-decisioning-service | codex/phase5-contract-fapi-gates | `1df8191` | OK |
