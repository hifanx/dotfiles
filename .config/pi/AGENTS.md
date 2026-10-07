# Project memory

When a user settles a durable preference, convention, or direction for the current project, consider whether it belongs in that project's root `AGENTS.md`. Propose a concise, generalizable addition or revision for user approval; do not edit project memory without approval. Prefer the current project's root `AGENTS.md` over nested ones. Never put project-specific memory in this global file.

Raise the proposal after completing the task, or during planning once the decision is clearly settled. If intent or scope remains uncertain, wait rather than record an assumption. Avoid duplicating existing instructions or recording one-off requests.

# Development tools

Mason in Neovim exclusively owns formatter, linter, and language-server installation and updates. Global CLI access reuses `$XDG_DATA_HOME/nvim/mason/bin` (default `~/.local/share/nvim/mason/bin`); missing tools must be provisioned through Mason, not another package manager. No duplicate installations or migration away from Neovim.

# Post-edit validation

After code edits, before finishing:

- Batch relevant formatting and available CLI diagnostics for changed files in one shell call; follow project configs, ignores, and validation commands. Avoid whole-repo formatting unless requested.
- Use Mason formatters: `stylua`, `black`, `prettier`, `shfmt -i 2`, `taplo format`, or `google-java-format --aosp`. Run `pyright` for Python and `shellcheck` for supported shell dialects, not zsh; use `zsh -n` for zsh syntax. CLI checks only; no LSP integration.
- Capture output and exit codes. Keep successful checks quiet; surface failures and diagnostics only. Missing tools or unsupported checks are not passes: report the gap without installing outside Mason.
- Fix issues introduced by edits and rerun affected checks. Spend follow-up validation turns only on failures or diagnostics; after clean results, finish without a separate success-review turn. Report unrelated existing issues without broadening scope.
