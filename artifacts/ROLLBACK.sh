#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
target="$repo_dir/artifacts/ROLLBACK_COPY.lua"
baseline="$repo_dir/artifacts/BASELINE_FILE.lua"
modified="$repo_dir/artifacts/MODIFIED_FILE.lua"

cp "$modified" "$target"
cp "$baseline" "$target"
cmp -s "$baseline" "$target"
printf '%s\n' 'rollback restored ROLLBACK_COPY.lua to BASELINE_FILE.lua'
