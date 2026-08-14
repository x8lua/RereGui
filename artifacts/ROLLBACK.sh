#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's|Value = "InsertService:LoadLocalAsset -> game:GetObjects"|Value = "game:GetObjects only"|' "$target.before-rollback" > "$target"
grep -q 'Value = "game:GetObjects only"' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
