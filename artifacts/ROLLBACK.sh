#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's|Value = "Full ReGui example with executor loader"|Value = "Short demo"|' "$target.before-rollback" > "$target"
grep -q 'Value = "Short demo"' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
