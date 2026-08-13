#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's#loadstring or load#loadstring(game:HttpGet(...))#' "$target.before-rollback" > "$target"
grep -q 'loadstring(game:HttpGet(...))' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
