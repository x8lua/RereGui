#!/usr/bin/env sh
set -eu
target="${1:?usage: ROLLBACK.sh <copy> }"
cp "$target" "$target.before-rollback"
sed 's#gethui() -> syn.protect_gui/CoreGui#Players.LocalPlayer.PlayerGui#' "$target.before-rollback" > "$target"
grep -q 'Players.LocalPlayer.PlayerGui' "$target"
printf '%s\n' 'rollback result: restored behavior/status'
