# Transformation Kickoff Checklist (Non-Destructive Start)

## Goal

Start repository transformation without changing existing runtime modules.

## Phase 0 - Completed in this workspace

- [x] Copied baseline planning artifacts into isolated workspace
- [x] Created DDD + EDA naming convention standard
- [x] Created repository bootstrap manifest (md + csv)

## Phase 1 - Next executable steps

1. Create remote repositories using `repository-bootstrap-manifest.csv`.
2. Apply standard branch model for new repos:
   - `main`
   - `dev`
   - `staging`
3. Apply branch protection and mandatory checks:
   - test
   - coverage
   - sast/sca
   - contract validation
4. Seed each repo with the same folder skeleton:
   - `domain/`
   - `application/`
   - `infrastructure/`
   - `tests/`
5. Publish ownership metadata in each new repo:
   - `README` ownership section
   - `CODEOWNERS`
   - `OWNERSHIP.yaml`

## Phase 2 - Contract baseline

1. For each service repo, add OpenAPI contracts to `fintechbankx-contracts-openapi-catalog`.
2. For each event producer/consumer, add AsyncAPI contracts to `fintechbankx-contracts-asyncapi-catalog`.
3. Add schema compatibility gates via `fintechbankx-contracts-schema-registry`.

## Phase 3 - Extraction readiness (still non-destructive)

1. Produce code ownership map for source-to-target repo extraction.
2. Define migration runbook per bounded context.
3. Define rollback criteria and dual-run observability requirements.

## Exit Criteria for Kickoff

1. Naming convention approved by Architecture Board.
2. Repo manifest approved by tribe leads.
3. Platform squads confirm template and branch policy readiness.
4. Contract governance squads approve publication workflow.
