#!/usr/bin/env bash
# Installs the desk CLI for the agents on this machine, at
# ~/.maintainer-desk/bin/desk. Run it once, as the owner, before creating the
# desk from the Switch template.
#
# The agents never download or install code themselves: they only run the
# tool their owner put here. That is also what lets Claude Code's auto mode
# run it without stopping, since nothing in a chat led to fetching it.
#
#   scripts/install.sh
set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
command -v gh >/dev/null || { echo "Install the GitHub CLI (gh) first: https://cli.github.com" >&2; exit 1; }
command -v jq >/dev/null || { echo "Install jq first." >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Log gh in first: gh auth login" >&2; exit 1; }

dest="$HOME/.maintainer-desk/bin"
mkdir -p "$dest"
cat > "$dest/desk" <<EOF
#!/usr/bin/env bash
# Installed by Maintainer Desk scripts/install.sh from $src
exec "$src/bin/desk" "\$@"
EOF
chmod +x "$dest/desk"

echo "Installed: $dest/desk -> $src/bin/desk"
"$dest/desk" config
