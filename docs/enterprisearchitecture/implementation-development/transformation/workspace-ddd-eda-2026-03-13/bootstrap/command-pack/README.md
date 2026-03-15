# Repo-Create Command Pack (GitHub and GitLab)

## Purpose

Generate and run repository-creation commands from:

`../repository-bootstrap-manifest.csv`

This command pack is non-destructive for existing runtime code. It only creates remote repositories/projects and applies baseline branch governance.

## Contents

1. `generate-repo-create-command-pack.mjs` - generates provider scripts from the CSV manifest.
2. `.env.github.example` - environment template for GitHub execution.
3. `.env.gitlab.example` - environment template for GitLab execution.
4. `generated/github/*.sh` - generated GitHub scripts.
5. `generated/gitlab/*.sh` - generated GitLab scripts.
6. `generated/run-by-wave.sh` - orchestrates Wave 0 -> Wave 4 execution order.

Generated provider scripts include:

1. create repositories/projects
2. harden branches (`main`, `dev`, `staging`)
3. seed repository skeleton (`domain/`, `application/`, `infrastructure/`, `tests/`, ownership metadata)

## Prerequisites

1. Node.js 20+.
2. `gh` CLI authenticated to the target organization.
3. `curl` and `jq`.
4. For GitLab: personal/group token with project admin permissions.

## Generation

From this folder:

```bash
node ./generate-repo-create-command-pack.mjs
```

## Execution - GitHub

```bash
cp .env.github.example .env.github
source .env.github

# 1) Dry-run create
DRY_RUN=true bash generated/github/create-repos.sh

# 2) Execute create
DRY_RUN=false bash generated/github/create-repos.sh

# 3) Dry-run hardening (branches/protection)
DRY_RUN=true bash generated/github/harden-branches.sh

# 4) Execute hardening
DRY_RUN=false bash generated/github/harden-branches.sh
```

### Wave orchestration (GitHub)

```bash
source .env.github
GITHUB_ORG="your-github-org" PROVIDER=github DRY_RUN=true bash generated/run-by-wave.sh
GITHUB_ORG="your-github-org" PROVIDER=github DRY_RUN=false bash generated/run-by-wave.sh
```

## Execution - GitLab

```bash
cp .env.gitlab.example .env.gitlab
source .env.gitlab

# 1) Dry-run create
DRY_RUN=true bash generated/gitlab/create-projects.sh

# 2) Execute create
DRY_RUN=false bash generated/gitlab/create-projects.sh

# 3) Dry-run hardening (branches/protection)
DRY_RUN=true bash generated/gitlab/harden-branches.sh

# 4) Execute hardening
DRY_RUN=false bash generated/gitlab/harden-branches.sh
```

### Wave orchestration (GitLab)

```bash
source .env.gitlab
export GITLAB_GROUP_PATH="your-group-or-subgroup-path"
PROVIDER=gitlab DRY_RUN=true bash generated/run-by-wave.sh
PROVIDER=gitlab DRY_RUN=false bash generated/run-by-wave.sh
```

### Custom wave selection

```bash
# Run only Wave 0 and Wave 1
PROVIDER=github DRY_RUN=true WAVES=0,1 bash generated/run-by-wave.sh

# Run create + harden only (skip seed)
PROVIDER=github DRY_RUN=true STEPS=create,harden bash generated/run-by-wave.sh

# Run seed only for Wave 2
PROVIDER=github DRY_RUN=true WAVES=2 STEPS=seed bash generated/run-by-wave.sh

# Run all waves against both providers (use with caution in non-dry-run)
PROVIDER=both DRY_RUN=true bash generated/run-by-wave.sh
```

## Notes

1. Scripts are idempotent where possible (skip existing repositories/projects/branches).
2. Branch model baseline: `main`, `dev`, `staging`.
3. Protection model baseline is intentionally strict and should be tuned per organization policy.
4. Seed scripts overwrite baseline metadata files (`README.md`, `OWNERSHIP.yaml`, `CODEOWNERS`, layer README files) on first bootstrap intent.
