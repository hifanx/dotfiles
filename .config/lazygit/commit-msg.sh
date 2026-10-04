#!/usr/bin/env bash
# One-off AI commit message. Generates from the staged diff with OpenCode,
# then deletes the session so nothing lands in the session list.
set -eu

model="opencode-go/glm-5.3-flash"
msg_file="/tmp/commit_msg.txt"

p=$(git diff --cached --name-only)
if [ -z "$p" ]; then
  echo "nothing staged to write a commit message for" >&2
  exit 1
fi

echo "Generating commit message with OpenCode ($model)..."

# No pipefail: `git diff | head -c` may SIGPIPE on large diffs, same as V1.
if ! events=$(
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
  } | opencode run --format json --agent Commit --model "$model" \
    "Write a commit message for this diff."
); then
  echo "error: opencode run failed" >&2
  exit 1
fi

# The first JSON event carries the session ID, used for cleanup below.
sid=$(printf '%s\n' "$events" | python3 -c '
import json, sys

for line in sys.stdin:
    try:
        event = json.loads(line)
    except ValueError:
        continue
    sid = event.get("sessionID")
    if sid:
        print(sid)
        break
')

# Reassemble the message from the streamed text parts.
printf '%s\n' "$events" | python3 -c '
import json, sys

for line in sys.stdin:
    try:
        event = json.loads(line)
    except ValueError:
        continue
    if event.get("type") == "text":
        sys.stdout.write(event.get("part", {}).get("text") or "")
' >"$msg_file"

# One-off run: remove the session so it does not pollute the session list.
if [ -n "$sid" ]; then
  opencode session delete "$sid" >/dev/null 2>&1 ||
    echo "warning: could not delete session $sid" >&2
fi

if [ ! -s "$msg_file" ]; then
  echo "error: OpenCode produced an empty commit message" >&2
  exit 1
fi

exec git commit -e -F "$msg_file"
