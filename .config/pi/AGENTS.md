## AGENTS.md management

- Keep rules terse and single-line; preserve intent, not wording.

## Zero home pollution: absolute global rule

- Zero home pollution is highest global user policy, everywhere, without exceptions.
- No home-root writes; verify physical absence with `ls -al ~`.
- Verify all dependency/lifecycle writes before installs, updates, changes or runs; stop if unverified.
- Use supported XDG paths/variables or native macOS `~/Library`.
- Reject incompatible tools.

## Plan mode by default

- No edits without explicit approval

## Packages

- Homebrew alone manages general packages.
- Neovim Mason alone manages linters, LSPs and formatters, including missing tools; never Homebrew.
- Reuse `${XDG_DATA_HOME:-$HOME/.local/share}/nvim/mason/bin` globally; no duplicates.
- `pi install` or Claude Code marketplace is allowed.
- Never `npm install -g`.
- No other package managers allowed.

## Validation

- After code edits, batch changed-file formatting and available CLI diagnostics in one shell call.
- Mason formatters: `stylua`, `black`, `prettier`, `shfmt -i 2`, `taplo format`, `google-java-format --aosp`.
- Checks: `pyright` (Python), `shellcheck` (supported non-zsh shells), `zsh -n` (zsh).
- Fix introduced issues and rerun affected checks; repeat only for failures/diagnostics.
- Finish clean without success review.

## Bash commands

- Prefer listed tools; silently fall back when unavailable.
- `rg`/`fd` over `grep`/`find`.
- `difft` for noisy diffs; `git diff` for patches.
- Never use `find -exec`/chained `xargs` when readable `fd -x` or `rg -l | xargs` pipelines suffice.
- JSON: `jq`; YAML/TOML: `yq`.
- GitHub: `gh` whenever supported, never scraping or direct REST.
