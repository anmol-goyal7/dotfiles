#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For disabling touchpad. Bound to XF86TouchpadToggle.
#
# The device name comes from `hyprctl devices`; it is also set in
# hypr/lua/settings.lua, which is what defines the device at startup.
#
# JaKooLit's version drove a `$TOUCHPAD_ENABLED` config variable through
# `hyprctl keyword`. The Lua config has neither: there are no $variables, and
# keyword is disabled. hl.device sets the device straight instead.

notif="$HOME/.config/swaync/images/ja.png"
TOUCHPAD_DEVICE="asue1209:00-04f3:319f-touchpad"

export STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

set_touchpad() { # set_touchpad true|false
    hyprctl eval "hl.device({ name = \"$TOUCHPAD_DEVICE\", enabled = $1 })" >/dev/null
}

enable_touchpad() {
    printf "true" >"$STATUS_FILE"
    notify-send -u low -i "$notif" " Enabling" " touchpad"
    set_touchpad true
}

disable_touchpad() {
    printf "false" >"$STATUS_FILE"
    notify-send -u low -i "$notif" " Disabling" " touchpad"
    set_touchpad false
}

if ! [ -f "$STATUS_FILE" ]; then
  enable_touchpad
else
  if [ "$(cat "$STATUS_FILE")" = "true" ]; then
    disable_touchpad
  elif [ "$(cat "$STATUS_FILE")" = "false" ]; then
    enable_touchpad
  fi
fi
