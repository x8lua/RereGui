#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's|Value = "ReGui 1.3.2 complete element registry"|Value = "simplified RereGui primitives"|' "$target.before-rollback" > "$target"
grep -q 'Value = "simplified RereGui primitives"' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
