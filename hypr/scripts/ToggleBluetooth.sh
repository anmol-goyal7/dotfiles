#!/bin/bash
# Toggle Bluetooth on/off and send a notification
# Clears rfkill soft-block first, or "power on" silently fails

if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
    notify-send -i bluetooth-disabled "Bluetooth" "Turned OFF"
else
    rfkill unblock bluetooth
    sleep 0.5   # bluetoothd auto-powers on unblock; explicit power-on races with it
    bluetoothctl show | grep -q "Powered: yes" || bluetoothctl power on
    notify-send -i bluetooth "Bluetooth" "Turned ON"
fi
