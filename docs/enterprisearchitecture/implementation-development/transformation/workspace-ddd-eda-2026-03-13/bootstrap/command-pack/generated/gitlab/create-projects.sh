#!/usr/bin/env bash
set -euo pipefail

GITLAB_HOST="${GITLAB_HOST:-https://gitlab.com}"
GITLAB_TOKEN="${GITLAB_TOKEN:-}"
GITLAB_NAMESPACE_ID="${GITLAB_NAMESPACE_ID:-}"
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

api_get() {
  local url="$1"
  curl -sS --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "$url"
}

api_post() {
  local url="$1"
  shift
  curl -sS --request POST --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "$url" "$@"
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

project_id_from_group_search() {
  local repo="$1"
  api_get "${GITLAB_HOST}/api/v4/groups/${GITLAB_NAMESPACE_ID}/projects?per_page=100&search=${repo}" |     jq -r --arg repo "$repo" '.[] | select(.path == $repo) | .id' | head -n1
}

create_project() {
  local repo="$1"
  local context="$2"
  local service_id="$3"
  local owning_squad="$4"
  local wave="$5"

  if [[ "${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] create project: ${repo} namespace_id=${GITLAB_NAMESPACE_ID:-<set>}"
    return 0
  fi

  local existing_id
  existing_id="$(project_id_from_group_search "$repo" || true)"
  if [[ -n "${existing_id}" ]]; then
    echo "[skip] exists: ${repo} (id=${existing_id})"
    return 0
  fi

  local description
  description="DDD/EDA ${context} capability (${service_id}) owner:${owning_squad} wave:${wave}"

  : "${GITLAB_TOKEN:?Set GITLAB_TOKEN}"
  : "${GITLAB_NAMESPACE_ID:?Set GITLAB_NAMESPACE_ID (numeric group ID)}"

  api_post "${GITLAB_HOST}/api/v4/projects"     --data-urlencode "name=${repo}"     --data-urlencode "path=${repo}"     --data-urlencode "namespace_id=${GITLAB_NAMESPACE_ID}"     --data-urlencode "visibility=${VISIBILITY}"     --data-urlencode "initialize_with_readme=true"     --data-urlencode "default_branch=main"     --data-urlencode "description=${description}" >/dev/null

  echo "[ok] created: ${repo}"
}

for rec in "${RECORDS[@]}"; do
  IFS='|' read -r repo context service_id owning_squad wave <<<"$rec"
  if ! should_process_wave "${wave}"; then
    continue
  fi
  create_project "$repo" "$context" "$service_id" "$owning_squad" "$wave"
done

echo "[done] GitLab project creation pass completed."
