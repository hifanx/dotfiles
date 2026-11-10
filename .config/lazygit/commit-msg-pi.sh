#!/usr/bin/env bash
# AI commit draft with pi. yadm repo: "<tool>: subject", one tool per
# commit. Other repos: Conventional Commits. $1 is optional intent.
set -eu

# ensure API keys are present, even in non interactive shells, such as popup terminals
# shellcheck source=/dev/null
[ -f "$HOME/.config/.env" ] && . "$HOME/.config/.env"

model="deepseek/deepseek-flash[1m]"
msg_file="/tmp/commit_msg.txt"
intent=${1:-}

# git log pathspecs are cwd-relative; diff paths are root-relative.
cd "$(git rev-parse --show-toplevel)"

p=$(git diff --cached --name-only)
if [ -z "$p" ]; then
  echo "nothing staged to write a commit message for" >&2
  exit 1
fi

read -r -d '' yadm_body <<'EOF' || true
You write the subject line of a dotfiles commit from a staged diff.
The input has labeled sections: Prefix, Intent, Changed files, Diff,
and Recent commits on these files.

Output exactly one line: "<Prefix>: <subject>", using the given Prefix
verbatim. No body, no backticks, no explanation.

Subject: lowercase, imperative, under 72 chars total, no trailing period.

Fixed forms; use them whenever they fit:
- plugin, extension, package or formula added: "<prefix>: hello <name>"
- one removed: "<prefix>: bye bye <name>"
- the whole tool's config removed: "<prefix>: bye bye <prefix>"
- the tool itself updated: "<prefix>: bump <prefix> version to <version>",
  dropping " to <version>" when the diff shows no version
- one plugin updated: "<prefix>: bump <name>"
- a lockfile updating many entries: "<prefix>: bump plugins"
- Brewfile changes beyond a single add or remove: "brew: bump Brewfile"

Otherwise say what the change is for. If Intent is given, it is the
reason for the change: build the subject around it. If not, describe
the change concretely and never invent a motivation. Reuse names and
terms from Recent commits so the history reads consistently; do not
copy their wording.

Examples:
nvim: hello fidget.nvim
nvim: bye bye mini.nvim
btop: bye bye btop
pi: bump pi version to 1.4.0
nvim: bump obsidian.nvim
brew: hello ripgrep
ghostty: switch cursor color to green
zsh: lazy-load nvm to speed up shell startup
EOF

read -r -d '' repo_body <<'EOF' || true
You write a git commit message for the staged diff in the user's input.
The input has labeled sections: Repo, Branch, Intent, Changed files,
Diff, and Recent commits on these files.

1. Conventional Commits: type(scope): subject. Types: feat (new
   capability), fix (repairs wrong behavior), refactor (restructure,
   same behavior), perf, docs, test, build, ci, style, chore
   (maintenance), revert. Classify by intent, not by files touched.
2. Scope: only when all changed files sit under one top-level directory
   or package; name it after that. Otherwise omit the scope.
3. Subject: lowercase, imperative, under 72 chars, no trailing period.
4. Dependency bumps: "chore: bump <name> to <version>" for one,
   "chore: bump dependencies" for several. Adding a dependency belongs
   to the change that needs it.
5. Intent, when given, is the reason for the change: build the subject
   around it, and add a body (after a blank line, wrapped at 72) only
   for the why it gives that the diff does not show. With no Intent:
   no body, describe the change concretely, never invent a motivation.
6. If the diff holds clearly unrelated changes, write the message for
   the dominant one and end the body with "Includes unrelated changes
   to X." so the commit can be split.
7. Reuse names and terms from Recent commits so the history reads
   consistently; do not copy their wording.

Examples:
feat(api): retry idempotent requests on 503
fix: keep cursor position after formatting
refactor(auth): split token refresh out of the session store
chore: bump react to 19.2.0

Output only the commit message, no backticks, no explanation.
EOF

# Outside $(...): macOS bash 3.2 can't parse case patterns inside it.
prefix_of() {
  case "$1" in
  .config/homebrew/*) echo brew ;;
  .zshrc | .zshenv) echo zsh ;;
  .local/scripts/*) echo scripts ;;
  .config/*/*)
    f=${1#.config/}
    echo "${f%%/*}"
    ;;
  *) echo "?$1" ;;
  esac
}

header=""
body=$repo_body
if [ "$(git rev-parse --absolute-git-dir)" = "$HOME/.local/share/yadm/repo.git" ]; then
  prefixes=$(printf '%s\n' "$p" | while IFS= read -r f; do prefix_of "$f"; done | sort -u)
  if printf '%s\n' "$prefixes" | grep -q '^?'; then
    echo "error: no prefix for these paths; write the message by hand:" >&2
    printf '%s\n' "$prefixes" | sed -n 's/^?/  /p' >&2
    exit 1
  fi
  if [ "$(printf '%s\n' "$prefixes" | wc -l)" -ne 1 ]; then
    echo "error: staged changes span several tools; split the commit:" >&2
    printf '%s\n' "$prefixes" | sed 's/^/  /' >&2
    exit 1
  fi
  header="Prefix: $prefixes"
  body=$yadm_body
else
  header="Repo: $(basename "$PWD")
Branch: $(git branch --show-current)"
fi

echo "Generating commit message with pi ($model)..."

# --print: final text goes straight to stdout, no JSONL to reassemble.
# --no-session: in-memory run, nothing lands in the session list.
# The --no-* flags keep skills, extensions, packages, and AGENTS.md out.
# Prompt rides in stdin: pi --print hangs given both stdin and an argument.
{
  echo "$header"
  echo "Intent: ${intent:-(none given)}"
  echo "Changed files:"
  git diff --cached --no-ext-diff --stat | head -c 2000
  echo
  echo "Diff:"
  git diff --cached --no-ext-diff | head -c 100000
  echo
  echo "Recent commits on these files:"
  git diff --cached --name-only -z | xargs -0 git log --format=%s -5 --
  echo
  echo "Write a commit message for this diff."
} | pi --print --no-session --no-tools --no-extensions --no-skills \
  --no-prompt-templates --no-themes --no-context-files \
  --system-prompt "$body" \
  --model "$model" --thinking high >"$msg_file"

if [ ! -s "$msg_file" ]; then
  echo "error: pi produced an empty commit message" >&2
  exit 1
fi

exec git commit -e -F "$msg_file"
