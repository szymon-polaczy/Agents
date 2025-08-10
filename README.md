## Agents — Portable AI Agent Rules and Commands

Make your AI coding assistants consistent across tools. This repo contains:

- **Core philosophy** and working rules in `AGENTS.md`
- **Reusable commands** in `commands/` (`/analyze`, `/refactor`)
- **A builder script** `build_agents.sh` that outputs ready-to-use payloads for:
  - Cursor
  - Claude Code
  - opencode

### Why

Keep your assistants boring, defensive, and effective. Share one clear set of instructions and commands across editors without manual copy-paste.

---

## Quick Start (TL;DR)

```bash
chmod +x ./build_agents.sh
./build_agents.sh cursor        # Build for Cursor
./build_agents.sh claude        # Build for Claude Code
./build_agents.sh opencode      # Build for OpenCode (VS Code)
./build_agents.sh all           # Build all three
```

- Add `--out PATH` to choose an output directory (defaults to `./dist/<target>`)
- Add `--force` to overwrite the output directory if it exists

Examples:

```bash
./build_agents.sh cursor --out ./dist/cursor --force
./build_agents.sh claude --out ./dist/claude
./build_agents.sh opencode --force
```

---

## What gets built

Note: These trees are produced by this script for convenience and portability. They are not official directory requirements of the referenced tools.

- **Cursor**
  - Creates a project tree with:
    - `.cursorrules` (from `AGENTS.md`)
    - `.cursor/commands/` (copies all `commands/*.md`)
  - Move the contents of the output folder to your project root.

- **Claude Code**
  - Creates a project tree with:
    - `.claude/commands/*.md` (slash commands; frontmatter/prompt files)
    - `.claude/knowledge/AGENTS.md` (optional; attach via IDE as knowledge)
  - Notes:
    - Claude Code attaches knowledge via the IDE. The `.claude/knowledge` folder here is a convenience staging area.
    - Slash commands use prompt files with frontmatter; see the official docs.

- **opencode**
  - Creates a project tree with:
    - `AGENTS.md` at project root (primary rules)
    - `commands/` (copies all `commands/*.md`)
    - `opencode.json` referencing `AGENTS.md` and `commands/*.md` via `instructions`
  - Note: opencode reads `AGENTS.md` from the project root and supports additional instruction files via `opencode.json`. See docs for precedence and globals.

---

## Usage Details

```bash
Usage:
  build_agents.sh <cursor|claude|opencode|all> [--out DIR] [--force]

Examples:
  ./build_agents.sh cursor
  ./build_agents.sh claude --out dist/claude
  ./build_agents.sh all --force
```

- **Auto-detection**: The script finds the nearest folder containing `AGENTS.md` and `commands/*.md` based on the script’s location. Works when run from this repo or when copied elsewhere.
- **Safety**: The script uses `set -euo pipefail` and will abort on errors.

Troubleshooting:

- "permission denied": run `chmod +x ./build_agents.sh`
- "Unknown app": use one of `cursor`, `claude`, `opencode`, or `all`
- "already exists": add `--force` to overwrite the output directory
- "Could not find source directory": ensure `AGENTS.md` and at least one `commands/*.md` exist near the script

---

## Included Commands

- **/analyze**: Maintainability and defensive programming audit. See [`commands/Analyze.md`](commands/Analyze.md).
- **/refactor**: Apply early returns, add validations, deduplicate, or rewrite. See [`commands/Refactor.md`](commands/Refactor.md).

How to use:

- Cursor: Use your `.cursorrules` and paste from `.cursor/commands` when needed.
- Claude Code: Use `.claude/commands/*.md` for slash commands; attach `.claude/knowledge/AGENTS.md` in the IDE if desired.
- opencode: Keep `AGENTS.md` at project root; `opencode.json` includes `AGENTS.md` and `commands/*.md` via `instructions`.

---

## Philosophy (Short Version)

See full details in [`AGENTS.md`](AGENTS.md). The key ideas:

- **Early returns** to minimize nesting (max 3 levels)
- **Functions <50 lines** with single responsibility
- **Start in one file**, avoid premature abstractions
- **Defensive by default**: validate inputs, check errors, safe access
- **Rewrite instead of patching** if a fix takes >3 lines

---

## Project Layout

```
Agents/
├── AGENTS.md
├── README.md
├── build_agents.sh
└── commands/
    ├── Analyze.md
    └── Refactor.md
```

---

## Contributing

Contributions are welcome. Keep changes simple, defensive, and readable. Favor complete, clear edits over cleverness.

---

## License

No license file is provided yet. If you plan to use or distribute this project, add a license appropriate to your needs (e.g., MIT, Apache-2.0).

---

## References

- opencode (terminal AI coding agent): `https://github.com/sst/opencode`
- opencode Rules docs: `https://opencode.ai/docs/rules/`
- Claude Code slash commands: `https://docs.anthropic.com/en/docs/claude-code/slash-commands`


