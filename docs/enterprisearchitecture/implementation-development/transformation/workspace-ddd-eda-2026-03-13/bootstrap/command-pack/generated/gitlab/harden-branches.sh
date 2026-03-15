#!/usr/bin/env bash
set -euo pipefail

GITLAB_HOST="${GITLAB_HOST:-https://gitlab.com}"
GITLAB_TOKEN="${GITLAB_TOKEN:-}"
GITLAB_NAMESPACE_ID="${GITLAB_NAMESPACE_ID:-}"
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
  curl -sS --request POST --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "$url" "$@" >/dev/null
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

ensure_branch() {
  local project_id="$1"
  local branch="$2"
  local existing
  existing="$(api_get "${GITLAB_HOST}/api/v4/projects/${project_id}/repository/branches/${branch}" | jq -r '.name // empty')"
  if [[ -n "${existing}" ]]; then
    echo "[skip] branch exists: project=${project_id} branch=${branch}"
    return 0
  fi

  if [[ "${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] create branch: project=${project_id} branch=${branch} ref=main"
    return 0
  fi

  api_post "${GITLAB_HOST}/api/v4/projects/${project_id}/repository/branches"     --data-urlencode "branch=${branch}"     --data-urlencode "ref=main"
}

protect_branch() {
  local project_id="$1"
  local branch="$2"

  if [[ "${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] protect branch: project=${project_id} branch=${branch}"
    return 0
  fi

  # If already protected, GitLab returns conflict; ignore.
  api_post "${GITLAB_HOST}/api/v4/projects/${project_id}/protected_branches"     --data-urlencode "name=${branch}"     --data-urlencode "push_access_level=0"     --data-urlencode "merge_access_level=40"     --data-urlencode "unprotect_access_level=40" || true
}

for rec in "${RECORDS[@]}"; do
  IFS='|' read -r repo _context _service_id _owning_squad wave <<<"$rec"
  if ! should_process_wave "${wave}"; then
    continue
  fi
  if [[ "${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] ensure branches/protection for ${repo} (main/dev/staging)"
    continue
  fi
  : "${GITLAB_TOKEN:?Set GITLAB_TOKEN}"
  : "${GITLAB_NAMESPACE_ID:?Set GITLAB_NAMESPACE_ID (numeric group ID)}"
  project_id="$(project_id_from_group_search "$repo" || true)"
  if [[ -z "${project_id}" ]]; then
    echo "[warn] project not found, skipping hardening: ${repo}"
    continue
  fi
  ensure_branch "$project_id" "dev"
  ensure_branch "$project_id" "staging"
  protect_branch "$project_id" "main"
  protect_branch "$project_id" "dev"
  protect_branch "$project_id" "staging"
done

echo "[done] GitLab branch hardening pass completed."
