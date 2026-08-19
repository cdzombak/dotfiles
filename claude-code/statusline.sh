#!/bin/bash
# Claude Code status line script
# Shows: ~/path/to/dir branch (yellow if dirty, green if clean)

input=$(cat)
model_name=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
cwd_display="${cwd/#$HOME/~}"

git_info=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
    if [[ -z "$branch" ]]; then
        branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
        git_prefix="➦"
    else
        git_prefix=""
    fi

    if [[ -n $(git -C "$cwd" status --porcelain 2>/dev/null | tail -n1) ]]; then
        color=$'\033[33m'  # Yellow (dirty)
    else
        color=$'\033[32m'  # Green (clean)
    fi

    reset=$'\033[0m'
    git_info=" ${color}${git_prefix}${branch}${reset}"
fi

white=$'\033[37m'
reset_cwd=$'\033[0m'

printf "[%s] %s%s%s%s" "$model_name" "$white" "$cwd_display" "$reset_cwd" "$git_info"
