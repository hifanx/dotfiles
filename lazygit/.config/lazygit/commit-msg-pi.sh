#!/usr/bin/env bash
# One-off AI commit message with pi. Self-contained; the original OpenCode
# workflow in commit-msg.sh stays untouched.
set -eu

model="opencode-go/glm-5.3-flash"
msg_file="/tmp/commit_msg.txt"

# Commit prompt, copied verbatim from the OpenCode Commit agent.
read -r -d '' body <<'EOF' || true
You write a git commit message for the staged diff in the user's input.
The input has labeled sections: Repo, Branch, Changed files, Diff, and
Recent commits (including a file-scoped history of the changed files).

1. Classify by intent, not by files touched. Removing or rewriting
   existing behavior is a refactor. Repairing something that worked
   differently is a fix. Routine bumps and tweaks are chore. New
   capability is feat.
2. Scope comes from the top-level directory or package of the changed
   files; omit it only when changes span unrelated areas. In config-only
   repos (dotfiles, rc files), the scope is the tool name.
3. Continue the storyline: if the file-scoped history shows ongoing work
   (a migration, rename, or initiative), reuse its wording so this
   message reads as the next step, not a restatement of the diff.
4. Mirror the dominant style of Recent commits (scope names, type usage,
   tone). Default is Conventional Commits with types feat, fix, docs,
   style, refactor, perf, test, build, ci, chore. If the history is plain
   lowercase without types, mirror that instead.
5. Subject: imperative, lowercase, under 72 chars, no trailing period.
   Add a body (after a blank line) only when the why isn't visible in
   the diff; explain motivation, not mechanics. Wrap body lines at 72.
6. If the branch name contains a ticket or issue reference, add it as a
   footer line.
7. If the staged diff contains clearly unrelated changes, write the
   message for the dominant change and end the body with
   "Includes unrelated changes to X." so the commit can be split.

Output only the commit message — no backticks, no explanation.
EOF

p=$(git diff --cached --name-only)
if [ -z "$p" ]; then
  echo "nothing staged to write a commit message for" >&2
  exit 1
fi

echo "Generating commit message with pi ($model)..."

# --print: final text goes straight to stdout, no JSONL to reassemble.
# --no-session: in-memory run, nothing lands in the session list.
# The --no-* flags keep skills, extensions, packages, and AGENTS.md out.
{
  echo "Repo: $(basename "$(git rev-parse --show-toplevel)")"
  echo "Branch: $(git branch --show-current)"
  echo "Changed files:"
  git diff --cached --stat | head -c 2000
  echo
  echo "Diff:"
  git diff --cached | head -c 100000
  echo
  echo "Recent commits on these files:"
  git log --oneline -8 -- $p
  echo
  echo "Recent commits:"
  git log --oneline -10
} | pi --print --no-session --no-tools --no-extensions --no-skills \
     --no-prompt-templates --no-themes --no-context-files \
     --system-prompt "$body" \
     --model "$model" --thinking off \
     "Write a commit message for this diff." >"$msg_file"

if [ ! -s "$msg_file" ]; then
  echo "error: pi produced an empty commit message" >&2
  exit 1
fi

exec git commit -e -F "$msg_file"
