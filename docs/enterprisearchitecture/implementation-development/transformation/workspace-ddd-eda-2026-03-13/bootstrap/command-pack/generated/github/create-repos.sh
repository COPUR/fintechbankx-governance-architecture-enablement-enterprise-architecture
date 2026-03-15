#!/usr/bin/env bash
set -euo pipefail

: "${GITHUB_ORG:?Set GITHUB_ORG, for example: export GITHUB_ORG=my-org}"
VISIBILITY="${VISIBILITY:-private}"
DRY_RUN="${DRY_RUN:-true}"
WAVE_FILTER="${WAVE_FILTER:-all}"

RECORDS=(
  'fintechbankx-openfinance-consent-authorization-service|open_finance|svc-of-consent-authorization|Consent and Authorization Squad|2'
  'fintechbankx-openfinance-personal-financial-data-service|open_finance|svc-of-personal-financial-data|Retail Financial Data Squad|2'
  'fintechbankx-openfinance-business-financial-data-service|open_finance|svc-of-business-financial-data|Corporate Financial Data Squad|2'
  'fintechbankx-openfinance-payee-verification-service|open_finance|svc-of-payee-verification|Payee and Metadata Squad|1'
  'fintechbankx-openfinance-banking-metadata-service|open_finance|svc-of-banking-metadata|Payee and Metadata Squad|2'
  'fintechbankx-openfinance-open-products-catalog-service|open_finance|svc-of-open-products-catalog|Open Data Squad|1'
  'fintechbankx-openfinance-atm-directory-service|open_finance|svc-of-atm-directory|Open Data Squad|1'
  'fintechbankx-lending-loan-lifecycle-service|lending|svc-ln-loan-lifecycle|Loan Lifecycle Squad|3'
  'fintechbankx-payments-initiation-settlement-service|payments|svc-pay-initiation-settlement|Payment Orchestration Squad|3'
  'fintechbankx-payments-recurring-mandates-service|payments|svc-pay-recurring-mandates|Recurring and Bulk Payments Squad|3'
  'fintechbankx-payments-bulk-orchestration-service|payments|svc-pay-bulk-orchestration|Recurring and Bulk Payments Squad|3'
  'fintechbankx-payments-request-to-pay-service|payments|svc-pay-request-to-pay|Recurring and Bulk Payments Squad|3'
  'fintechbankx-customer-profile-kyc-service|customer|svc-cus-profile-kyc|Customer and KYC Squad|4'
  'fintechbankx-risk-decisioning-service|risk|svc-rsk-decisioning|Risk and Compliance Decisioning Squad|4'
  'fintechbankx-compliance-evidence-service|compliance|svc-cmp-evidence|Risk and Compliance Decisioning Squad|4'
  'fintechbankx-platform-identity-keycloak-ldap|platform|svc-idn-keycloak-ldap|Identity Platform Squad|0'
  'fintechbankx-platform-service-mesh-security|platform|svc-msh-security|Mesh Security Squad|0'
  'fintechbankx-platform-event-streaming|platform|svc-evt-streaming|Event Platform Squad|0'
  'fintechbankx-platform-observability-sre|platform|svc-obs-sre|Observability and SRE Squad|0'
  'fintechbankx-platform-delivery-templates|platform|svc-dly-templates|DevSecOps Enablement Squad|0'
  'fintechbankx-platform-terraform-modules|platform|svc-iac-modules|Infrastructure and Data Platform Squad|0'
  'fintechbankx-contracts-openapi-catalog|contracts|svc-ctr-openapi-catalog|API Governance Guild|4'
  'fintechbankx-contracts-asyncapi-catalog|contracts|svc-ctr-asyncapi-catalog|API Governance Guild|4'
  'fintechbankx-contracts-schema-registry|contracts|svc-ctr-schema-registry|API Governance Guild|4'
  'fintechbankx-governance-architecture-adr-runbooks|governance|svc-gov-architecture-runbooks|Architecture Board|4'
)

run() {
  if [[ "${DRY_RUN}" == "true" ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    echo
    return 0
  fi
  "$@"
}

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

repo_exists() {
  local full_repo="$1"
  gh repo view "$full_repo" >/dev/null 2>&1
}

create_repo() {
  local repo="$1"
  local context="$2"
  local service_id="$3"
  local owning_squad="$4"
  local wave="$5"
  local full_repo="${GITHUB_ORG}/${repo}"

  if [[ "${DRY_RUN}" == "true" ]]; then
    local description
    description="DDD/EDA ${context} capability (${service_id}) owner:${owning_squad} wave:${wave}"
    run gh repo create "$full_repo" --"${VISIBILITY}" --description "$description" --add-readme --disable-wiki
    return 0
  fi

  if repo_exists "$full_repo"; then
    echo "[skip] exists: $full_repo"
    return 0
  fi

  local description
  description="DDD/EDA ${context} capability (${service_id}) owner:${owning_squad} wave:${wave}"

  run gh repo create "$full_repo" --"${VISIBILITY}" --description "$description" --add-readme --disable-wiki
}

for rec in "${RECORDS[@]}"; do
  IFS='|' read -r repo context service_id owning_squad wave <<<"$rec"
  if ! should_process_wave "${wave}"; then
    continue
  fi
  create_repo "$repo" "$context" "$service_id" "$owning_squad" "$wave"
done

echo "[done] GitHub repository creation pass completed."
