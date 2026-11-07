#!/usr/bin/env bash
# Lets Claude Code agents run the desk rulebook (and nothing more) without
# stopping to ask. Claude Code's auto mode will not run a freshly cloned
# script on the strength of a chat message, so the owner grants it once, on
# the machine, here. Every other command still goes through the usual checks.
#
#   TARGET_REPO=me/desk-demo scripts/allow-desk.sh ~/.switch/agents/<server>/oss-desk ~/.switch/agents/<server>/oss-reviewer
#
# Merges into each agent's .claude/settings.json; existing settings are kept.
set -euo pipefail

: "${TARGET_REPO:?Set TARGET_REPO to the repository the desk runs (owner/name)}"
[ "$#" -gt 0 ] || { echo "usage: TARGET_REPO=owner/name $0 <agent-directory>..." >&2; exit 1; }

rules="$(jq -cn --arg r "$TARGET_REPO" '[
  "Bash(desk/bin/desk:*)",
  "Bash(TARGET_REPO=\($r) desk/bin/desk:*)",
  "Bash(DRY_RUN=1 TARGET_REPO=\($r) desk/bin/desk:*)"
]')"

for dir in "$@"; do
  [ -d "$dir" ] || { echo "skip: $dir is not a directory" >&2; continue; }
  mkdir -p "$dir/.claude"
  f="$dir/.claude/settings.json"
  [ -s "$f" ] || echo '{}' > "$f"
  tmp="$(mktemp)"
  jq --argjson add "$rules" '.permissions.allow = (((.permissions.allow // []) + $add) | unique)' "$f" > "$tmp"
  mv "$tmp" "$f"
  echo "allowed desk in $f"
done
