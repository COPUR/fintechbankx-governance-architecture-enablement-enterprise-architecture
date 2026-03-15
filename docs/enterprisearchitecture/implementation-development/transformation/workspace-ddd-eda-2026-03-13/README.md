# Transformation Workspace (DDD + EDA) - 2026-03-13

## Purpose

This workspace starts the repository-split transformation in a **non-destructive mode**:

1. Original files are copied into `copied/`.
2. New standards and execution artifacts are created in this workspace.
3. No original planning files are edited in this phase.

## Copied Source Artifacts

From `docs/enterprisearchitecture/implementation-development/transformation/`:

1. `PHASE_1_ANALYSIS_AND_GOVERNANCE.md`
2. `PHASE_2_TEMPLATE_AND_REPO_SETUP.md`
3. `PHASE_3_CICD_AUTOMATION.md`
4. `PHASE_4_TERRAFORM_AND_DEPLOYMENT.md`

From `docs/enterprisearchitecture/implementation-development/transformation/outputs/`:

1. `spotify-squad-to-be-repository-plan.md`
2. `repository-creation-backlog-by-squad.md`
3. `pr-ready-backlog-by-team.md`
4. `github-milestone-map.md`

## Transformation Start Outputs

1. `NAMING_CONVENTION_DDD_EDA_BUSINESS_CONTEXT.md`
2. `bootstrap/repository-bootstrap-manifest.md`
3. `bootstrap/repository-bootstrap-manifest.csv`
4. `bootstrap/transformation-kickoff-checklist.md`
5. `bootstrap/command-pack/README.md`
6. `bootstrap/command-pack/generate-repo-create-command-pack.mjs`
7. `bootstrap/command-pack/generated/*`

## Execution Policy

1. Contract-first naming and ownership before repo creation.
2. One bounded context per service repository.
3. One data owner per schema/database.
4. Event versioning and schema governance from day one.
