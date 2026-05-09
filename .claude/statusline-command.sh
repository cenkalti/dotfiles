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

# Work agent handle (from ~/.work/agents/$AGENT_ID.json, populated when
# Claude Code is launched via `agent run`).
work_handle=""
if [ -n "$AGENT_ID" ]; then
    agent_record="$HOME/.work/agents/$AGENT_ID.json"
    if [ -r "$agent_record" ]; then
        work_repo=$(jq -r '.repo // empty' "$agent_record" 2>/dev/null)
        work_name=$(jq -r '.name // empty' "$agent_record" 2>/dev/null)
        if [ -n "$work_repo" ] && [ -n "$work_name" ]; then
            work_handle="$(basename "$work_repo")/$work_name"
        elif [ -n "$work_repo" ]; then
            work_handle="$(basename "$work_repo")/"
        elif [ -n "$work_name" ]; then
            work_handle="$work_name"
        fi
    fi
fi

# Get git branch and dirty status if in a git repository
cd "$cwd" 2>/dev/null
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if git --no-optional-locks status --porcelain 2>/dev/null | grep -q .; then
        dirty_indicator="$(printf '\033[31m')*$(printf '\033[0m')"
    else
        dirty_indicator=""
    fi
    git_info=" $(printf '\033[35m')($branch)$(printf '\033[0m')$dirty_indicator"
else
    git_info=""
fi

# Build status line
status=""

# For agents, show the agent handle in cyan; otherwise show the basename
# of the current working directory in blue.
if [ -n "$work_handle" ]; then
    status+="$(printf '\033[36m')$work_handle$(printf '\033[0m')"
else
    status+="$(printf '\033[34m')$(basename "$cwd")$(printf '\033[0m')"
fi

# Git branch if available
status+="$git_info"

# Model info in green
status+=" $(printf '\033[32m')[$model]$(printf '\033[0m')"

# Output style if not default
if [ -n "$output_style" ] && [ "$output_style" != "default" ]; then
    status+=" $(printf '\033[33m')[$output_style]$(printf '\033[0m')"
fi

# Context used if available, with color ramping by usage
if [ -n "$used" ]; then
    used_int=${used%.*}
    if [ "$used_int" -ge 85 ] 2>/dev/null; then
        ctx_color='\033[31m'      # red
    elif [ "$used_int" -ge 70 ] 2>/dev/null; then
        ctx_color='\033[38;5;208m' # orange
    elif [ "$used_int" -ge 50 ] 2>/dev/null; then
        ctx_color='\033[33m'      # yellow
    else
        ctx_color='\033[90m'      # dim gray
    fi
    status+=" $(printf "$ctx_color")ctx:${used}%$(printf '\033[0m')"
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
