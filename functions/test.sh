#!/bin/bash
#
BOT_TOKEN="7365912108:AAFyxfLGajkw40-3zRgX-0F691Z4BXx3G9M"
CHAT_ID="317128139"           # Replace with the group chat ID
MESSAGE="Hello, this is a test message from my Bash script!" # Replace with your message

# Send the message using curl
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" -d text="$MESSAGE"
