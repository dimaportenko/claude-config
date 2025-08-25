#!/bin/bash

# Helper script to send notifications with custom icon
# Usage: ./send-notification.sh "title" "message" [sound]

title="$1"
message="$2"
sound="${3:-Tink}"

# Use our custom notification app which has the custom icon
app_path="$HOME/.claude/hooks/ClaudeNotifier.app"

# Send notification through our custom app
open -a "$app_path" --args "$title" "$message" "$sound"