#!/usr/bin/env bash
set -euo pipefail

: "${GITHUB_ORG:?Set GITHUB_ORG, for example: export GITHUB_ORG=my-org}"
DRY_RUN="${DRY_RUN:-true}"
REQUIRED_CHECKS="${REQUIRED_CHECKS:-ci/build,ci/test,ci/security}"
WAVE_FILTER="${WAVE_FILTER:-all}"

IFS=',' read -r -a CHECKS <<< "${REQUIRED_CHECKS}"

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

ensure_branch() {
  local repo="$1"
  local branch="$2"
  local ref_url="repos/${GITHUB_ORG}/${repo}/git/ref/heads/${branch}"
  local main_ref_url="repos/${GITHUB_ORG}/${repo}/git/ref/heads/main"

  if [[ "${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] ensure branch: ${GITHUB_ORG}/${repo}@${branch} (from main)"
    return 0
  fi

  if gh api "$ref_url" >/dev/null 2>&1; then
    echo "[skip] branch exists: ${GITHUB_ORG}/${repo}@${branch}"
    return 0
  fi

  local sha
  sha="$(gh api "$main_ref_url" --jq '.object.sha')"
  run gh api -X POST "repos/${GITHUB_ORG}/${repo}/git/refs" -f ref="refs/heads/${branch}" -f sha="${sha}" >/dev/null
  echo "[ok] branch ensured: ${GITHUB_ORG}/${repo}@${branch}"
}

protect_branch() {
  local repo="$1"
  local branch="$2"
  local approvals="$3"

  if [[ "${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] protect branch: ${GITHUB_ORG}/${repo}@${branch} approvals=${approvals} checks=${REQUIRED_CHECKS}"
    return 0
  fi

  local contexts_json
  contexts_json="$(printf '%s\n' "${CHECKS[@]}" | jq -R . | jq -s .)"

  jq -n     --argjson contexts "$contexts_json"     --argjson approvals "$approvals"     '{
      required_status_checks: { strict: true, contexts: $contexts },
      enforce_admins: true,
      required_pull_request_reviews: {
        dismiss_stale_reviews: true,
        required_approving_review_count: $approvals
      },
      restrictions: null,
      required_linear_history: true,
      allow_force_pushes: false,
      allow_deletions: false,
      block_creations: false,
      required_conversation_resolution: true,
      lock_branch: false
    }' | gh api -X PUT "repos/${GITHUB_ORG}/${repo}/branches/${branch}/protection" --input - >/dev/null
  echo "[ok] branch protected: ${GITHUB_ORG}/${repo}@${branch}"
}

for rec in "${RECORDS[@]}"; do
  IFS='|' read -r repo _context _service_id _owning_squad wave <<<"$rec"
  if ! should_process_wave "${wave}"; then
    continue
  fi
  ensure_branch "$repo" "dev"
  ensure_branch "$repo" "staging"
  protect_branch "$repo" "main" 2
  protect_branch "$repo" "dev" 1
  protect_branch "$repo" "staging" 1
done

echo "[done] GitHub branch hardening pass completed."
