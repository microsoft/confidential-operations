#!/bin/bash

url="$1"

if [ -z "$url" ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

if [ -n "$BROWSER" ]; then
    "$BROWSER" "$url" &
elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url" &
elif command -v gnome-open >/dev/null 2>&1; then
    gnome-open "$url" &
elif command -v open >/dev/null 2>&1; then  # For macOS
    open "$url" &
elif command -v start >/dev/null 2>&1; then  # For Windows with Git Bash
    start "$url"
else
    echo "Please open the following URL in your browser:"
    echo "$url"
fi