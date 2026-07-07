#!/bin/bash
# Tab switching for Hyprland Super+hjkl binds
# Usage: TabSwitch.sh next|prev

DIR="${1:-next}"
WIN_JSON=$(hyprctl activewindow -j 2>/dev/null)
CLASS=$(echo "$WIN_JSON" | grep -oP '"class":\s*"\K[^"]+')
PID=$(echo "$WIN_JSON" | grep -oP '"pid":\s*\K[0-9]+')

case "$CLASS" in
    kitty)
        SOCK="unix:/tmp/kitty-$PID"
        if [ "$DIR" = "prev" ]; then
            kitty @ --to="$SOCK" action previous_tab
        else
            kitty @ --to="$SOCK" action next_tab
        fi
        ;;
    *)
        if [ "$DIR" = "prev" ]; then
            wtype -M ctrl -k Prior -m ctrl
        else
            wtype -M ctrl -k Next -m ctrl
        fi
        ;;
esac
