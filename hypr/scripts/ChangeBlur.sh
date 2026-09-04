#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for changing blurs on the fly
#
# hyprctl keyword is disabled under the Lua config; bin/hlset wraps hyprctl eval.

notif="$HOME/.config/swaync/images"
HLSET="$HOME/repos/dotfiles/bin/hlset"

STATE=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

if [ "${STATE}" == "2" ]; then
	"$HLSET" decoration:blur:size 2 decoration:blur:passes 1 >/dev/null
 	notify-send -e -u low -i "$notif/note.png" " Less Blur"
else
	"$HLSET" decoration:blur:size 5 decoration:blur:passes 2 >/dev/null
  	notify-send -e -u low -i "$notif/ja.png" " Normal Blur"
fi
