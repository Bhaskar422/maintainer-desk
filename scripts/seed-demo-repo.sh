#!/usr/bin/env bash
# Creates a public demo repository for Maintainer Desk: a tiny Python library
# with eight issues (seven labelled `hackathon`) and three pull requests that
# exercise every rule the desk enforces.
#
#   scripts/seed-demo-repo.sh                 # creates <you>/desk-demo
#   scripts/seed-demo-repo.sh me/other-name   # or name it yourself
#
# Needs gh (logged in) and git. Refuses to touch a repository that exists.
set -euo pipefail

me="$(gh api user --jq .login)"
REPO="${1:-$me/desk-demo}"
owner="${REPO%%/*}"

if gh repo view "$REPO" >/dev/null 2>&1; then
  echo "$REPO already exists. Delete it or pass another name." >&2
  exit 1
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cd "$work"
git init -q -b main

mkdir -p textkit tests .github/workflows
cat > README.md <<'EOF'
# textkit

Small, dependency-free text helpers for Python.

```python
from textkit import word_count, title_case
word_count("hello there")   # 2
title_case("hello there")   # "Hello There"
```

Run the tests with `python -m pytest`.

This repository is the demo project for [Maintainer Desk](https://github.com/OWNER/maintainer-desk).
EOF
sed -i '' "s#OWNER#$owner#" README.md 2>/dev/null || sed -i "s#OWNER#$owner#" README.md

cat > textkit/__init__.py <<'EOF'
from .core import title_case, word_count

__all__ = ["title_case", "word_count"]
EOF

cat > textkit/core.py <<'EOF'
"""Small text helpers."""
import re


def word_count(text: str) -> int:
    """Count the words in text."""
    return len(re.findall(r"[A-Za-z0-9]+", text))


def title_case(text: str) -> str:
    """Capitalise the first letter of every word."""
    return re.sub(r"[A-Za-z]+", lambda m: m.group(0).capitalize(), text)
EOF

cat > tests/test_core.py <<'EOF'
from textkit import title_case, word_count


def test_word_count():
    assert word_count("hello there") == 2


def test_title_case():
    assert title_case("hello there") == "Hello There"
EOF

cat > .github/workflows/test.yml <<'EOF'
name: test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install pytest && python -m pytest -q
EOF

git add -A
git commit -qm "textkit: word_count and title_case"

echo "Creating $REPO ..."
gh repo create "$REPO" --public --source . --push \
  --description "Demo project for Maintainer Desk (Switch hackathon)" >/dev/null

gh label create hackathon --repo "$REPO" --color FF895E --description "Claimable through Maintainer Desk" --force >/dev/null

new_issue() { # title body labels -> number
  local url
  url="$(gh issue create --repo "$REPO" --title "$1" --body "$2" ${3:+--label "$3"})"
  echo "${url##*/}"
}

i1=$(new_issue "Add slugify() helper" "Turn any title into a URL-safe slug: lowercase, ASCII, words joined by single hyphens." "hackathon,enhancement")
i2=$(new_issue "word_count() counts \"don't\" as two words" "\`word_count(\"don't stop\")\` returns 3. Contractions should count as one word." "hackathon,bug")
i3=$(new_issue "Add --json output to the CLI" "Scripts want machine-readable output." "hackathon")
i4=$(new_issue "title_case() skips non-ASCII letters" "\`title_case(\"élan vital\")\` returns \"élan Vital\"." "hackathon,bug")
i5=$(new_issue "Add truncate() with an ellipsis" "\`truncate(text, width)\` shortens text to at most \`width\` characters and ends with an ellipsis when it cuts." "hackathon,good first issue")
i6=$(new_issue "Document every public function in the README" "Each function should have a one-line example." "hackathon,documentation")
i7=$(new_issue "Add type hints to the CLI" "Hint every argument and return value." "hackathon")
i8=$(new_issue "Run CI on Python 3.13" "Add 3.13 to the test matrix. (Maintainers only, not part of the hackathon.)" "")

# Pre-existing state: #2 and #7 are already held, #5 is held by the author of the clean PR.
for i in "$i2" "$i5" "$i7"; do
  gh issue edit "$i" --repo "$REPO" --add-assignee "$me" >/dev/null
done

# PR 1: clean. Linked, assigned, tested.
git checkout -qb feat/truncate
cat >> textkit/core.py <<'EOF'


def truncate(text: str, width: int, ellipsis: str = "…") -> str:
    """Shorten text to at most width characters, ending with ellipsis when cut."""
    if width < len(ellipsis):
        raise ValueError("width must leave room for the ellipsis")
    if len(text) <= width:
        return text
    return text[: width - len(ellipsis)].rstrip() + ellipsis
EOF
cat > tests/test_truncate.py <<'EOF'
import pytest

from textkit.core import truncate


def test_short_text_is_unchanged():
    assert truncate("hi", 10) == "hi"


def test_long_text_is_cut_with_ellipsis():
    assert truncate("hello there world", 9) == "hello th…"


def test_width_must_fit_ellipsis():
    with pytest.raises(ValueError):
        truncate("hello", 0)
EOF
git add -A && git commit -qm "Add truncate() with an ellipsis"
git push -q origin feat/truncate
p1="$(gh pr create --repo "$REPO" --head feat/truncate --title "Add truncate() with an ellipsis" \
  --body "Closes #$i5

Adds \`truncate(text, width, ellipsis=\"…\")\`. Text that fits is returned unchanged; longer text is cut so the result, ellipsis included, is at most \`width\` characters. A width too small for the ellipsis raises \`ValueError\`. Three tests cover the cases.")"

# PR 2: low effort. One word, no issue, no description.
git checkout -q main
git checkout -qb fix-typo
sed -i '' 's/dependency-free/dependency free/' README.md 2>/dev/null || sed -i 's/dependency-free/dependency free/' README.md
git add -A && git commit -qm "fix typo"
git push -q origin fix-typo
p2="$(gh pr create --repo "$REPO" --head fix-typo --title "fix typo" --body "fixed typo")"

# PR 3: borderline. Linked to an issue nobody assigned to the author; verbose, untested code.
git checkout -q main
git checkout -qb feat/slugify
cat >> textkit/core.py <<'EOF'


def slugify(text):
    # This function converts the given text into a slug.
    # A slug is a URL-friendly version of a string.
    # First, we convert the text to lowercase.
    result = text.lower()
    # Next, we replace spaces with hyphens.
    result = result.replace(" ", "-")
    # Then, we remove any characters that are not alphanumeric or hyphens.
    final_result = ""
    for character in result:
        if character.isalnum() or character == "-":
            final_result = final_result + character
    # Finally, we return the final result.
    return final_result
EOF
git add -A && git commit -qm "Add slugify"
git push -q origin feat/slugify
p3="$(gh pr create --repo "$REPO" --head feat/slugify --title "Add slugify() helper" \
  --body "Closes #$i1

This PR introduces a robust, production-ready slugify function that converts any text into a clean, URL-friendly slug, improving the overall developer experience of the library.")"

cat <<EOF

Seeded https://github.com/$REPO

Issues
  #$i1 slugify            free (but PR ${p3##*/} claims it without an assignment)
  #$i2 word_count bug     held by $me
  #$i3 --json             free
  #$i4 title_case bug     free
  #$i5 truncate           held by $me (PR ${p1##*/} is the clean one)
  #$i6 README docs        free
  #$i7 type hints         held by $me (use for the stale-assignment demo)
  #$i8 CI 3.13            not labelled hackathon, so not claimable

Pull requests
  #${p1##*/} clean        $p1
  #${p2##*/} low effort   $p2
  #${p3##*/} borderline   $p3

Next: TARGET_REPO=$REPO bin/desk sweep
EOF
