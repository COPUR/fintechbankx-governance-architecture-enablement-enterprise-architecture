#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const manifestPath = path.resolve(__dirname, "..", "repository-bootstrap-manifest.csv");
const outputRoot = path.resolve(__dirname, "generated");
const githubDir = path.join(outputRoot, "github");
const gitlabDir = path.join(outputRoot, "gitlab");

function parseCsv(content) {
  const lines = content
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line.length > 0);
  if (lines.length < 2) return [];
  const headers = lines[0].split(",").map((h) => h.trim());
  return lines.slice(1).map((line) => {
    const cells = line.split(",").map((c) => c.trim());
    const obj = {};
    for (let i = 0; i < headers.length; i += 1) {
      obj[headers[i]] = cells[i] ?? "";
    }
    return obj;
  });
}

function shSingleQuote(value) {
  return `'${String(value).replace(/'/g, `'\"'\"'`)}'`;
}

function recordsArray(rows) {
  return rows
    .map(
      (r) =>
        `  ${shSingleQuote(`${r.repo}|${r.context}|${r.service_id}|${r.owning_squad}|${r.wave}`)}`
    )
    .join("\n");
}

function seedRecordsArray(rows) {
  return rows
    .map(
      (r) =>
        `  ${shSingleQuote(
          `${r.repo}|${r.context}|${r.service_id}|${r.app_id}|${r.db_prod_pattern}|${r.event_namespace}|${r.owning_squad}|${r.wave}`
        )}`
    )
    .join("\n");
}

function createGithubCreateScript(rows) {
  return `#!/usr/bin/env bash
set -euo pipefail

: "\${GITHUB_ORG:?Set GITHUB_ORG, for example: export GITHUB_ORG=my-org}"
VISIBILITY="\${VISIBILITY:-private}"
DRY_RUN="\${DRY_RUN:-true}"
WAVE_FILTER="\${WAVE_FILTER:-all}"

RECORDS=(
${recordsArray(rows)}
)

run() {
  if [[ "\${DRY_RUN}" == "true" ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    echo
    return 0
  fi
  "$@"
}

should_process_wave() {
  local wave="$1"
  if [[ "\${WAVE_FILTER}" == "all" ]]; then
    return 0
  fi
  IFS=',' read -r -a allowed <<< "\${WAVE_FILTER}"
  for candidate in "\${allowed[@]}"; do
    if [[ "\${candidate}" == "\${wave}" ]]; then
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
  local full_repo="\${GITHUB_ORG}/\${repo}"

  if [[ "\${DRY_RUN}" == "true" ]]; then
    local description
    description="DDD/EDA \${context} capability (\${service_id}) owner:\${owning_squad} wave:\${wave}"
    run gh repo create "$full_repo" --"\${VISIBILITY}" --description "$description" --add-readme --disable-wiki
    return 0
  fi

  if repo_exists "$full_repo"; then
    echo "[skip] exists: $full_repo"
    return 0
  fi

  local description
  description="DDD/EDA \${context} capability (\${service_id}) owner:\${owning_squad} wave:\${wave}"

  run gh repo create "$full_repo" --"\${VISIBILITY}" --description "$description" --add-readme --disable-wiki
}

for rec in "\${RECORDS[@]}"; do
  IFS='|' read -r repo context service_id owning_squad wave <<<"$rec"
  if ! should_process_wave "\${wave}"; then
    continue
  fi
  create_repo "$repo" "$context" "$service_id" "$owning_squad" "$wave"
done

echo "[done] GitHub repository creation pass completed."
`;
}

function createGithubHardenScript(rows) {
  return `#!/usr/bin/env bash
set -euo pipefail

: "\${GITHUB_ORG:?Set GITHUB_ORG, for example: export GITHUB_ORG=my-org}"
DRY_RUN="\${DRY_RUN:-true}"
REQUIRED_CHECKS="\${REQUIRED_CHECKS:-ci/build,ci/test,ci/security}"
WAVE_FILTER="\${WAVE_FILTER:-all}"

IFS=',' read -r -a CHECKS <<< "\${REQUIRED_CHECKS}"

RECORDS=(
${recordsArray(rows)}
)

run() {
  if [[ "\${DRY_RUN}" == "true" ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    echo
    return 0
  fi
  "$@"
}

should_process_wave() {
  local wave="$1"
  if [[ "\${WAVE_FILTER}" == "all" ]]; then
    return 0
  fi
  IFS=',' read -r -a allowed <<< "\${WAVE_FILTER}"
  for candidate in "\${allowed[@]}"; do
    if [[ "\${candidate}" == "\${wave}" ]]; then
      return 0
    fi
  done
  return 1
}

ensure_branch() {
  local repo="$1"
  local branch="$2"
  local ref_url="repos/\${GITHUB_ORG}/\${repo}/git/ref/heads/\${branch}"
  local main_ref_url="repos/\${GITHUB_ORG}/\${repo}/git/ref/heads/main"

  if [[ "\${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] ensure branch: \${GITHUB_ORG}/\${repo}@\${branch} (from main)"
    return 0
  fi

  if gh api "$ref_url" >/dev/null 2>&1; then
    echo "[skip] branch exists: \${GITHUB_ORG}/\${repo}@\${branch}"
    return 0
  fi

  local sha
  sha="$(gh api "$main_ref_url" --jq '.object.sha')"
  run gh api -X POST "repos/\${GITHUB_ORG}/\${repo}/git/refs" -f ref="refs/heads/\${branch}" -f sha="\${sha}" >/dev/null
  echo "[ok] branch ensured: \${GITHUB_ORG}/\${repo}@\${branch}"
}

protect_branch() {
  local repo="$1"
  local branch="$2"
  local approvals="$3"

  if [[ "\${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] protect branch: \${GITHUB_ORG}/\${repo}@\${branch} approvals=\${approvals} checks=\${REQUIRED_CHECKS}"
    return 0
  fi

  local contexts_json
  contexts_json="$(printf '%s\\n' "\${CHECKS[@]}" | jq -R . | jq -s .)"

  jq -n \
    --argjson contexts "$contexts_json" \
    --argjson approvals "$approvals" \
    '{
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
    }' | gh api -X PUT "repos/\${GITHUB_ORG}/\${repo}/branches/\${branch}/protection" --input - >/dev/null
  echo "[ok] branch protected: \${GITHUB_ORG}/\${repo}@\${branch}"
}

for rec in "\${RECORDS[@]}"; do
  IFS='|' read -r repo _context _service_id _owning_squad wave <<<"$rec"
  if ! should_process_wave "\${wave}"; then
    continue
  fi
  ensure_branch "$repo" "dev"
  ensure_branch "$repo" "staging"
  protect_branch "$repo" "main" 2
  protect_branch "$repo" "dev" 1
  protect_branch "$repo" "staging" 1
done

echo "[done] GitHub branch hardening pass completed."
`;
}

function createGitlabCreateScript(rows) {
  return `#!/usr/bin/env bash
set -euo pipefail

GITLAB_HOST="\${GITLAB_HOST:-https://gitlab.com}"
GITLAB_TOKEN="\${GITLAB_TOKEN:-}"
GITLAB_NAMESPACE_ID="\${GITLAB_NAMESPACE_ID:-}"
VISIBILITY="\${VISIBILITY:-private}"
DRY_RUN="\${DRY_RUN:-true}"
WAVE_FILTER="\${WAVE_FILTER:-all}"

RECORDS=(
${recordsArray(rows)}
)

api_get() {
  local url="$1"
  curl -sS --header "PRIVATE-TOKEN: \${GITLAB_TOKEN}" "$url"
}

api_post() {
  local url="$1"
  shift
  curl -sS --request POST --header "PRIVATE-TOKEN: \${GITLAB_TOKEN}" "$url" "$@"
}

should_process_wave() {
  local wave="$1"
  if [[ "\${WAVE_FILTER}" == "all" ]]; then
    return 0
  fi
  IFS=',' read -r -a allowed <<< "\${WAVE_FILTER}"
  for candidate in "\${allowed[@]}"; do
    if [[ "\${candidate}" == "\${wave}" ]]; then
      return 0
    fi
  done
  return 1
}

project_id_from_group_search() {
  local repo="$1"
  api_get "\${GITLAB_HOST}/api/v4/groups/\${GITLAB_NAMESPACE_ID}/projects?per_page=100&search=\${repo}" | \
    jq -r --arg repo "$repo" '.[] | select(.path == $repo) | .id' | head -n1
}

create_project() {
  local repo="$1"
  local context="$2"
  local service_id="$3"
  local owning_squad="$4"
  local wave="$5"

  if [[ "\${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] create project: \${repo} namespace_id=\${GITLAB_NAMESPACE_ID:-<set>}"
    return 0
  fi

  local existing_id
  existing_id="$(project_id_from_group_search "$repo" || true)"
  if [[ -n "\${existing_id}" ]]; then
    echo "[skip] exists: \${repo} (id=\${existing_id})"
    return 0
  fi

  local description
  description="DDD/EDA \${context} capability (\${service_id}) owner:\${owning_squad} wave:\${wave}"

  : "\${GITLAB_TOKEN:?Set GITLAB_TOKEN}"
  : "\${GITLAB_NAMESPACE_ID:?Set GITLAB_NAMESPACE_ID (numeric group ID)}"

  api_post "\${GITLAB_HOST}/api/v4/projects" \
    --data-urlencode "name=\${repo}" \
    --data-urlencode "path=\${repo}" \
    --data-urlencode "namespace_id=\${GITLAB_NAMESPACE_ID}" \
    --data-urlencode "visibility=\${VISIBILITY}" \
    --data-urlencode "initialize_with_readme=true" \
    --data-urlencode "default_branch=main" \
    --data-urlencode "description=\${description}" >/dev/null

  echo "[ok] created: \${repo}"
}

for rec in "\${RECORDS[@]}"; do
  IFS='|' read -r repo context service_id owning_squad wave <<<"$rec"
  if ! should_process_wave "\${wave}"; then
    continue
  fi
  create_project "$repo" "$context" "$service_id" "$owning_squad" "$wave"
done

echo "[done] GitLab project creation pass completed."
`;
}

function createGitlabHardenScript(rows) {
  return `#!/usr/bin/env bash
set -euo pipefail

GITLAB_HOST="\${GITLAB_HOST:-https://gitlab.com}"
GITLAB_TOKEN="\${GITLAB_TOKEN:-}"
GITLAB_NAMESPACE_ID="\${GITLAB_NAMESPACE_ID:-}"
DRY_RUN="\${DRY_RUN:-true}"
WAVE_FILTER="\${WAVE_FILTER:-all}"

RECORDS=(
${recordsArray(rows)}
)

api_get() {
  local url="$1"
  curl -sS --header "PRIVATE-TOKEN: \${GITLAB_TOKEN}" "$url"
}

api_post() {
  local url="$1"
  shift
  curl -sS --request POST --header "PRIVATE-TOKEN: \${GITLAB_TOKEN}" "$url" "$@" >/dev/null
}

should_process_wave() {
  local wave="$1"
  if [[ "\${WAVE_FILTER}" == "all" ]]; then
    return 0
  fi
  IFS=',' read -r -a allowed <<< "\${WAVE_FILTER}"
  for candidate in "\${allowed[@]}"; do
    if [[ "\${candidate}" == "\${wave}" ]]; then
      return 0
    fi
  done
  return 1
}

project_id_from_group_search() {
  local repo="$1"
  api_get "\${GITLAB_HOST}/api/v4/groups/\${GITLAB_NAMESPACE_ID}/projects?per_page=100&search=\${repo}" | \
    jq -r --arg repo "$repo" '.[] | select(.path == $repo) | .id' | head -n1
}

ensure_branch() {
  local project_id="$1"
  local branch="$2"
  local existing
  existing="$(api_get "\${GITLAB_HOST}/api/v4/projects/\${project_id}/repository/branches/\${branch}" | jq -r '.name // empty')"
  if [[ -n "\${existing}" ]]; then
    echo "[skip] branch exists: project=\${project_id} branch=\${branch}"
    return 0
  fi

  if [[ "\${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] create branch: project=\${project_id} branch=\${branch} ref=main"
    return 0
  fi

  api_post "\${GITLAB_HOST}/api/v4/projects/\${project_id}/repository/branches" \
    --data-urlencode "branch=\${branch}" \
    --data-urlencode "ref=main"
}

protect_branch() {
  local project_id="$1"
  local branch="$2"

  if [[ "\${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] protect branch: project=\${project_id} branch=\${branch}"
    return 0
  fi

  # If already protected, GitLab returns conflict; ignore.
  api_post "\${GITLAB_HOST}/api/v4/projects/\${project_id}/protected_branches" \
    --data-urlencode "name=\${branch}" \
    --data-urlencode "push_access_level=0" \
    --data-urlencode "merge_access_level=40" \
    --data-urlencode "unprotect_access_level=40" || true
}

for rec in "\${RECORDS[@]}"; do
  IFS='|' read -r repo _context _service_id _owning_squad wave <<<"$rec"
  if ! should_process_wave "\${wave}"; then
    continue
  fi
  if [[ "\${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] ensure branches/protection for \${repo} (main/dev/staging)"
    continue
  fi
  : "\${GITLAB_TOKEN:?Set GITLAB_TOKEN}"
  : "\${GITLAB_NAMESPACE_ID:?Set GITLAB_NAMESPACE_ID (numeric group ID)}"
  project_id="$(project_id_from_group_search "$repo" || true)"
  if [[ -z "\${project_id}" ]]; then
    echo "[warn] project not found, skipping hardening: \${repo}"
    continue
  fi
  ensure_branch "$project_id" "dev"
  ensure_branch "$project_id" "staging"
  protect_branch "$project_id" "main"
  protect_branch "$project_id" "dev"
  protect_branch "$project_id" "staging"
done

echo "[done] GitLab branch hardening pass completed."
`;
}

function createGithubSeedScript(rows) {
  return `#!/usr/bin/env bash
set -euo pipefail

: "\${GITHUB_ORG:?Set GITHUB_ORG, for example: export GITHUB_ORG=my-org}"
DRY_RUN="\${DRY_RUN:-true}"
WAVE_FILTER="\${WAVE_FILTER:-all}"
WORK_DIR="\${WORK_DIR:-/tmp/repo-bootstrap/github}"
PUSH_CHANGES="\${PUSH_CHANGES:-false}"
BASE_BRANCH="\${BASE_BRANCH:-main}"
SEED_BRANCH="\${SEED_BRANCH:-bootstrap/initial-structure}"
CREATE_PR="\${CREATE_PR:-false}"
GIT_REMOTE_PROTOCOL="\${GIT_REMOTE_PROTOCOL:-ssh}"   # ssh | https
DEFAULT_CODEOWNER="\${DEFAULT_CODEOWNER:-@architecture-team}"

RECORDS=(
${seedRecordsArray(rows)}
)

should_process_wave() {
  local wave="$1"
  if [[ "\${WAVE_FILTER}" == "all" ]]; then
    return 0
  fi
  IFS=',' read -r -a allowed <<< "\${WAVE_FILTER}"
  for candidate in "\${allowed[@]}"; do
    if [[ "\${candidate}" == "\${wave}" ]]; then
      return 0
    fi
  done
  return 1
}

repo_url() {
  local repo="$1"
  if [[ "\${GIT_REMOTE_PROTOCOL}" == "https" ]]; then
    echo "https://github.com/\${GITHUB_ORG}/\${repo}.git"
  else
    echo "git@github.com:\${GITHUB_ORG}/\${repo}.git"
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
  url="$(repo_url "\${repo}")"
  local target_dir="\${WORK_DIR}/\${repo}"

  if [[ "\${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] seed repo: \${repo} wave=\${wave} url=\${url}"
    return 0
  fi

  mkdir -p "\${WORK_DIR}"
  if [[ -d "\${target_dir}/.git" ]]; then
    git -C "\${target_dir}" fetch origin
    git -C "\${target_dir}" checkout "\${BASE_BRANCH}"
    git -C "\${target_dir}" pull --ff-only origin "\${BASE_BRANCH}"
  else
    git clone "\${url}" "\${target_dir}"
    git -C "\${target_dir}" checkout "\${BASE_BRANCH}"
  fi
  git -C "\${target_dir}" checkout -B "\${SEED_BRANCH}" "origin/\${BASE_BRANCH}"

  mkdir -p "\${target_dir}/domain" "\${target_dir}/application" "\${target_dir}/infrastructure" "\${target_dir}/tests" "\${target_dir}/docs" "\${target_dir}/.github"

  cat > "\${target_dir}/README.md" <<EOF
# \${repo}

## Ownership Metadata

- Bounded context: \${context}
- Service ID: \${service_id}
- Application ID: \${app_id}
- Data owner pattern: \${db_pattern}
- Event namespace: \${event_ns}
- Owning squad: \${owning_squad}
- Wave: \${wave}
EOF

  cat > "\${target_dir}/OWNERSHIP.yaml" <<EOF
bounded_context: "\${context}"
service_id: "\${service_id}"
application_id: "\${app_id}"
data_owner_pattern: "\${db_pattern}"
event_namespace: "\${event_ns}"
owning_squad: "\${owning_squad}"
wave: "\${wave}"
EOF

  cat > "\${target_dir}/CODEOWNERS" <<EOF
* \${DEFAULT_CODEOWNER}
EOF

  cat > "\${target_dir}/domain/README.md" <<EOF
# Domain Layer

Pure domain model (entities, aggregates, value objects, domain services).
EOF

  cat > "\${target_dir}/application/README.md" <<EOF
# Application Layer

Use cases, orchestration, ports, and inbound command/query handlers.
EOF

  cat > "\${target_dir}/infrastructure/README.md" <<EOF
# Infrastructure Layer

Adapters for persistence, messaging, web, and external integrations.
EOF

  cat > "\${target_dir}/tests/README.md" <<EOF
# Test Layer

Unit, integration, contract, and end-to-end test strategy and suites.
EOF

  cat > "\${target_dir}/docs/README.md" <<EOF
# Service Documentation

Service-specific ADRs, API/event contracts, and operational runbooks.
EOF

  cat > "\${target_dir}/.gitignore" <<EOF
.idea/
.vscode/
.gradle/
build/
out/
node_modules/
.DS_Store
EOF

  if git -C "\${target_dir}" diff --quiet && git -C "\${target_dir}" diff --cached --quiet; then
    echo "[skip] no changes detected: \${repo}"
    return 0
  fi

  git -C "\${target_dir}" add .
  if git -C "\${target_dir}" diff --cached --quiet; then
    echo "[skip] no staged changes: \${repo}"
    return 0
  fi

  git -C "\${target_dir}" commit -m "chore(bootstrap): initialize DDD/EDA skeleton and ownership metadata"
  if [[ "\${PUSH_CHANGES}" == "true" ]]; then
    git -C "\${target_dir}" push -u origin "\${SEED_BRANCH}" --force-with-lease
    echo "[ok] pushed seed branch: \${repo}@\${SEED_BRANCH}"
    if [[ "\${CREATE_PR}" == "true" ]]; then
      gh pr create \
        --repo "\${GITHUB_ORG}/\${repo}" \
        --base "\${BASE_BRANCH}" \
        --head "\${SEED_BRANCH}" \
        --title "chore(bootstrap): initialize DDD/EDA skeleton" \
        --body "Automated bootstrap for DDD/EDA repository skeleton and ownership metadata." >/dev/null || true
      echo "[ok] pull request ensured: \${GITHUB_ORG}/\${repo} (\${SEED_BRANCH} -> \${BASE_BRANCH})"
    fi
  else
    echo "[info] seed commit created locally (not pushed): \${repo}"
  fi
}

for rec in "\${RECORDS[@]}"; do
  IFS='|' read -r repo context service_id app_id db_pattern event_ns owning_squad wave <<<"$rec"
  if ! should_process_wave "\${wave}"; then
    continue
  fi
  seed_repo "\${repo}" "\${context}" "\${service_id}" "\${app_id}" "\${db_pattern}" "\${event_ns}" "\${owning_squad}" "\${wave}"
done

echo "[done] GitHub seed pass completed."
`;
}

function createGitlabSeedScript(rows) {
  return `#!/usr/bin/env bash
set -euo pipefail

GITLAB_HOST="\${GITLAB_HOST:-https://gitlab.com}"
: "\${GITLAB_GROUP_PATH:?Set GITLAB_GROUP_PATH, for example: my-org/platform}"
DRY_RUN="\${DRY_RUN:-true}"
WAVE_FILTER="\${WAVE_FILTER:-all}"
WORK_DIR="\${WORK_DIR:-/tmp/repo-bootstrap/gitlab}"
PUSH_CHANGES="\${PUSH_CHANGES:-false}"
BASE_BRANCH="\${BASE_BRANCH:-main}"
SEED_BRANCH="\${SEED_BRANCH:-bootstrap/initial-structure}"
CREATE_MR="\${CREATE_MR:-false}"
GIT_REMOTE_PROTOCOL="\${GIT_REMOTE_PROTOCOL:-ssh}"   # ssh | https
DEFAULT_CODEOWNER="\${DEFAULT_CODEOWNER:-@architecture-team}"

RECORDS=(
${seedRecordsArray(rows)}
)

should_process_wave() {
  local wave="$1"
  if [[ "\${WAVE_FILTER}" == "all" ]]; then
    return 0
  fi
  IFS=',' read -r -a allowed <<< "\${WAVE_FILTER}"
  for candidate in "\${allowed[@]}"; do
    if [[ "\${candidate}" == "\${wave}" ]]; then
      return 0
    fi
  done
  return 1
}

repo_url() {
  local repo="$1"
  local host_no_scheme
  host_no_scheme="$(echo "\${GITLAB_HOST}" | sed -E 's#^https?://##')"
  if [[ "\${GIT_REMOTE_PROTOCOL}" == "https" ]]; then
    echo "https://\${host_no_scheme}/\${GITLAB_GROUP_PATH}/\${repo}.git"
  else
    echo "git@\${host_no_scheme}:\${GITLAB_GROUP_PATH}/\${repo}.git"
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
  url="$(repo_url "\${repo}")"
  local target_dir="\${WORK_DIR}/\${repo}"

  if [[ "\${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] seed project: \${repo} wave=\${wave} url=\${url}"
    return 0
  fi

  mkdir -p "\${WORK_DIR}"
  if [[ -d "\${target_dir}/.git" ]]; then
    git -C "\${target_dir}" fetch origin
    git -C "\${target_dir}" checkout "\${BASE_BRANCH}"
    git -C "\${target_dir}" pull --ff-only origin "\${BASE_BRANCH}"
  else
    git clone "\${url}" "\${target_dir}"
    git -C "\${target_dir}" checkout "\${BASE_BRANCH}"
  fi
  git -C "\${target_dir}" checkout -B "\${SEED_BRANCH}" "origin/\${BASE_BRANCH}"

  mkdir -p "\${target_dir}/domain" "\${target_dir}/application" "\${target_dir}/infrastructure" "\${target_dir}/tests" "\${target_dir}/docs" "\${target_dir}/.github"

  cat > "\${target_dir}/README.md" <<EOF
# \${repo}

## Ownership Metadata

- Bounded context: \${context}
- Service ID: \${service_id}
- Application ID: \${app_id}
- Data owner pattern: \${db_pattern}
- Event namespace: \${event_ns}
- Owning squad: \${owning_squad}
- Wave: \${wave}
EOF

  cat > "\${target_dir}/OWNERSHIP.yaml" <<EOF
bounded_context: "\${context}"
service_id: "\${service_id}"
application_id: "\${app_id}"
data_owner_pattern: "\${db_pattern}"
event_namespace: "\${event_ns}"
owning_squad: "\${owning_squad}"
wave: "\${wave}"
EOF

  cat > "\${target_dir}/CODEOWNERS" <<EOF
* \${DEFAULT_CODEOWNER}
EOF

  cat > "\${target_dir}/domain/README.md" <<EOF
# Domain Layer

Pure domain model (entities, aggregates, value objects, domain services).
EOF

  cat > "\${target_dir}/application/README.md" <<EOF
# Application Layer

Use cases, orchestration, ports, and inbound command/query handlers.
EOF

  cat > "\${target_dir}/infrastructure/README.md" <<EOF
# Infrastructure Layer

Adapters for persistence, messaging, web, and external integrations.
EOF

  cat > "\${target_dir}/tests/README.md" <<EOF
# Test Layer

Unit, integration, contract, and end-to-end test strategy and suites.
EOF

  cat > "\${target_dir}/docs/README.md" <<EOF
# Service Documentation

Service-specific ADRs, API/event contracts, and operational runbooks.
EOF

  cat > "\${target_dir}/.gitignore" <<EOF
.idea/
.vscode/
.gradle/
build/
out/
node_modules/
.DS_Store
EOF

  if git -C "\${target_dir}" diff --quiet && git -C "\${target_dir}" diff --cached --quiet; then
    echo "[skip] no changes detected: \${repo}"
    return 0
  fi

  git -C "\${target_dir}" add .
  if git -C "\${target_dir}" diff --cached --quiet; then
    echo "[skip] no staged changes: \${repo}"
    return 0
  fi

  git -C "\${target_dir}" commit -m "chore(bootstrap): initialize DDD/EDA skeleton and ownership metadata"
  if [[ "\${PUSH_CHANGES}" == "true" ]]; then
    git -C "\${target_dir}" push -u origin "\${SEED_BRANCH}" --force-with-lease
    echo "[ok] pushed seed branch: \${repo}@\${SEED_BRANCH}"
    if [[ "\${CREATE_MR}" == "true" ]] && command -v glab >/dev/null 2>&1; then
      glab mr create \
        --repo "\${GITLAB_GROUP_PATH}/\${repo}" \
        --source-branch "\${SEED_BRANCH}" \
        --target-branch "\${BASE_BRANCH}" \
        --title "chore(bootstrap): initialize DDD/EDA skeleton" \
        --description "Automated bootstrap for DDD/EDA repository skeleton and ownership metadata." >/dev/null || true
      echo "[ok] merge request ensured: \${GITLAB_GROUP_PATH}/\${repo} (\${SEED_BRANCH} -> \${BASE_BRANCH})"
    fi
  else
    echo "[info] seed commit created locally (not pushed): \${repo}"
  fi
}

for rec in "\${RECORDS[@]}"; do
  IFS='|' read -r repo context service_id app_id db_pattern event_ns owning_squad wave <<<"$rec"
  if ! should_process_wave "\${wave}"; then
    continue
  fi
  seed_repo "\${repo}" "\${context}" "\${service_id}" "\${app_id}" "\${db_pattern}" "\${event_ns}" "\${owning_squad}" "\${wave}"
done

echo "[done] GitLab seed pass completed."
`;
}

function createWaveOrchestratorScript() {
  return `#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
PROVIDER="\${PROVIDER:-github}"    # github | gitlab | both
DRY_RUN="\${DRY_RUN:-true}"         # true | false
WAVES="\${WAVES:-0,1,2,3,4}"        # comma-separated execution order
STEPS="\${STEPS:-create,harden,seed}" # create | harden | seed

IFS=',' read -r -a wave_list <<< "\${WAVES}"
IFS=',' read -r -a step_list <<< "\${STEPS}"

has_step() {
  local expected="$1"
  for s in "\${step_list[@]}"; do
    if [[ "\${s}" == "\${expected}" ]]; then
      return 0
    fi
  done
  return 1
}

run_wave_github() {
  local wave="$1"
  echo "[phase] provider=github wave=\${wave} dry_run=\${DRY_RUN}"
  if has_step "create"; then
    WAVE_FILTER="\${wave}" DRY_RUN="\${DRY_RUN}" bash "\${SCRIPT_DIR}/github/create-repos.sh"
  fi
  if has_step "harden"; then
    WAVE_FILTER="\${wave}" DRY_RUN="\${DRY_RUN}" bash "\${SCRIPT_DIR}/github/harden-branches.sh"
  fi
  if has_step "seed"; then
    WAVE_FILTER="\${wave}" DRY_RUN="\${DRY_RUN}" bash "\${SCRIPT_DIR}/github/seed-repos.sh"
  fi
}

run_wave_gitlab() {
  local wave="$1"
  echo "[phase] provider=gitlab wave=\${wave} dry_run=\${DRY_RUN}"
  if has_step "create"; then
    WAVE_FILTER="\${wave}" DRY_RUN="\${DRY_RUN}" bash "\${SCRIPT_DIR}/gitlab/create-projects.sh"
  fi
  if has_step "harden"; then
    WAVE_FILTER="\${wave}" DRY_RUN="\${DRY_RUN}" bash "\${SCRIPT_DIR}/gitlab/harden-branches.sh"
  fi
  if has_step "seed"; then
    WAVE_FILTER="\${wave}" DRY_RUN="\${DRY_RUN}" bash "\${SCRIPT_DIR}/gitlab/seed-projects.sh"
  fi
}

for wave in "\${wave_list[@]}"; do
  case "\${PROVIDER}" in
    github)
      run_wave_github "\${wave}"
      ;;
    gitlab)
      run_wave_gitlab "\${wave}"
      ;;
    both)
      run_wave_github "\${wave}"
      run_wave_gitlab "\${wave}"
      ;;
    *)
      echo "[error] Unsupported PROVIDER=\${PROVIDER}. Use github, gitlab, or both."
      exit 1
      ;;
  esac
done

echo "[done] Wave execution complete for provider=\${PROVIDER}, waves=\${WAVES}, steps=\${STEPS}."
`;
}

function writeExecutable(filePath, content) {
  fs.writeFileSync(filePath, content, "utf8");
  fs.chmodSync(filePath, 0o755);
}

function main() {
  if (!fs.existsSync(manifestPath)) {
    throw new Error(`Manifest not found: ${manifestPath}`);
  }
  const rows = parseCsv(fs.readFileSync(manifestPath, "utf8"));
  if (rows.length === 0) {
    throw new Error("Manifest is empty.");
  }

  fs.mkdirSync(githubDir, { recursive: true });
  fs.mkdirSync(gitlabDir, { recursive: true });

  writeExecutable(path.join(githubDir, "create-repos.sh"), createGithubCreateScript(rows));
  writeExecutable(path.join(githubDir, "harden-branches.sh"), createGithubHardenScript(rows));
  writeExecutable(path.join(githubDir, "seed-repos.sh"), createGithubSeedScript(rows));
  writeExecutable(path.join(gitlabDir, "create-projects.sh"), createGitlabCreateScript(rows));
  writeExecutable(path.join(gitlabDir, "harden-branches.sh"), createGitlabHardenScript(rows));
  writeExecutable(path.join(gitlabDir, "seed-projects.sh"), createGitlabSeedScript(rows));
  writeExecutable(path.join(outputRoot, "run-by-wave.sh"), createWaveOrchestratorScript());

  const summary = [
    "# Generated Command Pack Summary",
    "",
    `Generated at: ${new Date().toISOString()}`,
    `Manifest: ${manifestPath}`,
    `Repositories: ${rows.length}`,
    "",
    "## Files",
    "",
    "- generated/github/create-repos.sh",
    "- generated/github/harden-branches.sh",
    "- generated/github/seed-repos.sh",
    "- generated/gitlab/create-projects.sh",
    "- generated/gitlab/harden-branches.sh",
    "- generated/gitlab/seed-projects.sh",
    "- generated/run-by-wave.sh",
    ""
  ].join("\n");
  fs.writeFileSync(path.join(outputRoot, "SUMMARY.md"), summary, "utf8");

  console.log(`[ok] Command pack generated for ${rows.length} repositories.`);
}

main();
