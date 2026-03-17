#!/usr/bin/env bash
set -euo pipefail

# Phase C merge command pack
# Usage:
#   bash phase-c-wave-ordered-merge-command-pack-2026-03-17.sh
#
# Notes:
# - Requires GitHub CLI auth with merge and release permissions.
# - Repos are review-gated; merge commands will fail until approvals are complete.

run_merge_and_tag() {
  local repo="$1"
  local pr="$2"
  local tag="$3"
  local notes="$4"

  echo "==> Merging COPUR/${repo} PR #${pr}"
  gh pr merge -R "COPUR/${repo}" "${pr}" --squash --delete-branch

  echo "==> Ensuring release tag ${tag} on COPUR/${repo}"
  gh release view "${tag}" -R "COPUR/${repo}" >/dev/null 2>&1 || \
    gh release create "${tag}" -R "COPUR/${repo}" --target main \
      --title "${tag}" --notes "${notes}"
}

echo "Wave 0"
run_merge_and_tag "fintechbankx-platform-terraform-modules" 6 "docs-guardrails-v1" "Wave 0 platform guardrails baseline."
run_merge_and_tag "fintechbankx-platform-delivery-templates" 6 "docs-guardrails-v1" "Wave 0 platform guardrails baseline."
run_merge_and_tag "fintechbankx-platform-identity-keycloak-ldap" 6 "docs-guardrails-v1" "Wave 0 platform guardrails baseline."
run_merge_and_tag "fintechbankx-platform-service-mesh-security" 6 "docs-guardrails-v1" "Wave 0 platform guardrails baseline."
run_merge_and_tag "fintechbankx-platform-event-streaming" 6 "docs-guardrails-v1" "Wave 0 platform guardrails baseline."
run_merge_and_tag "fintechbankx-platform-observability-sre" 6 "docs-guardrails-v1" "Wave 0 platform guardrails baseline."

echo "Wave 1"
run_merge_and_tag "fintechbankx-openfinance-payee-verification-service" 8 "docs-guardrails-v2" "Wave 1 publication guardrails hardening."
run_merge_and_tag "fintechbankx-openfinance-open-products-catalog-service" 9 "docs-guardrails-v2" "Wave 1 publication guardrails hardening."
run_merge_and_tag "fintechbankx-openfinance-atm-directory-service" 9 "docs-guardrails-v2" "Wave 1 publication guardrails hardening."

echo "Wave 2"
run_merge_and_tag "fintechbankx-openfinance-consent-authorization-service" 8 "docs-guardrails-v2" "Wave 2 publication guardrails hardening."
run_merge_and_tag "fintechbankx-openfinance-personal-financial-data-service" 9 "docs-guardrails-v2" "Wave 2 publication guardrails hardening."
run_merge_and_tag "fintechbankx-openfinance-business-financial-data-service" 9 "docs-guardrails-v2" "Wave 2 publication guardrails hardening."
run_merge_and_tag "fintechbankx-openfinance-banking-metadata-service" 9 "docs-guardrails-v2" "Wave 2 publication guardrails hardening."

echo "Wave 3"
run_merge_and_tag "fintechbankx-payments-initiation-settlement-service" 10 "v0.3.2" "Guardrails and contract governance updates."
run_merge_and_tag "fintechbankx-lending-loan-lifecycle-service" 10 "v0.3.2" "Guardrails and contract governance updates."

echo "Wave 4"
run_merge_and_tag "fintechbankx-contracts-openapi-catalog" 8 "docs-guardrails-v2" "Wave 4 governance and contract catalog updates."
run_merge_and_tag "fintechbankx-customer-profile-kyc-service" 7 "docs-guardrails-v2" "Wave 4 publication guardrails hardening."
run_merge_and_tag "fintechbankx-risk-decisioning-service" 7 "docs-guardrails-v2" "Wave 4 publication guardrails hardening."
run_merge_and_tag "fintechbankx-compliance-evidence-service" 7 "docs-guardrails-v2" "Wave 4 publication guardrails hardening."
run_merge_and_tag "fintechbankx-enterprise-architecture" 6 "docs-guardrails-v2" "Transformation governance evidence and closure reports."

echo "Done."

