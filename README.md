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

## Commands and Usage

- **/analyze**: See [`commands/Analyze.md`](commands/Analyze.md)
- **/refactor**: See [`commands/Refactor.md`](commands/Refactor.md)

Use with:

- Cursor: `.cursorrules` + `.cursor/commands/*.md`
- Claude Code: `.claude/commands/*.md` and optionally attach `.claude/knowledge/AGENTS.md`
- opencode: `AGENTS.md` at root; `opencode.json` includes `AGENTS.md` and `commands/*.md`

---

## Contributing

Contributions are welcome. Keep changes simple, defensive, and readable. Favor complete, clear edits over cleverness.

---

## References

- Opencode Rules docs: `https://opencode.ai/docs/rules/`
- Claude Code slash commands: `https://docs.anthropic.com/en/docs/claude-code/slash-commands`


