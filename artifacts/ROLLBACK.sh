#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's#Value = "15"#Value = "13"#' "$target.before-rollback" > "$target"
grep -q 'Value = "13"' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
