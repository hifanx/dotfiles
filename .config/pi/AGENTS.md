## Zero home pollution: absolute global rule

Zero home pollution is highest global user policy, everywhere, without exceptions.
No home-root writes; verify physical absence with `ls -al ~`.
Verify all dependency/lifecycle writes before installs, updates, changes or runs; stop if unverified.
Use supported XDG paths/variables or native macOS `~/Library`.
Reject incompatible tools.

## Plan mode by default

No edits without explicit approval.

## Operations

Operate in quiet mode. Do not narrate your work or explain routine steps. Minimize token usage aggressively.

Only respond during the task if:

- You're about to make a high-risk decision involving files, code, data loss, artifacts, or irreversible changes — ask for permission.
- You make a moderately risky assumption — state it briefly.

Otherwise, stay silent until completion.

## Context7 documentation

Use Context7 MCP for library, framework, SDK, API, CLI, and cloud-service documentation.
Resolve the library ID first, then query its documentation.
Skip resolution when a library ID is known or provided.

## Validation

After edits, batch changed-file formatting and CLI diagnostics in one shell call.
Mason formatters: `stylua`, `black`, `prettier`, `shfmt -i 2`, `taplo format`, `google-java-format --aosp`.
Checks: `pyright` (Python), `shellcheck` (supported non-zsh shells), `zsh -n` (zsh).
Fix introduced issues and rerun affected checks; repeat only for failures/diagnostics.

## Bash commands

Prefer listed tools, fallback silently:

- `rg`/`fd` over `grep`/`find`.
- `difft` for noisy diffs; `git diff` for patches.
- Never use `find -exec`/chained `xargs` when readable `fd -x` or `rg -l | xargs` pipelines suffice.
- JSON: `jq`; YAML/TOML: `yq`.
- GitHub: `gh` whenever supported, never scraping or direct REST.

## Automatic delegation

Automatically invoke subagents when isolation earns overhead.
Handle trivial work directly.
Children never delegate.
No per-task delegation request.

Route:

- codebase recon to scout
- external research to researcher
- implementation to worker
- review to reviewer
- decision critique to oracle
