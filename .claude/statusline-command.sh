#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract useful information
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
agent_name=$(echo "$input" | jq -r '.agent.name // empty')

# Get username and hostname
user=$(whoami)
host=$(hostname -s)

# Get git branch if in a git repository
cd "$cwd" 2>/dev/null
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    git_info=" $(printf '\033[35m')($branch)$(printf '\033[0m')"
else
    git_info=""
fi

# Build status line
status=""

# User@host in cyan
status+="$(printf '\033[36m')$user@$host$(printf '\033[0m') "

# Current directory in blue (basename only)
status+="$(printf '\033[34m')$(basename "$cwd")$(printf '\033[0m')"

# Git branch if available
status+="$git_info"

# Model info in green
status+=" $(printf '\033[32m')[$model]$(printf '\033[0m')"

# Output style if not default
if [ -n "$output_style" ] && [ "$output_style" != "default" ]; then
    status+=" $(printf '\033[33m')[$output_style]$(printf '\033[0m')"
fi

# Context used if available
if [ -n "$used" ]; then
    status+=" $(printf '\033[90m')ctx:${used}%$(printf '\033[0m')"
fi

# Vim mode if enabled
if [ -n "$vim_mode" ]; then
    if [ "$vim_mode" = "INSERT" ]; then
        status+=" $(printf '\033[32m')[INSERT]$(printf '\033[0m')"
    else
        status+=" $(printf '\033[33m')[NORMAL]$(printf '\033[0m')"
    fi
fi

# Agent name if running as agent
if [ -n "$agent_name" ]; then
    status+=" $(printf '\033[95m')[agent:$agent_name]$(printf '\033[0m')"
fi

echo "$status"
