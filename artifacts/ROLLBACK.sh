#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's#RobotoMono Regular + ▼/▶#Enum.Font.Code + v/>#' "$target.before-rollback" > "$target"
grep -q 'Enum.Font.Code + v/>' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
