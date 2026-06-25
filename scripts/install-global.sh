#!/usr/bin/env bash
#
# install-global.sh — Installs copilot-agent-toolkit instructions, agents, and
# skills as user level customizations so they apply to every workspace and
# across tools (VS Code, GitHub Copilot CLI, Claude Code).
#
# Copies into the documented GA user profile locations:
#   .github/instructions/*.instructions.md  ->  ~/.copilot/instructions/
#   .github/agents/*.agent.md               ->  ~/.copilot/agents/
#   .github/skills/*/                       ->  ~/.copilot/skills/, ~/.claude/skills/, ~/.agents/skills/
#
# ~/.copilot is read by VS Code and GitHub Copilot CLI. ~/.claude is read by
# Claude Code. Instructions keep their applyTo globs and apply across every
# workspace. MCP servers are not installed here; install the toolkit as an
# agent plugin (see README) to get them.
#
# Usage: ./scripts/install-global.sh [--force] [--dry-run]

set -euo pipefail

FORCE=false
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --force)   FORCE=true ;;
    --dry-run) DRY_RUN=true ;;
    -h|--help)
      echo "Usage: $(basename "$0") [--force] [--dry-run]"
      exit 0
      ;;
    *) echo "Unknown flag: $arg" >&2; exit 1 ;;
  esac
done

step() { printf '\n\033[36m>> %s\033[0m\n' "$1"; }
ok()   { printf '   \033[32m[OK]\033[0m %s\n' "$1"; }
warn() { printf '   \033[33m[WARN]\033[0m %s\n' "$1"; }
dry()  { printf '   \033[35m[DRY-RUN]\033[0m %s\n' "$1"; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ ! -d "$REPO_DIR/.github" ]]; then
  echo "Error: could not locate .github folder (expected at $REPO_DIR/.github)" >&2
  exit 1
fi

readonly SRC_INSTRUCTIONS="$REPO_DIR/.github/instructions"
readonly SRC_AGENTS="$REPO_DIR/.github/agents"
readonly SRC_SKILLS="$REPO_DIR/.github/skills"

readonly COPILOT_INSTRUCTIONS="$HOME/.copilot/instructions"
readonly COPILOT_AGENTS="$HOME/.copilot/agents"
readonly SKILL_TARGETS=("$HOME/.copilot/skills" "$HOME/.claude/skills" "$HOME/.agents/skills")

# Copy a single file into a destination directory.
copy_file() {
  local src="$1" dest_dir="$2"
  local dest="$dest_dir/$(basename "$src")"
  if [[ "$DRY_RUN" == true ]]; then
    dry "would copy  ->  $dest"
    return
  fi
  if [[ -e "$dest" && "$FORCE" == false ]]; then
    warn "exists, skipping (use --force): $dest"
    return
  fi
  mkdir -p "$dest_dir"
  cp -f "$src" "$dest"
  ok "copied  ->  $dest"
}

# Copy a directory recursively to an exact destination path.
copy_dir() {
  local src="$1" dest="$2"
  if [[ "$DRY_RUN" == true ]]; then
    dry "would copy  ->  $dest"
    return
  fi
  if [[ -e "$dest" && "$FORCE" == false ]]; then
    warn "exists, skipping (use --force): $dest"
    return
  fi
  rm -rf "$dest"
  mkdir -p "$(dirname "$dest")"
  cp -R "$src" "$dest"
  ok "copied  ->  $dest"
}

step "Installing instruction files  ->  $COPILOT_INSTRUCTIONS"
if [[ -d "$SRC_INSTRUCTIONS" ]]; then
  shopt -s nullglob
  for file in "$SRC_INSTRUCTIONS"/*.instructions.md; do
    copy_file "$file" "$COPILOT_INSTRUCTIONS"
  done
  shopt -u nullglob
else
  warn "no instructions folder at $SRC_INSTRUCTIONS"
fi

step "Installing agent files  ->  $COPILOT_AGENTS"
if [[ -d "$SRC_AGENTS" ]]; then
  shopt -s nullglob
  for file in "$SRC_AGENTS"/*.agent.md; do
    copy_file "$file" "$COPILOT_AGENTS"
  done
  shopt -u nullglob
else
  warn "no agents folder at $SRC_AGENTS"
fi

step "Installing skill folders  ->  ~/.copilot, ~/.claude, ~/.agents"
if [[ -d "$SRC_SKILLS" ]]; then
  shopt -s nullglob
  for skill in "$SRC_SKILLS"/*/; do
    skill_name="$(basename "$skill")"
    for target in "${SKILL_TARGETS[@]}"; do
      copy_dir "${skill%/}" "$target/$skill_name"
    done
  done
  shopt -u nullglob
else
  warn "no skills folder at $SRC_SKILLS"
fi

printf '\n\033[32m=== Installation complete ===\033[0m\n'
echo "  Instructions: $COPILOT_INSTRUCTIONS"
echo "  Agents:       $COPILOT_AGENTS"
echo "  Skills:       ${SKILL_TARGETS[*]}"
echo ""
echo "Next steps:"
echo "  1. Restart VS Code (or your agent) to pick up the new files."
echo "  2. Enable Settings Sync (Prompts and Instructions) to sync user instructions across machines."
echo "  3. For MCP servers, install the toolkit as an agent plugin (see README)."
echo ""
