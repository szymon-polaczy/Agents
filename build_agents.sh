#!/usr/bin/env bash
set -euo pipefail

print_usage() {
  cat <<'USAGE'
Usage:
  build_agents.sh <cursor|claude|opencode|all> [--out DIR] [--force]

Description:
  Generates a ready-to-move directory tree for the selected app(s), copying
  from the nearest folder that contains:
    - AGENTS.md
    - commands/*.md (one or more markdown command files)

Examples:
  ./build_agents.sh cursor
  ./build_agents.sh claude --out dist/claude
  ./build_agents.sh all --force

Notes:
  - The script auto-detects the source directory (no fixed path). It searches:
    1) The script's directory
    2) Siblings: ./Agents, ./Agents/Agents
    3) Parent and its Agents/* variants
  - For Cursor, the output contains a project root with .cursorrules.
  - For Claude, there is no auto-load folder; we prepare a knowledge/ tree.
  - For OpenCode, we create .vscode/agents.code-snippets with common commands.
USAGE
}

# Resolve directories
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

is_valid_source() {
  local d="$1"
  [[ -f "$d/AGENTS.md" ]] || return 1
  # Require at least one markdown command file
  if find "$d/commands" -maxdepth 1 -type f -name "*.md" | read -r _; then
    return 0
  else
    return 1
  fi
}

resolve_source_dir() {
  local candidates=(
    "$SCRIPT_DIR"
    "$SCRIPT_DIR/Agents"
    "$SCRIPT_DIR/Agents/Agents"
    "$(dirname "$SCRIPT_DIR")"
    "$(dirname "$SCRIPT_DIR")/Agents"
    "$(dirname "$SCRIPT_DIR")/Agents/Agents"
  )
  for c in "${candidates[@]}"; do
    if is_valid_source "$c"; then
      echo "$c"
      return 0
    fi
  done
  return 1
}

SOURCE_DIR=""
if ! SOURCE_DIR="$(resolve_source_dir)"; then
  echo "Error: Could not find source directory with AGENTS.md and commands/*.md near $SCRIPT_DIR" >&2
  exit 1
fi

APP="${1:-}" || true
if [[ -z "$APP" ]]; then
  print_usage
  exit 1
fi
shift || true

OUT_DIR=""
FORCE="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out)
      shift || true
      OUT_DIR="${1:-}"
      if [[ -z "$OUT_DIR" ]]; then
        echo "Error: --out requires a directory path" >&2
        exit 1
      fi
      ;;
    --force)
      FORCE="true"
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      print_usage
      exit 1
      ;;
  esac
  shift || true
done

ensure_outdir() {
  local target="$1"
  if [[ -z "$target" ]]; then
    echo "Error: output directory not specified" >&2
    exit 1
  fi
  if [[ -e "$target" ]] && [[ "$FORCE" != "true" ]]; then
    echo "Error: $target already exists. Use --force to overwrite." >&2
    exit 1
  fi
  rm -rf "$target"
  mkdir -p "$target"
}

# Copy all markdown command files from a source commands directory into a destination directory
copy_command_markdowns() {
  local src_commands_dir="$1"
  local dest_dir="$2"
  mkdir -p "$dest_dir"
  # Copy all *.md files safely, handling spaces and ensuring no-glob failures
  while IFS= read -r -d '' file; do
    cp "$file" "$dest_dir/"
  done < <(find "$src_commands_dir" -maxdepth 1 -type f -name "*.md" -print0)
}

copy_common_payload() {
  local dest_root="$1"
  mkdir -p "$dest_root/commands"
  cp "$SOURCE_DIR/AGENTS.md" "$dest_root/AGENTS.md"
  copy_command_markdowns "$SOURCE_DIR/commands" "$dest_root/commands"
}

# Default output next to the script for portability
DEFAULT_DIST_DIR="$SCRIPT_DIR/dist"

build_cursor() {
  local out="${OUT_DIR:-$DEFAULT_DIST_DIR/cursor}"
  ensure_outdir "$out"
  # .cursorrules at project root from AGENTS.md
  cp "$SOURCE_DIR/AGENTS.md" "$out/.cursorrules"
  # Include commands under .cursor/commands for convenience
  mkdir -p "$out/.cursor/commands"
  copy_command_markdowns "$SOURCE_DIR/commands" "$out/.cursor/commands"
  # Minimal README
  cat > "$out/README.txt" <<'EOF'
 Cursor payload
 - Move the contents of this folder into your project root.
 - .cursorrules will be loaded by Cursor automatically.
 - Optional: command snippets are under .cursor/commands.
EOF
  echo "Built Cursor tree at $out"
}

build_claude() {
  local out="${OUT_DIR:-$DEFAULT_DIST_DIR/claude}"
  ensure_outdir "$out"
  mkdir -p "$out/.claude/commands" "$out/.claude/knowledge"
  # Knowledge bundle (optional, attach via IDE)
  cp "$SOURCE_DIR/AGENTS.md" "$out/.claude/knowledge/AGENTS.md"
  # Slash command prompt files
  copy_command_markdowns "$SOURCE_DIR/commands" "$out/.claude/commands"
  cat > "$out/README.txt" <<'EOF'
Claude Code payload
- Place this in your project.
- Slash commands: .claude/commands/*.md (frontmatter/prompt files)
- Knowledge (optional): .claude/knowledge/AGENTS.md (attach via IDE)
EOF
  echo "Built Claude tree at $out"
}

build_opencode() {
  local out="${OUT_DIR:-$DEFAULT_DIST_DIR/opencode}"
  ensure_outdir "$out"
  # opencode reads AGENTS.md from project root; include minimal opencode.json
  cp "$SOURCE_DIR/AGENTS.md" "$out/AGENTS.md"
  mkdir -p "$out/commands"
  copy_command_markdowns "$SOURCE_DIR/commands" "$out/commands"
  cat > "$out/opencode.json" <<'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    "AGENTS.md",
    "commands/*.md"
  ]
}
EOF
  cat > "$out/README.txt" <<'EOF'
opencode payload
- Move the contents of this folder into your project root.
- AGENTS.md is the primary rules file consumed by opencode.
- commands/ contains prompt/instruction files; opencode.json includes them via instructions.
EOF
  echo "Built opencode tree at $out"
}

case "$APP" in
  cursor)
    build_cursor
    ;;
  claude)
    build_claude
    ;;
  opencode)
    build_opencode
    ;;
  all)
    build_cursor
    build_claude
    build_opencode
    ;;
  *)
    echo "Unknown app: $APP" >&2
    print_usage
    exit 1
    ;;
esac
