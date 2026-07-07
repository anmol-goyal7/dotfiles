#!/bin/bash
# Refresh the desktop shell after config changes:
# restarts waybar + swaync + quickshell, kills stray rofi.
# Bound to SUPER + ALT + R.

for p in waybar rofi swaync; do
  pidof "$p" >/dev/null && pkill "$p"
done

# quickshell (SUPER+A overview)
pkill qs 2>/dev/null
qs >/dev/null 2>&1 & disown

sleep 1
waybar >/dev/null 2>&1 & disown

sleep 0.5
swaync >/dev/null 2>&1 & disown
swaync-client --reload-config >/dev/null 2>&1

exit 0
