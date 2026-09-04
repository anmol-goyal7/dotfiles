#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Game Mode. Turning off all animations
#
# `hyprctl reload` below re-reads the config, which drops the red tint — it is
# set at runtime and written down nowhere. Put it back afterwards.
#
# Under the Lua config `hyprctl keyword` is gone: options go through bin/hlset,
# window rules through `hyprctl eval`.
#
# The swww / wallust wallpaper restore that JaKooLit puts in the "off" branch
# is not here: there is no wallpaper daemon on this machine (swww is not even
# installed), the desktop is misc.background_color black for the OLED panel.

notif="$HOME/.config/swaync/images/ja.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
RED="$HOME/repos/dotfiles/bin/red"
HLSET="$HOME/repos/dotfiles/bin/hlset"

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    "$HLSET" \
        animations:enabled 0 \
        decoration:shadow:enabled 0 \
        decoration:blur:enabled 0 \
        general:gaps_in 0 \
        general:gaps_out 0 \
        general:border_size 1 \
        decoration:rounding 0 >/dev/null

    hyprctl eval 'hl.window_rule({
        name    = "gamemode-opacity",
        match   = { class = ".*" },
        opacity = "1 override 1 override 1 override",
    })' >/dev/null

    notify-send -e -u low -i "$notif" " Gamemode:" " enabled"
    exit
fi

# Off: a plain reload puts every one of those back, rule included.
hyprctl reload
"$RED" reapply
"${SCRIPTSDIR}"/Refresh.sh
notify-send -e -u normal -i "$notif" " Gamemode:" " disabled"
