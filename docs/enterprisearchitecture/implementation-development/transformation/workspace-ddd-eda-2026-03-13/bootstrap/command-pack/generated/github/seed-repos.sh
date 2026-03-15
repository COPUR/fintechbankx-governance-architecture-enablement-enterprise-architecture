#!/usr/bin/env bash
set -euo pipefail

: "${GITHUB_ORG:?Set GITHUB_ORG, for example: export GITHUB_ORG=my-org}"
DRY_RUN="${DRY_RUN:-true}"
WAVE_FILTER="${WAVE_FILTER:-all}"
WORK_DIR="${WORK_DIR:-/tmp/repo-bootstrap/github}"
PUSH_CHANGES="${PUSH_CHANGES:-false}"
BASE_BRANCH="${BASE_BRANCH:-main}"
SEED_BRANCH="${SEED_BRANCH:-bootstrap/initial-structure}"
CREATE_PR="${CREATE_PR:-false}"
GIT_REMOTE_PROTOCOL="${GIT_REMOTE_PROTOCOL:-ssh}"   # ssh | https
DEFAULT_CODEOWNER="${DEFAULT_CODEOWNER:-@architecture-team}"

RECORDS=(
  'fintechbankx-openfinance-consent-authorization-service|open_finance|svc-of-consent-authorization|app.of.consent-authorization|db_of_consent_authorization_prod|evt.of.consent|Consent and Authorization Squad|2'
  'fintechbankx-openfinance-personal-financial-data-service|open_finance|svc-of-personal-financial-data|app.of.personal-financial-data|db_of_personal_financial_data_prod|evt.of.account|Retail Financial Data Squad|2'
  'fintechbankx-openfinance-business-financial-data-service|open_finance|svc-of-business-financial-data|app.of.business-financial-data|db_of_business_financial_data_prod|evt.of.corporate|Corporate Financial Data Squad|2'
  'fintechbankx-openfinance-payee-verification-service|open_finance|svc-of-payee-verification|app.of.payee-verification|db_of_payee_verification_prod|evt.of.payee|Payee and Metadata Squad|1'
  'fintechbankx-openfinance-banking-metadata-service|open_finance|svc-of-banking-metadata|app.of.banking-metadata|db_of_banking_metadata_prod|evt.of.metadata|Payee and Metadata Squad|2'
  'fintechbankx-openfinance-open-products-catalog-service|open_finance|svc-of-open-products-catalog|app.of.open-products-catalog|db_of_open_products_catalog_prod|evt.of.products|Open Data Squad|1'
  'fintechbankx-openfinance-atm-directory-service|open_finance|svc-of-atm-directory|app.of.atm-directory|db_of_atm_directory_prod|evt.of.atm|Open Data Squad|1'
  'fintechbankx-lending-loan-lifecycle-service|lending|svc-ln-loan-lifecycle|app.ln.loan-lifecycle|db_ln_loan_lifecycle_prod|evt.ln.loan|Loan Lifecycle Squad|3'
  'fintechbankx-payments-initiation-settlement-service|payments|svc-pay-initiation-settlement|app.pay.initiation-settlement|db_pay_initiation_settlement_prod|evt.pay.payment|Payment Orchestration Squad|3'
  'fintechbankx-payments-recurring-mandates-service|payments|svc-pay-recurring-mandates|app.pay.recurring-mandates|db_pay_recurring_mandates_prod|evt.pay.mandate|Recurring and Bulk Payments Squad|3'
  'fintechbankx-payments-bulk-orchestration-service|payments|svc-pay-bulk-orchestration|app.pay.bulk-orchestration|db_pay_bulk_orchestration_prod|evt.pay.bulk|Recurring and Bulk Payments Squad|3'
  'fintechbankx-payments-request-to-pay-service|payments|svc-pay-request-to-pay|app.pay.request-to-pay|db_pay_request_to_pay_prod|evt.pay.rtp|Recurring and Bulk Payments Squad|3'
  'fintechbankx-customer-profile-kyc-service|customer|svc-cus-profile-kyc|app.cus.profile-kyc|db_cus_profile_kyc_prod|evt.cus.customer|Customer and KYC Squad|4'
  'fintechbankx-risk-decisioning-service|risk|svc-rsk-decisioning|app.rsk.decisioning|db_rsk_decisioning_prod|evt.rsk.risk|Risk and Compliance Decisioning Squad|4'
  'fintechbankx-compliance-evidence-service|compliance|svc-cmp-evidence|app.cmp.evidence|db_cmp_evidence_prod|evt.cmp.compliance|Risk and Compliance Decisioning Squad|4'
  'fintechbankx-platform-identity-keycloak-ldap|platform|svc-idn-keycloak-ldap|app.idn.keycloak-ldap|db_idn_keycloak_ldap_prod|evt.idn.identity|Identity Platform Squad|0'
  'fintechbankx-platform-service-mesh-security|platform|svc-msh-security|app.msh.security|N/A|evt.msh.policy|Mesh Security Squad|0'
  'fintechbankx-platform-event-streaming|platform|svc-evt-streaming|app.evt.streaming|db_evt_streaming_prod|evt.evt.platform|Event Platform Squad|0'
  'fintechbankx-platform-observability-sre|platform|svc-obs-sre|app.obs.sre|db_obs_sre_prod|evt.obs.telemetry|Observability and SRE Squad|0'
  'fintechbankx-platform-delivery-templates|platform|svc-dly-templates|app.dly.templates|N/A|evt.dly.pipeline|DevSecOps Enablement Squad|0'
  'fintechbankx-platform-terraform-modules|platform|svc-iac-modules|app.iac.modules|N/A|evt.iac.module|Infrastructure and Data Platform Squad|0'
  'fintechbankx-contracts-openapi-catalog|contracts|svc-ctr-openapi-catalog|app.ctr.openapi-catalog|db_ctr_openapi_catalog_prod|evt.ctr.openapi|API Governance Guild|4'
  'fintechbankx-contracts-asyncapi-catalog|contracts|svc-ctr-asyncapi-catalog|app.ctr.asyncapi-catalog|db_ctr_asyncapi_catalog_prod|evt.ctr.asyncapi|API Governance Guild|4'
  'fintechbankx-contracts-schema-registry|contracts|svc-ctr-schema-registry|app.ctr.schema-registry|db_ctr_schema_registry_prod|evt.ctr.schema|API Governance Guild|4'
  'fintechbankx-governance-architecture-adr-runbooks|governance|svc-gov-architecture-runbooks|app.gov.architecture-runbooks|N/A|evt.gov.architecture|Architecture Board|4'
)

should_process_wave() {
  local wave="$1"
  if [[ "${WAVE_FILTER}" == "all" ]]; then
    return 0
  fi
  IFS=',' read -r -a allowed <<< "${WAVE_FILTER}"
  for candidate in "${allowed[@]}"; do
    if [[ "${candidate}" == "${wave}" ]]; then
      return 0
    fi
  done
  return 1
}

repo_url() {
  local repo="$1"
  if [[ "${GIT_REMOTE_PROTOCOL}" == "https" ]]; then
    echo "https://github.com/${GITHUB_ORG}/${repo}.git"
  else
    echo "git@github.com:${GITHUB_ORG}/${repo}.git"
  fi
}

seed_repo() {
  local repo="$1"
  local context="$2"
  local service_id="$3"
  local app_id="$4"
  local db_pattern="$5"
  local event_ns="$6"
  local owning_squad="$7"
  local wave="$8"

  local url
  url="$(repo_url "${repo}")"
  local target_dir="${WORK_DIR}/${repo}"

  if [[ "${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] seed repo: ${repo} wave=${wave} url=${url}"
    return 0
  fi

  if [[ "${PUSH_CHANGES}" != "true" ]]; then
    echo "[skip] seed disabled for ${repo}: set PUSH_CHANGES=true to apply bootstrap commits."
    return 0
  fi

  mkdir -p "${WORK_DIR}"
  if [[ -d "${target_dir}/.git" ]]; then
    git -C "${target_dir}" fetch origin
    git -C "${target_dir}" checkout "${BASE_BRANCH}"
    git -C "${target_dir}" pull --ff-only origin "${BASE_BRANCH}"
  else
    git clone "${url}" "${target_dir}"
    git -C "${target_dir}" checkout "${BASE_BRANCH}"
  fi
  git -C "${target_dir}" checkout -B "${SEED_BRANCH}" "origin/${BASE_BRANCH}"

  mkdir -p "${target_dir}/domain" "${target_dir}/application" "${target_dir}/infrastructure" "${target_dir}/tests" "${target_dir}/docs" "${target_dir}/.github"

  cat > "${target_dir}/README.md" <<EOF
# ${repo}

## Ownership Metadata

- Bounded context: ${context}
- Service ID: ${service_id}
- Application ID: ${app_id}
- Data owner pattern: ${db_pattern}
- Event namespace: ${event_ns}
- Owning squad: ${owning_squad}
- Wave: ${wave}
EOF

  cat > "${target_dir}/OWNERSHIP.yaml" <<EOF
bounded_context: "${context}"
service_id: "${service_id}"
application_id: "${app_id}"
data_owner_pattern: "${db_pattern}"
event_namespace: "${event_ns}"
owning_squad: "${owning_squad}"
wave: "${wave}"
EOF

  cat > "${target_dir}/CODEOWNERS" <<EOF
* ${DEFAULT_CODEOWNER}
EOF

  cat > "${target_dir}/domain/README.md" <<EOF
# Domain Layer

Pure domain model (entities, aggregates, value objects, domain services).
EOF

  cat > "${target_dir}/application/README.md" <<EOF
# Application Layer

Use cases, orchestration, ports, and inbound command/query handlers.
EOF

  cat > "${target_dir}/infrastructure/README.md" <<EOF
# Infrastructure Layer

Adapters for persistence, messaging, web, and external integrations.
EOF

  cat > "${target_dir}/tests/README.md" <<EOF
# Test Layer

Unit, integration, contract, and end-to-end test strategy and suites.
EOF

  cat > "${target_dir}/docs/README.md" <<EOF
# Service Documentation

Service-specific ADRs, API/event contracts, and operational runbooks.
EOF

  cat > "${target_dir}/.gitignore" <<EOF
.idea/
.vscode/
.gradle/
build/
out/
node_modules/
.DS_Store
EOF

  if git -C "${target_dir}" diff --quiet && git -C "${target_dir}" diff --cached --quiet; then
    echo "[skip] no changes detected: ${repo}"
    return 0
  fi

  git -C "${target_dir}" add .
  if git -C "${target_dir}" diff --cached --quiet; then
    echo "[skip] no staged changes: ${repo}"
    return 0
  fi

  git -C "${target_dir}" commit -m "chore(bootstrap): initialize DDD/EDA skeleton and ownership metadata"
  git -C "${target_dir}" push -u origin "${SEED_BRANCH}" --force-with-lease
  echo "[ok] pushed seed branch: ${repo}@${SEED_BRANCH}"
  if [[ "${CREATE_PR}" == "true" ]]; then
    gh pr create         --repo "${GITHUB_ORG}/${repo}"         --base "${BASE_BRANCH}"         --head "${SEED_BRANCH}"         --title "chore(bootstrap): initialize DDD/EDA skeleton"         --body "Automated bootstrap for DDD/EDA repository skeleton and ownership metadata." >/dev/null || true
    echo "[ok] pull request ensured: ${GITHUB_ORG}/${repo} (${SEED_BRANCH} -> ${BASE_BRANCH})"
  fi
}

for rec in "${RECORDS[@]}"; do
  IFS='|' read -r repo context service_id app_id db_pattern event_ns owning_squad wave <<<"$rec"
  if ! should_process_wave "${wave}"; then
    continue
  fi
  seed_repo "${repo}" "${context}" "${service_id}" "${app_id}" "${db_pattern}" "${event_ns}" "${owning_squad}" "${wave}"
done

echo "[done] GitHub seed pass completed."
