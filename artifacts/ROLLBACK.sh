#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's/Color3.fromRGB(42, 114, 181)/Color3.fromRGB(41, 74, 122)/' "$target.before-rollback" > "$target"
grep -q 'Color3.fromRGB(41, 74, 122)' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
