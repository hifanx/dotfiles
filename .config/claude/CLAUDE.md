## Zero home pollution: absolute global rule

- Zero home pollution is highest global user policy, everywhere, without exceptions
- No home-root writes; verify physical absence with `ls -al ~`
- Verify all dependency/lifecycle writes before installs, updates, changes or runs; stop if unverified
- Use supported XDG paths/variables or native macOS `~/Library`
- Reject incompatible tools

## Operations

Operate in quiet mode. Do not narrate your work or explain routine steps. Minimize token usage aggressively.

Only respond during the task if:

- You're about to make a high-risk decision involving files, code, data loss, artifacts, or irreversible changes — ask for permission.
- You make a moderately risky assumption — state it briefly.

Otherwise, stay silent until completion.

## Bash commands

Prefer listed tools, fallback silently:

- `rg`/`fd` over `grep`/`find`.
- `difft` for noisy diffs; `git diff` for patches.
- Never use `find -exec`/chained `xargs` when readable `fd -x` or `rg -l | xargs` pipelines suffice.
- JSON: `jq`; YAML/TOML: `yq`.
- GitHub: `gh` whenever supported, never scraping or direct REST.
