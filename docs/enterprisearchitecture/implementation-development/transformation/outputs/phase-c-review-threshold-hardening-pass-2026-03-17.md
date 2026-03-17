# Phase C Review Threshold Hardening Pass (2026-03-17)

## Objective
Automatically enforce `required_approving_review_count=2` only when a repository has at least 2 write-capable maintainers, otherwise keep it at `1` to preserve operability.

## Execution Logic
For each `fintechbankx-*` repository:
1. Count collaborators with `permissions.push=true`.
2. Set target threshold:
   - `2` if writers >= 2
   - `1` if writers < 2
3. Apply with deterministic flow:
   - remove existing `required_pull_request_reviews`
   - recreate with target threshold
4. Verify final value.

## Outcome Summary
- Total repositories scanned: **26**
- Repositories eligible for threshold `2`: **0**
- Repositories kept at threshold `1`: **26**
- Repositories that changed during this pass: **6**

## Repositories Updated in This Pass
- `fintechbankx-contracts-asyncapi-catalog` (`2 -> 1`)
- `fintechbankx-contracts-schema-registry` (`2 -> 1`)
- `fintechbankx-governance-architecture-adr-runbooks` (`2 -> 1`)
- `fintechbankx-payments-bulk-orchestration-service` (`2 -> 1`)
- `fintechbankx-payments-recurring-mandates-service` (`2 -> 1`)
- `fintechbankx-payments-request-to-pay-service` (`2 -> 1`)

## Notes
- No repo currently has 2 write-capable maintainers; therefore no repo can safely enforce threshold `2` without creating a merge deadlock.
- This pass aligns policy with current staffing while preserving branch protection and required checks.

## Recommended Follow-up
1. Add at least one additional write maintainer per repo.
2. Re-run this hardening pass to automatically elevate eligible repos to threshold `2`.

