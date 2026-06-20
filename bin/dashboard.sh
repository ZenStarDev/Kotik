#!/usr/bin/env bash
# kotik dashboard - Command Center style terminal layout

set -euo pipefail

SESSION="kotik-dashboard"

tmux kill-session -t "$SESSION" 2>/dev/null || true

tmux new-session -d -s "$SESSION" -n "main"

tmux split-window -t "$SESSION:0" -v -p 34

tmux split-window -t "$SESSION:0.0" -h -p 50

tmux send-keys -t "$SESSION:0.0" "btop" Enter

if command -v pipes.sh &>/dev/null; then
    tmux send-keys -t "$SESSION:0.1" "pipes.sh" Enter
else
    tmux send-keys -t "$SESSION:0.1" "echo 'pipes.sh not found - install from https://github.com/pipeseroni/pipes.sh'" Enter
fi

if command -v cmatrix &>/dev/null; then
    tmux send-keys -t "$SESSION:0.2" "cmatrix -b" Enter
else
    tmux send-keys -t "$SESSION:0.2" "while true; do clear; echo 'System: '"$(uname -sm)""; echo 'Host: '"$(hostname)""; echo 'Uptime: '"$(uptime -p 2>/dev/null || cut -d' ' -f4-5 /proc/uptime 2>/dev/null || echo 'unknown')""; echo 'Load: '"$(cut -d' ' -f1-3 /proc/loadavg)""; echo 'Disk: '"$(df -h / | awk 'NR==2{print $3"/"$4" ("$5")')"'"; echo 'Memory: '"$(free | awk 'NR==2{print $3"/"$2" MB"}')""; sleep 1; done" Enter
fi

tmux select-pane -t "$SESSION:0.0"

tmux set-option -t "$SESSION" pane-border-style fg=cyan
tmux set-option -t "$SESSION" pane-active-border-style fg=green
tmux set-option -t "$SESSION" status-bg=black
tmux set-option -t "$SESSION" status-fg=cyan

tmux attach-session -t "$SESSION"