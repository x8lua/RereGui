#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's|Value = "#0E1218 #0F1319 #1E2634 #3F6F9B #1E3D5D"|Value = "Bright blue title and headers"|' "$target.before-rollback" > "$target"
grep -q 'Value = "Bright blue title and headers"' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
