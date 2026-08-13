#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's#local textObject = object :: any#(object :: any).Text = value#' "$target.before-rollback" > "$target"
grep -q '(object :: any).Text = value' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
