#!/bin/bash

# Claude Code Notification Hook - macOS Notification for waiting input
# This script sends a notification when Claude Code is waiting for user input

# Read JSON input from Claude Code
input=$(cat)

# Extract relevant information from the JSON input
hook_event=$(echo "$input" | jq -r '.hook_event_name // "Notification"')
notification_text=$(echo "$input" | jq -r '.text // ""')

# Check if this is about waiting for input
if [[ "$notification_text" == *"waiting for your input"* ]]; then
    # Create notification message for waiting input
    title="Claude Code Waiting"
    message="Ready for your input - check terminal"
    sound="Ping"
else
    # Generic notification for other cases
    title="Claude Code Notification"
    message="$notification_text"
    sound="Pop"
fi

# Send macOS notification with custom icon
"$HOME/.claude/hooks/send-notification.sh" "$title" "$message" "$sound"

# Log the event for debugging
echo "$(date): Claude Code notification hook - $title: $message" >> ~/.claude/hooks/notify-waiting-input.log