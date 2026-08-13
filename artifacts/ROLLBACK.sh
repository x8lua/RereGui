#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's#Value = "Enum.Font.Code"#Value = "RobotoMono Regular"#' "$target.before-rollback" > "$target"
grep -q 'Value = "RobotoMono Regular"' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
