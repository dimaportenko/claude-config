#!/bin/bash

# Helper script to send notifications with custom icon
# Usage: ./send-notification.sh "title" "message" [sound]

title="$1"
message="$2"
sound="${3:-Tink}"

# For now, use enhanced osascript notifications
# Add distinctive emoji to make Claude notifications stand out
case "$title" in
    "Claude Code Ready")
        enhanced_title="🤖 $title"
        ;;
    "Claude Code Waiting")
        enhanced_title="⏳ $title" 
        ;;
    "Claude Code Notification")
        enhanced_title="🔔 $title"
        ;;
    *)
        enhanced_title="🤖 $title"
        ;;
esac

osascript -e "display notification \"$message\" with title \"$enhanced_title\" sound name \"$sound\""