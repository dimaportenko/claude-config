#!/bin/bash

# Claude Code Stop Hook - macOS Notification
# This script sends a notification when Claude Code finishes responding

# Read JSON input from Claude Code
input=$(cat)

# Extract relevant information from the JSON input
session_cost=$(echo "$input" | jq -r '.session_cost_usd // "unknown"')
active_time=$(echo "$input" | jq -r '.active_time_ms // null' | sed 's/null/unknown/')
hook_event=$(echo "$input" | jq -r '.hook_event_name // "Claude Code"')

# Format active time if available
if [[ "$active_time" != "unknown" ]]; then
    active_seconds=$((active_time / 1000))
    if [[ $active_seconds -gt 60 ]]; then
        active_minutes=$((active_seconds / 60))
        remaining_seconds=$((active_seconds % 60))
        active_time_formatted="${active_minutes}m ${remaining_seconds}s"
    else
        active_time_formatted="${active_seconds}s"
    fi
else
    active_time_formatted="unknown"
fi

# Format cost display
if [[ "$session_cost" != "unknown" ]]; then
    cost_display="Cost: \$${session_cost}"
else
    cost_display="Cost: unknown"
fi

# Create notification message
title="Claude Code Finished"
message="Session complete - Time: ${active_time_formatted}, ${cost_display}"

# Send macOS notification with custom icon
"$HOME/.claude/hooks/send-notification.sh" "$title" "$message" "Tink"

# Log the event for debugging
echo "$(date): Claude Code stop hook - $message" >> ~/.claude/hooks/notify-on-stop.log