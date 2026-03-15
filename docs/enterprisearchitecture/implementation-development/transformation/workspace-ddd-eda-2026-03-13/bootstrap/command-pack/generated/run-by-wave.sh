#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROVIDER="${PROVIDER:-github}"    # github | gitlab | both
DRY_RUN="${DRY_RUN:-true}"         # true | false
WAVES="${WAVES:-0,1,2,3,4}"        # comma-separated execution order
STEPS="${STEPS:-create,harden,seed}" # create | harden | seed

IFS=',' read -r -a wave_list <<< "${WAVES}"
IFS=',' read -r -a step_list <<< "${STEPS}"

has_step() {
  local expected="$1"
  for s in "${step_list[@]}"; do
    if [[ "${s}" == "${expected}" ]]; then
      return 0
    fi
  done
  return 1
}

run_wave_github() {
  local wave="$1"
  echo "[phase] provider=github wave=${wave} dry_run=${DRY_RUN}"
  if has_step "create"; then
    WAVE_FILTER="${wave}" DRY_RUN="${DRY_RUN}" bash "${SCRIPT_DIR}/github/create-repos.sh"
  fi
  if has_step "harden"; then
    WAVE_FILTER="${wave}" DRY_RUN="${DRY_RUN}" bash "${SCRIPT_DIR}/github/harden-branches.sh"
  fi
  if has_step "seed"; then
    WAVE_FILTER="${wave}" DRY_RUN="${DRY_RUN}" bash "${SCRIPT_DIR}/github/seed-repos.sh"
  fi
}

run_wave_gitlab() {
  local wave="$1"
  echo "[phase] provider=gitlab wave=${wave} dry_run=${DRY_RUN}"
  if has_step "create"; then
    WAVE_FILTER="${wave}" DRY_RUN="${DRY_RUN}" bash "${SCRIPT_DIR}/gitlab/create-projects.sh"
  fi
  if has_step "harden"; then
    WAVE_FILTER="${wave}" DRY_RUN="${DRY_RUN}" bash "${SCRIPT_DIR}/gitlab/harden-branches.sh"
  fi
  if has_step "seed"; then
    WAVE_FILTER="${wave}" DRY_RUN="${DRY_RUN}" bash "${SCRIPT_DIR}/gitlab/seed-projects.sh"
  fi
}

for wave in "${wave_list[@]}"; do
  case "${PROVIDER}" in
    github)
      run_wave_github "${wave}"
      ;;
    gitlab)
      run_wave_gitlab "${wave}"
      ;;
    both)
      run_wave_github "${wave}"
      run_wave_gitlab "${wave}"
      ;;
    *)
      echo "[error] Unsupported PROVIDER=${PROVIDER}. Use github, gitlab, or both."
      exit 1
      ;;
  esac
done

echo "[done] Wave execution complete for provider=${PROVIDER}, waves=${WAVES}, steps=${STEPS}."
