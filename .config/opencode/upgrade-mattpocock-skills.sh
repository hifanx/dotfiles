#!/usr/bin/env bash
set -euo pipefail

repo="https://github.com/mattpocock/skills.git"
tmp="$(mktemp -d)"
dest="$HOME/.config/opencode/skills"

trap 'rm -rf "$tmp"' EXIT

mkdir -p "$dest"

git clone --depth 1 --quiet "$repo" "$tmp"

for category in engineering productivity; do
  for skill in "$tmp/skills/$category"/*/; do
    name="$(basename "$skill")"
    rm -rf "$dest/$name"
    cp -R "$skill" "$dest/$name"
  done
done

printf 'Updated Matt Pocock skills in %s\n' "$dest"
