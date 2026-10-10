# Zero home pollution: absolute global rule

- **Before every install or modification, verify all writes—including dependency and first-run effects—use appropriate XDG locations and configured variables. Stop if unverified.**
- **No tool-specific entries directly in `$HOME`: physically absent and absent from `ls -al ~`. No symlinks, hiding or temporary entries.**
- **Unavoidable home writes: reject tool, warn, offer verified XDG-compliant workaround or alternative. No exceptions, even explicit install requests.**

# Development tools

Use Neovim Mason exclusively for formatter, linter and language-server installs and updates, including missing tools. Reuse `$XDG_DATA_HOME/nvim/mason/bin` (default `~/.local/share/nvim/mason/bin`) for global CLI access. No duplicate installs or migration away from Neovim.

# Post-edit validation

After code edits, before finishing:

- Batch relevant formatting and available CLI diagnostics for changed files in one shell call. Follow project configs, ignores and validation commands; whole-repo formatting only on request.
- Use Mason formatters: `stylua`, `black`, `prettier`, `shfmt -i 2`, `taplo format`, or `google-java-format --aosp`. Run `pyright` (Python), `shellcheck` (supported shells, not zsh), `zsh -n` (zsh syntax). CLI only; no LSP integration.
- Capture output and exit codes; show only failures and diagnostics. Report missing tools or unsupported checks as gaps, not passes; no installs outside Mason.
- Fix edit-caused issues and rerun affected checks. Follow-up validation turns only for failures or diagnostics; finish when clean, without separate success review. Report unrelated existing issues without expanding scope.

## Bash commands

Prefer listed tools when available. Fall back silently.

- `rg` over `grep`, `fd` over `find`
- `difft` when formatting noise obscures changes; `git diff` for patches
- **Never** use `find -exec` or `xargs` chains when `fd -x` or `rg -l | xargs` would be clearer. Prefer readable pipelines
- `jq` for all JSON pipeline parsing, filtering or transformation; `yq` for YAML/TOML
- **GitHub:** `gh` for PRs, issues, reviews, CI status, and releases. No github.com scraping or direct REST calls when `gh` can do it.
