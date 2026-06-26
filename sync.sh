#!/bin/bash

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$HOME/crontab-log-file.txt"

echo "$(date): configs auto-sync started" >> "$LOG"

cd "$REPO_DIR"
if ! git diff --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    git add -A
    git commit -m "auto-sync: $(date '+%Y-%m-%d %H:%M')"
    if git push origin main >> "$LOG" 2>&1; then
        echo "$(date): configs sync succeeded" >> "$LOG"
    else
        echo "$(date): configs sync FAILED" >> "$LOG"
    fi
else
    echo "$(date): configs no changes, skipping sync" >> "$LOG"
fi
