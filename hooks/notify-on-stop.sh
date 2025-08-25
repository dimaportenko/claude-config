#!/bin/bash

# Claude Code Stop Hook - macOS Notification
# This script sends a notification when Claude Code finishes responding

# Read JSON input from Claude Code
input=$(cat)

# Extract relevant information from the JSON input
session_id=$(echo "$input" | jq -r '.session_id // "unknown"')
hook_event=$(echo "$input" | jq -r '.hook_event_name // "Claude Code"')

# Get short session ID for reference (last 8 characters)
if [[ "$session_id" != "unknown" ]]; then
    short_session_id="${session_id: -8}"
    session_ref=" • Session: $short_session_id"
else
    session_ref=""
fi

# Get current time for completion timestamp
completion_time=$(date "+%H:%M")

# Create notification message
title="Claude Code Ready"
message="Session complete at $completion_time$session_ref"

# Send macOS notification with custom icon
"$HOME/.claude/hooks/send-notification.sh" "$title" "$message" "Tink"

# Log the event for debugging
echo "$(date): Claude Code stop hook - $message" >> ~/.claude/hooks/notify-on-stop.log