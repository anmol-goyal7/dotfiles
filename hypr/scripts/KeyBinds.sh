#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# searchable enabled keybinds using rofi
#
# This used to cat the .conf files and grep for ^bind. Those are gone with the
# move to the Lua config, so it reads the live bind registry that
# hypr/lua/util.lua keeps inside the compositor -- same source as bin/keys
# (Super+/), which is the interactive version of this.

# kill yad to not interfere with this binds
pkill yad || true

# check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

rofi_theme="$HOME/.config/rofi/config-keybinds.rasi"
msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO function'

if [[ -z ${HYPRLAND_INSTANCE_SIGNATURE:-} ]]; then
    echo "KeyBinds.sh: needs a running Hyprland session" >&2
    exit 1
fi

# index \t combo \t description \t runnable -> "combo    description"
keybinds=$(hyprctl repl 'return KEYS_LIST()' 2>/dev/null |
    awk -F'\t' 'NF >= 3 { printf "%-28s %s\n", $2, $3 }')

if [[ -z "$keybinds" ]]; then
    echo "no keybinds found."
    exit 1
fi

echo "$keybinds" | rofi -dmenu -i -config "$rofi_theme" -mesg "$msg"
