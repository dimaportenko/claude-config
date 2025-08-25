#!/bin/bash

# Claude Code Notification Hook - macOS Notification for waiting input
# This script sends a notification when Claude Code is waiting for user input

# Read JSON input from Claude Code
input=$(cat)

# Extract relevant information from the JSON input
hook_event=$(echo "$input" | jq -r '.hook_event_name // "Notification"')
notification_message=$(echo "$input" | jq -r '.message // ""')
session_id=$(echo "$input" | jq -r '.session_id // "unknown"')

# Skip empty notifications
if [[ -z "$notification_message" || "$notification_message" == "null" ]]; then
    exit 0
fi

# Get short session ID for reference (last 8 characters)
if [[ "$session_id" != "unknown" ]]; then
    short_session_id="${session_id: -8}"
    session_ref=" • Session: $short_session_id"
else
    session_ref=""
fi

# Get current time
current_time=$(date "+%H:%M")

# Check if this is about waiting for input
if [[ "$notification_message" == *"waiting for your input"* ]]; then
    # Create notification message for waiting input
    title="Claude Code Waiting"
    message="Claude is waiting • Ready at $current_time$session_ref"
    sound="Glass"
else
    # Generic notification for other cases
    title="Claude Code Notification"
    message="$notification_message$session_ref"
    sound="Pop"
fi

# Send macOS notification with custom icon
"$HOME/.claude/hooks/send-notification.sh" "$title" "$message" "$sound"

# Log the event for debugging
echo "$(date): Claude Code notification hook - $title: $message" >> ~/.claude/hooks/notify-waiting-input.log