#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for changing Hyprland Layouts (Master or Dwindle) on the fly
#
# Under the Lua config `hyprctl keyword` is gone: options go through bin/hlset
# and binds go through `hyprctl eval` with hl.bind / hl.unbind.
#
# NOTE: this takes SUPER+J and SUPER+K away from the vim-motion focus binds in
# lua/binds_user.lua for as long as the alternate layout is active. A config
# reload (SUPER+ALT+R) puts them back.

notif="$HOME/.config/swaync/images/ja.png"
HLSET="$HOME/repos/dotfiles/bin/hlset"

LAYOUT=$(hyprctl -j getoption general:layout | jq '.str' | sed 's/"//g')

case $LAYOUT in
"master")
	"$HLSET" general:layout dwindle >/dev/null
	hyprctl eval '
		hl.unbind("SUPER + J")
		hl.unbind("SUPER + K")
		hl.bind("SUPER + J", hl.dsp.window.cycle_next(),             { description = "next window" })
		hl.bind("SUPER + K", hl.dsp.window.cycle_next({prev=true}),  { description = "previous window" })
		hl.bind("SUPER + O", hl.dsp.layout("togglesplit"),           { description = "toggle split" })
	' >/dev/null
	notify-send -e -u low -i "$notif" " Dwindle Layout"
	;;
"dwindle")
	"$HLSET" general:layout master >/dev/null
	hyprctl eval '
		hl.unbind("SUPER + J")
		hl.unbind("SUPER + K")
		hl.unbind("SUPER + O")
		hl.bind("SUPER + J", hl.dsp.layout("cyclenext"), { description = "next window in master" })
		hl.bind("SUPER + K", hl.dsp.layout("cycleprev"), { description = "previous window in master" })
	' >/dev/null
	notify-send -e -u low -i "$notif" " Master Layout"
	;;
*) ;;

esac
