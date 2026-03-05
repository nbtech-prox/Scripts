# AGENTS.md
Guidance for coding agents working in this repository.

## Scope
- Repo type: utility scripts, mostly Bash.
- Main scripts:
  - `ops.sh`
  - `git_autosync.sh`
  - `setup_git.sh`
  - `setup_dual_git.sh`
  - `setup_multi_git_v3.sh`
  - `install_service.sh`
- No package manager, no compiled build step, and no formal test framework.

## Environment assumptions
- Linux host.
- Bash shell (`#!/bin/bash` used in scripts).
- Some flows require elevated privileges (`sudo`, `systemctl`).

## Build / Lint / Test Commands
This project has no traditional build pipeline.
Validate changes with syntax + lint checks.

### Core commands
```bash
# Syntax-check all top-level shell scripts
for f in ./*.sh; do bash -n "$f"; done

# Lint all scripts (if shellcheck exists)
shellcheck ./*.sh

# Optional formatting check (if shfmt exists)
shfmt -d -i 4 -ci ./*.sh
```

### Single-test equivalents (important)
Use these when the user asks for a "single test":

```bash
# Single-file syntax test
bash -n path/to/script.sh

# Single-file lint test
shellcheck path/to/script.sh
```

### Useful script-level smoke checks
```bash
# Validate usage path (missing required arg)
./setup_git.sh

# Safe test in a temporary repository
tmpdir=$(mktemp -d)
git init "$tmpdir"
./setup_multi_git_v3.sh "$tmpdir"
```

### Safety notes for running checks
- Many scripts are interactive.
- Some scripts modify global git config or system services.
- Do not run destructive or system-level flows on real user directories automatically.

## Code Style Guidelines
Apply these rules to all new and modified scripts.

### Shell baseline
- Use Bash unless portability requirements explicitly say otherwise.
- Keep executable scripts with `#!/bin/bash` shebang.
- Prefer robust plain-text logs; avoid relying on emoji in machine-read logs.

### Strict mode and safety
For new non-trivial scripts, prefer:

```bash
set -euo pipefail
IFS=$'\n\t'
```

If strict mode conflicts with an intentional workflow:
- handle that command explicitly,
- document why non-zero exit is acceptable,
- and continue safely.

### Imports / shared code
- There is no shared library today.
- If shared helpers are introduced, source files using script-relative paths:

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
```

- Never depend on caller CWD for `source` resolution.

### Formatting
- Indentation: 4 spaces.
- Keep functions focused and named (avoid giant inline blocks).
- Use short section banners when useful.
- Split long pipelines for readability.

### Types and data handling (Bash-specific)
- Use `local` variables inside functions.
- Use arrays for list-like values instead of space-delimited strings.
- Quote expansions: `"$var"`, `"${arr[@]}"`.
- Prefer `[[ ... ]]` for tests and regex; use `[ ... ]` only when needed.

### Naming conventions
- Files: lowercase snake_case, `.sh` suffix.
- Constants/config: uppercase (`LOG_FILE`, `CHECK_INTERVAL`).
- Locals/temp vars: lowercase snake_case (`repo_path`, `main_branch`).
- Functions: lowercase snake_case verbs (`validate_ssh`, `setup_remote`).

### Error handling
- Fail fast on invalid inputs with clear messages.
- Send error messages to stderr (`>&2`).
- Use explicit exit codes (`exit 1` for usage/validation failures).
- Validate prerequisites before risky actions:
  - directory exists,
  - required commands installed,
  - required permissions available.

Example:
```bash
if [ -z "${REPO_PATH:-}" ]; then
    echo "Error: missing repository path" >&2
    exit 1
fi
```

### External commands and portability
- Current repo assumes GNU/Linux tooling (`systemctl`, `journalctl`, `apt`, `dnf`).
- If adding new external dependencies, document them in `README.md`.
- Prefer commonly available tools over niche binaries.

### Git behavior in automation
- Never hard-reset or discard user work.
- Avoid changing global git config unless script purpose explicitly requires it.
- Print remote/branch operations so changes are auditable.
- Make push targets explicit in logs/output.

### Logging and UX
- Keep messages action-oriented and concise.
- Include timestamps for daemon/background logs.
- Preserve existing language style: user-facing text is primarily Portuguese.

## Repository-specific conventions
- Scripts are top-level files (no current module layout).
- Interactive prompts and visual section headers are common patterns.
- Preserve established behavior unless task explicitly requests redesign.

## Cursor / Copilot rules
No repository-specific agent rules were found in:
- `.cursorrules`
- `.cursor/rules/`
- `.github/copilot-instructions.md`

If these files are added later, treat them as high-priority instructions and update this document.

## PR checklist for agents
- Run `bash -n` on changed `.sh` files.
- Run `shellcheck` on changed `.sh` files (or explain why unavailable).
- Avoid destructive defaults and irreversible actions.
- Keep quoting, validation, and stderr error reporting consistent.
- Update `README.md` when behavior or usage changes.
