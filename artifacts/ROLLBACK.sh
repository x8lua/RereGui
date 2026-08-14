#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's|Value = "#1D2532 #2F72B6 + 0.65 text stroke"|Value = "2px tab spacing + regular code text"|' "$target.before-rollback" > "$target"
grep -q 'Value = "2px tab spacing + regular code text"' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
